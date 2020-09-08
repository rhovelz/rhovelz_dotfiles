#!/usr/bin/env ruby

require 'date'


screenshot_dir    = "/home/corshine/Arch-Corshine/Screenshots"
Dir.chdir(screenshot_dir)
original_file     = Time.now.strftime("Screenshot_%Y-%m-%d_%H-%M-%S.png")
target_file       = original_file.split("").insert(-5, 'X').join
color_profile     = "/usr/share/color/icc/colord/sRGB.icc"
border_size       = "1"
background_color  = "white" # "none" for transparent
background_size   = "10"
shadow_size       = "50x20+0+20"
font              = "JetBrains-Mono-Medium"
font_size         = "11"
color_fg          = "#ffffff"
color_bg          = "#666666"
author_position   = ["NorthEast", "+60+16"]
author            = "Author: @" + %x(echo $USER)

%x(
flameshot gui --raw > #{original_file}

convert #{original_file} -bordercolor '#{color_bg}' -border #{border_size} \
#{target_file}

convert #{target_file} \\( +clone -background black \
-shadow #{shadow_size} \\) +swap -background none \
-layers merge +repage #{target_file}

convert #{target_file} -bordercolor #{background_color} \
-border #{background_size} #{target_file}

echo -n " #{author} " | convert #{target_file} \
-gravity #{author_position[0]} -pointsize #{font_size} -fill '#{color_fg}' \
-undercolor '#{color_bg}' -font #{font} \
-annotate #{author_position[1]} @- #{target_file}

convert #{target_file} -gravity South -chop 0x#{background_size.to_i/2} \
#{target_file}

convert #{target_file} -gravity North -background #{background_color} \
-splice 0x#{background_size.to_i/2} #{target_file}

convert #{target_file} -profile #{color_profile} #{target_file}
)

%x(optipng #{target_file}) if %x(which optipng > /dev/null 2>&1)

list_file = %x(ls -p | grep -v /)
last_file = (list_file.split(" ")).last
#%x(rm -rf #{last_file})
