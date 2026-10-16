#!/usr/bin/env python3
import os
import sys
import json
import shlex
import argparse
import subprocess
import base64
import threading
import atexit
from datetime import datetime

_upload_threads = []

def _wait_uploads():
    for t in _upload_threads:
        t.join()
atexit.register(_wait_uploads)

# ── Konfigurasi ───────────────────────────────────────────────────────────────
screenshot_dir   = os.path.expanduser("~/Pictures/Screenshots")
color_profile    = "/System/Library/ColorSync/Profiles/sRGB Profile.icc"
color_bg         = "#44475a"
border_size      = 5
background_color = "white"
background_size  = 10
shadow_opacity   = 50
shadow_sigma     = 10
shadow_offset_y  = 10
corner_radius    = 5
font             = os.path.expanduser("~/Library/Fonts/JetBrainsMonoNerdFont-Medium.ttf")
font_size        = 15
color_fg         = "#FFFFFF"
author_position  = ["NorthEast", 50, 12]
author           = "RADIVAN"
magick           = "/opt/homebrew/bin/magick"

# ── Konfigurasi Imgbb ─────────────────────────────────────────────────────────
imgbb_api_key    = "82fe54c6af49b7937e22966cd64664ee"

# ── Konfigurasi HD ────────────────────────────────────────────────────────────
# Target skala akhir relatif ke 1x. Layar Retina sudah capture di 2x, jadi
# upscale tambahan = hd_scale / retina_scale (2 / 2 = tidak di-upscale lagi).
hd_scale         = 2
hd_filter        = "Lanczos" # Filter terbaik untuk upscale (tajam & smooth)
hd_sharpen       = "0x0.8"   # Unsharp mask setelah upscale agar teks/garis crisp
hd_min           = "1280x720" # Ukuran minimal hasil; area kecil di-upscale sampai sisi panjangnya mencapai HD

# ── Argumen CLI ───────────────────────────────────────────────────────────────
parser = argparse.ArgumentParser(
    description="Screenshot tool (macOS) — otomatis detect monitor aktif dari posisi cursor",
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
    "--select", "-s",
    action="store_true",
    help="Pilih area screenshot secara manual (drag mouse, Spasi = pilih window, Esc = batal)"
)
parser.add_argument(
    "--list", "-l",
    action="store_true",
    help="Tampilkan daftar semua monitor yang terhubung lalu keluar"
)
args = parser.parse_args()

# ── Fungsi: ambil daftar monitor + posisi cursor (via JXA / AppKit) ──────────
def get_screen_info():
    """Urutan NSScreen.screens = urutan display `screencapture -D` (1 = utama)."""
    jxa = r"""
    ObjC.import("AppKit");
    var s = $.NSScreen.screens, out = [];
    for (var i = 0; i < s.count; i++) {
        var sc = s.objectAtIndex(i), f = sc.frame;
        out.push({name: sc.localizedName.js, x: f.origin.x, y: f.origin.y,
                  width: f.size.width, height: f.size.height,
                  scale: sc.backingScaleFactor, primary: i == 0});
    }
    var m = $.NSEvent.mouseLocation;
    JSON.stringify({monitors: out, cursor: [m.x, m.y]});
    """
    result = subprocess.check_output(["osascript", "-l", "JavaScript", "-e", jxa]).decode()
    return json.loads(result)

# ── Fungsi: deteksi monitor aktif dari posisi cursor ─────────────────────────
def get_active_monitor(monitors, cursor):
    cx, cy = cursor
    print(f"[i] Posisi cursor: ({int(cx)}, {int(cy)})")

    for mon in monitors:
        in_x = mon["x"] <= cx < mon["x"] + mon["width"]
        in_y = mon["y"] <= cy < mon["y"] + mon["height"]
        if in_x and in_y:
            return mon

    # Fallback ke primary jika cursor di luar semua monitor (jarang terjadi)
    print("[!] Cursor tidak terdeteksi di monitor manapun, fallback ke primary.")
    return monitors[0]

