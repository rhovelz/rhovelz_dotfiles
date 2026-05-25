#!/usr/bin/env python
import os
import sys
import argparse
import subprocess
from datetime import datetime

# ── Konfigurasi ───────────────────────────────────────────────────────────────
screenshot_dir   = "/home/xv4nz7/Picts/Screenshots"
color_profile    = "/usr/share/color/icc/colord/sRGB.icc"
color_bg         = "#44475a"
border_size      = "5"
background_color = "white"
background_size  = "10"
shadow_size      = "50x10+0+10"
font             = "JetBrainsMono-NF-Medium"
font_size        = "15"
color_fg         = "#FFFFFF"
author_position  = ["NorthEast", "+50+12"]
author           = "RADIVAN"

# ── Konfigurasi HD ────────────────────────────────────────────────────────────
hd_scale         = "2"       # 2x upscale — ubah ke "1.5" atau "3" sesuai kebutuhan
hd_filter        = "Lanczos" # Filter terbaik untuk upscale (tajam & smooth)
hd_sharpen       = "0x0.5"   # Unsharp mask setelah upscale agar tidak blur

# ── Deteksi environment ───────────────────────────────────────────────────────
is_wsl = "microsoft" in subprocess.getoutput("uname -r").lower()

# ── Argumen CLI ───────────────────────────────────────────────────────────────
parser = argparse.ArgumentParser(
    description="Screenshot tool — otomatis detect monitor aktif dari posisi cursor",
    formatter_class=argparse.RawTextHelpFormatter
)
parser.add_argument(
    "--monitor", "-m",
    default="auto",
    metavar="N|all|auto",
    help=(
        "Monitor yang di-screenshot:\n"
        "  auto     → ikuti posisi cursor mouse (default)\n"
        "  1        → monitor utama / primary\n"
        "  2, 3,... → monitor ke-N\n"
        "  all      → semua monitor (file terpisah per monitor)"
    )
)
parser.add_argument(
    "--list", "-l",
    action="store_true",
    help="Tampilkan daftar semua monitor yang terhubung lalu keluar"
)
args = parser.parse_args()

# ── Fungsi: ambil daftar semua monitor (WSL via PowerShell) ──────────────────
def get_monitors_wsl():
    ps_script = r"""
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.Screen]::AllScreens | ForEach-Object {
        "$($_.DeviceName)|$($_.Bounds.X)|$($_.Bounds.Y)|$($_.Bounds.Width)|$($_.Bounds.Height)|$($_.Primary)"
    }
    """
    result = subprocess.check_output(
        ["powershell.exe", "-NoProfile", "-Command", ps_script]
    ).decode().strip()

    monitors = []
    for line in result.splitlines():
        line = line.strip()
        if not line:
            continue
        parts = line.split("|")
        if len(parts) < 6:
            continue
        name, x, y, w, h, primary = parts
        monitors.append({
            "name":    name.strip(),
            "x":       int(x),
            "y":       int(y),
            "width":   int(w),
            "height":  int(h),
            "primary": primary.strip().lower() == "true"
        })

    # Urutkan: primary dulu, lalu sisanya berdasarkan posisi X
    monitors.sort(key=lambda m: (not m["primary"], m["x"]))
    return monitors

# ── Fungsi: deteksi monitor aktif dari posisi cursor (WSL) ───────────────────
def get_active_monitor_wsl(monitors):
    ps_script = r"""
    Add-Type -AssemblyName System.Windows.Forms
    $pos = [System.Windows.Forms.Cursor]::Position
    "$($pos.X)|$($pos.Y)"
    """
    result = subprocess.check_output(
        ["powershell.exe", "-NoProfile", "-Command", ps_script]
    ).decode().strip()

    cx, cy = map(int, result.split("|"))
    print(f"[i] Posisi cursor: ({cx}, {cy})")

    for mon in monitors:
        in_x = mon["x"] <= cx < mon["x"] + mon["width"]
        in_y = mon["y"] <= cy < mon["y"] + mon["height"]
        if in_x and in_y:
            return mon

    # Fallback ke primary jika cursor di luar semua monitor (jarang terjadi)
    print("[!] Cursor tidak terdeteksi di monitor manapun, fallback ke primary.")
    return next((m for m in monitors if m["primary"]), monitors[0])

