#!/usr/bin/env python
import os
import sys
import subprocess
from datetime import datetime

screenshot_dir   = "/home/xv4nz7/Picts/Screenshots"
os.chdir(screenshot_dir)
original_file    = datetime.now().strftime("Screenshot_%Y-%m-%d_%H-%M-%S.png")
target           = list(original_file)
target.insert(-4, 'X')
target_file      = ''.join(target)
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
author           = "Radivan"

is_wsl = "microsoft" in subprocess.getoutput("uname -r").lower()

# ── Capture ───────────────────────────────────────────────────────────────────
if is_wsl:
    abs_original = os.path.abspath(original_file)
    win_original = subprocess.check_output(["wslpath", "-w", abs_original]).decode().strip()
    powershell_script = f'''
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $bitmap = New-Object System.Drawing.Bitmap $screen.Width, $screen.Height
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.CopyFromScreen($screen.X, $screen.Y, 0, 0, $bitmap.Size)
    $bitmap.Save("{win_original}", [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $bitmap.Dispose()
    '''
    subprocess.run(["powershell.exe", "-NoProfile", "-Command", powershell_script], check=True)
else:
    try:
        result = subprocess.run(["slurp"], capture_output=True)
        if result.returncode != 0:
            # User cancel
            if os.path.exists(original_file):
                os.remove(original_file)
            sys.exit(2)

        region = result.stdout.decode().strip()

        with open(original_file, "wb") as f:
            grim = subprocess.run(["grim", "-g", region, "-"], stdout=f)
            if grim.returncode != 0:
                raise subprocess.CalledProcessError(grim.returncode, "grim")

    except FileNotFoundError:
        # Fallback to flameshot
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

# ── Abort if capture failed ───────────────────────────────────────────────────
if not os.path.exists(original_file) or os.path.getsize(original_file) == 0:
    print("Screenshot aborted or empty. Exiting.")
    if os.path.exists(original_file):
        os.remove(original_file)
    sys.exit(2)

# ── Process with ImageMagick ──────────────────────────────────────────────────
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

convert {target_file} -profile {color_profile} {target_file}
""")

# ── Abort if ImageMagick failed ───────────────────────────────────────────────
if not os.path.exists(target_file) or os.path.getsize(target_file) == 0:
    print("ImageMagick processing failed.")
    if os.path.exists(original_file):
        os.remove(original_file)
    sys.exit(1)

# ── Copy to clipboard ─────────────────────────────────────────────────────────
if is_wsl:
    win_target = subprocess.check_output(["wslpath", "-w", os.path.abspath(target_file)]).decode().strip()
    ps_clip = f'''
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    $img = [System.Drawing.Image]::FromFile("{win_target}")
    [System.Windows.Forms.Clipboard]::SetImage($img)
    $img.Dispose()
    '''
    subprocess.run(["powershell.exe", "-NoProfile", "-Command", ps_clip], check=True)
else:
    subprocess.run(
        ["xclip", "-selection", "clipboard", "-i", target_file, "-t", "image/png"],
        check=True,
    )

# ── Optimize & cleanup ────────────────────────────────────────────────────────
if os.system("which optipng > /dev/null 2>&1") == 0:
    os.system(f"optipng {target_file}")

os.remove(original_file)
print(f"Done: {target_file}")
sys.exit(0)