# ── Fungsi: capture ke file (screencapture bawaan macOS) ─────────────────────
def capture(out_path, monitor_index=None, select=False):
    cmd = ["screencapture", "-x", "-t", "png"]
    if select:
        cmd.append("-i")
    elif monitor_index:
        cmd += ["-D", str(monitor_index)]
    cmd.append(out_path)
    subprocess.run(cmd)

# ── Fungsi: copy file gambar ke clipboard ────────────────────────────────────
def copy_to_clipboard(file_path):
    abs_path = os.path.abspath(file_path).replace('"', '\\"')
    subprocess.run(
        ["osascript", "-e",
         f'set the clipboard to (read (POSIX file "{abs_path}") as «class PNGf»)'],
        check=True
    )

# ── Fungsi: proses ImageMagick (border, shadow, watermark, HD upscale) ───────
def process_imagemagick(original_file, target_file, retina):
    s   = lambda v: int(round(v * retina))  # skala ukuran efek ke pixel Retina
    r   = s(corner_radius)
    bg  = s(background_size)
    half_bg = bg // 2
    upscale = hd_scale / retina
    resize  = (f"-filter {hd_filter} -resize {upscale * 100:g}% -unsharp {hd_sharpen}"
               if upscale > 1 else "")
    q = shlex.quote

    cmd = rf"""
{magick} {q(original_file)} \
    -bordercolor {q(color_bg)} -border {s(border_size)} \
    \( +clone -alpha extract \
       -draw 'fill black polygon 0,0 0,{r} {r},0 fill white circle {r},{r} {r},0' \
       \( +clone -flip \) -compose Multiply -composite \
       \( +clone -flop \) -compose Multiply -composite \
    \) -alpha off -compose CopyOpacity -composite \
    miff:- | \
{magick} miff:- \
    \( +clone -background black -shadow {shadow_opacity}x{s(shadow_sigma)}+0+{s(shadow_offset_y)} \) \
    +swap -background none -layers merge +repage \
    -bordercolor {background_color} -border {bg} \
    -gravity {author_position[0]} -pointsize {s(font_size)} -fill {q(color_fg)} \
    -undercolor {q(color_bg)} -font {q(font)} \
    -annotate +{s(author_position[1])}+{s(author_position[2])} {q(' -' + author + '-')} \
    -gravity South -chop 0x{half_bg} \
    -gravity North -background {background_color} -splice 0x{half_bg} \
    {resize} \
    -filter {hd_filter} -resize {q(hd_min + '<')} \
    -profile {q(color_profile)} \
    {q(target_file)}
"""
    subprocess.run(cmd, shell=True)

# ── Fungsi: upload ke Imgbb ───────────────────────────────────────────────────
def upload_imgbb(file_path):
    abs_path = os.path.join(screenshot_dir, file_path) if not os.path.isabs(file_path) else file_path
    with open(abs_path, "rb") as f:
        image_b64 = base64.b64encode(f.read()).decode()
    from urllib.request import urlopen, Request
    from urllib.parse import urlencode
    data = urlencode({"key": imgbb_api_key, "image": image_b64}).encode()
    try:
        resp = urlopen(Request("https://api.imgbb.com/1/upload", data=data), timeout=60)
        result = json.loads(resp.read().decode())
        if result.get("success"):
            return result["data"]["url"]
    except Exception as e:
        print(f"[!] Upload Imgbb gagal: {e}")
    return None