# ── Fungsi: capture satu monitor ke file (WSL) ───────────────────────────────
def capture_monitor_wsl(monitor, out_path_wsl):
    win_path = subprocess.check_output(
        ["wslpath", "-w", os.path.abspath(out_path_wsl)]
    ).decode().strip()

    ps_script = f"""
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    $x      = {monitor['x']}
    $y      = {monitor['y']}
    $width  = {monitor['width']}
    $height = {monitor['height']}
    $bitmap   = New-Object System.Drawing.Bitmap $width, $height
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.CopyFromScreen($x, $y, 0, 0, $bitmap.Size)
    $bitmap.Save("{win_path}", [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $bitmap.Dispose()
    """
    subprocess.run(
        ["powershell.exe", "-NoProfile", "-Command", ps_script],
        check=True
    )

# ── Fungsi: copy file gambar ke clipboard (WSL) ──────────────────────────────
def copy_to_clipboard_wsl(file_path_wsl):
    win_path = subprocess.check_output(
        ["wslpath", "-w", os.path.abspath(file_path_wsl)]
    ).decode().strip()

    ps_clip = f"""
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    $img = [System.Drawing.Image]::FromFile("{win_path}")
    [System.Windows.Forms.Clipboard]::SetImage($img)
    $img.Dispose()
    """
    subprocess.run(
        ["powershell.exe", "-NoProfile", "-Command", ps_clip],
        check=True
    )

# ── Fungsi: proses ImageMagick (border, shadow, watermark, HD upscale) ───────
def process_imagemagick(original_file, target_file):
    half_bg = int(background_size) // 2

    os.system(rf"""
convert {original_file} -bordercolor '{color_bg}' -border {border_size} {target_file}

convert {target_file} \
     \( +clone  -alpha extract \
        -draw 'fill black polygon 0,0 0,5 5,0 fill white circle 5,5 5,0' \
        \( +clone -flip \) -compose Multiply -composite \
        \( +clone -flop \) -compose Multiply -composite \
     \) -alpha off -compose CopyOpacity -composite {target_file}

convert {target_file} \( +clone -background black \
-shadow {shadow_size} \) +swap -background none \
-layers merge +repage {target_file}

convert {target_file} -bordercolor {background_color} -border {background_size} {target_file}

echo -n " {author} " | convert {target_file} \
-gravity {author_position[0]} -pointsize {font_size} -fill '{color_fg}' \
-undercolor '{color_bg}' -font {font} \
-annotate {author_position[1]} ' -{author}- ' {target_file}

convert {target_file} -gravity South -chop 0x{half_bg} {target_file}

convert {target_file} -gravity North -background {background_color} \
-splice 0x{half_bg} {target_file}

convert {target_file} \
    -filter {hd_filter} \
    -resize {hd_scale}00% \
    -unsharp {hd_sharpen} \
    {target_file}

convert {target_file} -profile {color_profile} {target_file}
""")

# ── Fungsi: proses satu screenshot (capture → imagemagick → clipboard) ───────
def process_screenshot(monitor, label=""):
    os.chdir(screenshot_dir)

    timestamp     = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    suffix        = f"_MON{label}" if label else ""
    original_file = f"Screenshot_{timestamp}{suffix}.png"
    target        = list(original_file)
    target.insert(-4, 'X')
    target_file   = ''.join(target)

    # Capture
    if is_wsl:
        capture_monitor_wsl(monitor, original_file)
    else:
        try:
            result = subprocess.run(["slurp"], capture_output=True)
            if result.returncode != 0:
                if os.path.exists(original_file):
                    os.remove(original_file)
                sys.exit(2)
            region = result.stdout.decode().strip()
            with open(original_file, "wb") as f:
                grim = subprocess.run(["grim", "-g", region, "-"], stdout=f)
                if grim.returncode != 0:
                    raise subprocess.CalledProcessError(grim.returncode, "grim")
        except FileNotFoundError:
            try:
                subprocess.run(
                    ["flameshot", "gui", "--raw"],
                    stdout=open(original_file, "wb"),
                    check=True
                )
            except subprocess.CalledProcessError:
                if os.path.exists(original_file):
                    os.remove(original_file)
                sys.exit(2)
        except subprocess.CalledProcessError:
            if os.path.exists(original_file):
                os.remove(original_file)
            sys.exit(1)

    # Validasi capture
    if not os.path.exists(original_file) or os.path.getsize(original_file) == 0:
        print(f"[!] Screenshot monitor {label} aborted atau kosong.")
        if os.path.exists(original_file):
            os.remove(original_file)
        return None

    # Proses ImageMagick
    process_imagemagick(original_file, target_file)

    # Validasi hasil ImageMagick
    if not os.path.exists(target_file) or os.path.getsize(target_file) == 0:
        print(f"[!] ImageMagick gagal untuk monitor {label}.")
        if os.path.exists(original_file):
            os.remove(original_file)
        return None

    # Optimasi PNG
    if os.system("which optipng > /dev/null 2>&1") == 0:
        os.system(f"optipng {target_file}")

    # Cleanup original
    if os.path.exists(original_file):
        os.remove(original_file)

    print(f"[✓] Done: {target_file}")
    return target_file