# ── Fungsi: proses satu screenshot (capture → imagemagick → clipboard) ───────
def process_screenshot(monitor_index=None, label="", select=False, retina=2):
    os.chdir(screenshot_dir)

    timestamp     = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    suffix        = "_SELECT" if select else (f"_MON{label}" if label else "")
    original_file = f"Screenshot_{timestamp}{suffix}.png"
    target_file   = f"Screenshot_{timestamp}{suffix}X.png"

    capture(original_file, monitor_index=monitor_index, select=select)

    # Validasi capture (screencapture -i tidak membuat file kalau Esc)
    if not os.path.exists(original_file) or os.path.getsize(original_file) == 0:
        print(f"[!] Screenshot {label} aborted atau kosong.")
        if os.path.exists(original_file):
            os.remove(original_file)
        return None

    # Proses ImageMagick
    process_imagemagick(original_file, target_file, retina)

    # Validasi hasil ImageMagick
    if not os.path.exists(target_file) or os.path.getsize(target_file) == 0:
        print(f"[!] ImageMagick gagal untuk {original_file}.")
        if os.path.exists(original_file):
            os.remove(original_file)
        return None

    # Cleanup original
    os.remove(original_file)
    print(f"[✓] Done: {os.path.join(screenshot_dir, target_file)}")

    # Upload ke Imgbb (background — tidak blocking clipboard)
    def _bg_upload(path):
        url = upload_imgbb(path)
        if url:
            print(f"[✓] Imgbb: {url}")
    t = threading.Thread(target=_bg_upload, args=(target_file,))
    t.start()
    _upload_threads.append(t)

    return target_file

def finish(target_file):
    if target_file is None:
        sys.exit(1)
    copy_to_clipboard(target_file)
    print(f"[✓] Clipboard: {target_file}")
    sys.exit(0)

# ══════════════════════════════════════════════════════════════════════════════
# ── MAIN ─────────────────────────────────────────────────────────────────────
# ══════════════════════════════════════════════════════════════════════════════

os.makedirs(screenshot_dir, exist_ok=True)

info     = get_screen_info()
monitors = info["monitors"]

# ── --list: tampilkan monitor lalu keluar ────────────────────────────────────
if args.list:
    print(f"\n{'No':<4} {'Nama':<25} {'Resolusi':<16} {'Posisi':<16} {'Status'}")
    print("-" * 72)
    for i, m in enumerate(monitors, start=1):
        status = "PRIMARY" if m["primary"] else ""
        res    = f"{int(m['width'] * m['scale'])}x{int(m['height'] * m['scale'])}"
        pos    = f"({int(m['x'])}, {int(m['y'])})"
        print(f"{i:<4} {m['name']:<25} {res:<16} {pos:<16} {status}")
    print()
    sys.exit(0)

# ── --select: screenshot area pilihan ────────────────────────────────────────
if args.select:
    print("[i] Pilih area screenshot — drag mouse, Spasi = pilih window, Esc = batal.")
    active = get_active_monitor(monitors, info["cursor"])
    target_file = process_screenshot(select=True, retina=active["scale"])
    if target_file is None:
        sys.exit(2)
    finish(target_file)

# ── --monitor all: screenshot semua monitor ──────────────────────────────────
if args.monitor.lower() == "all":
    results = []
    for i, mon in enumerate(monitors, start=1):
        result = process_screenshot(i, label=str(i), retina=mon["scale"])
        if result:
            results.append(result)

    # Copy monitor pertama ke clipboard
    if results:
        copy_to_clipboard(results[0])
        print(f"[✓] Clipboard: {results[0]}")

    sys.exit(0 if results else 1)

# ── --monitor auto / N ───────────────────────────────────────────────────────
if args.monitor.lower() == "auto":
    selected_monitor = get_active_monitor(monitors, info["cursor"])
    mon_index = monitors.index(selected_monitor) + 1
    print(f"[i] Monitor aktif (cursor): {mon_index} — {selected_monitor['name']}")
else:
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
    print(f"[i] Menggunakan monitor {mon_index}: {selected_monitor['name']}")

label = str(mon_index) if len(monitors) > 1 else ""
finish(process_screenshot(mon_index, label=label, retina=selected_monitor["scale"]))