# ══════════════════════════════════════════════════════════════════════════════
# ── MAIN ─────────────────────────────────────────────────────────────────────
# ══════════════════════════════════════════════════════════════════════════════

os.makedirs(screenshot_dir, exist_ok=True)

# Ambil daftar monitor
if is_wsl:
    monitors = get_monitors_wsl()
else:
    monitors = [{"name": "Primary", "x": 0, "y": 0, "width": 0, "height": 0, "primary": True}]

# ── --list: tampilkan monitor lalu keluar ────────────────────────────────────
if args.list:
    print(f"\n{'No':<4} {'Nama':<25} {'Resolusi':<16} {'Posisi':<16} {'Status'}")
    print("-" * 72)
    for i, m in enumerate(monitors, start=1):
        status = "PRIMARY" if m["primary"] else ""
        res    = f"{m['width']}x{m['height']}"
        pos    = f"({m['x']}, {m['y']})"
        print(f"{i:<4} {m['name']:<25} {res:<16} {pos:<16} {status}")
    print()
    sys.exit(0)

# ── --monitor all: screenshot semua monitor ──────────────────────────────────
if args.monitor.lower() == "all":
    results = []
    for i, mon in enumerate(monitors, start=1):
        result = process_screenshot(mon, label=str(i))
        if result:
            results.append(result)

    # Copy monitor pertama ke clipboard
    if results and is_wsl:
        copy_to_clipboard_wsl(results[0])
        print(f"[✓] Clipboard: {results[0]}")

    sys.exit(0 if results else 1)

# ── --monitor auto: deteksi dari posisi cursor (DEFAULT) ─────────────────────
if args.monitor.lower() == "auto":
    if is_wsl:
        selected_monitor = get_active_monitor_wsl(monitors)
    else:
        selected_monitor = monitors[0]

    # Cari nomor index monitor yang terpilih untuk label file
    mon_index = next(
        (i for i, m in enumerate(monitors, start=1) if m["name"] == selected_monitor["name"]),
        1
    )
    print(f"[i] Monitor aktif (cursor): {mon_index} — {selected_monitor['name']} "
          f"({selected_monitor['width']}x{selected_monitor['height']})")

    label = str(mon_index) if len(monitors) > 1 else ""
    target_file = process_screenshot(selected_monitor, label=label)

    if target_file is None:
        sys.exit(1)

    if is_wsl:
        copy_to_clipboard_wsl(target_file)
        print(f"[✓] Clipboard: {target_file}")
    else:
        subprocess.run(
            ["xclip", "-selection", "clipboard", "-i", target_file, "-t", "image/png"],
            check=True,
        )
    sys.exit(0)

# ── --monitor N: screenshot monitor tertentu ─────────────────────────────────
try:
    mon_index = int(args.monitor)
except ValueError:
    print(f"[!] Nilai --monitor tidak valid: '{args.monitor}'. Gunakan angka, 'auto', atau 'all'.")
    sys.exit(1)

if mon_index < 1 or mon_index > len(monitors):
    print(f"[!] Monitor {mon_index} tidak ditemukan. Monitor tersedia: 1-{len(monitors)}")
    print(f"    Jalankan dengan --list untuk melihat daftar monitor.")
    sys.exit(1)

selected_monitor = monitors[mon_index - 1]
print(f"[i] Menggunakan monitor {mon_index}: {selected_monitor['name']} "
      f"({selected_monitor['width']}x{selected_monitor['height']})")

label = str(mon_index) if len(monitors) > 1 else ""
target_file = process_screenshot(selected_monitor, label=label)

if target_file is None:
    sys.exit(1)

if is_wsl:
    copy_to_clipboard_wsl(target_file)
    print(f"[✓] Clipboard: {target_file}")
else:
    subprocess.run(
        ["xclip", "-selection", "clipboard", "-i", target_file, "-t", "image/png"],
        check=True,
    )

sys.exit(0)
