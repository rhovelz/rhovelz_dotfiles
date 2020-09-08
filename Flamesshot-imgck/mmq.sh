#!/bin/bash

flameshot gui --raw > /tmp/image.png

# rounded corners
convert /tmp/image.png \
     \( +clone  -alpha extract \
        -draw 'fill black polygon 0,0 0,5 5,0 fill white circle 5,5 5,0' \
        \( +clone -flip \) -compose Multiply -composite \
        \( +clone -flop \) -compose Multiply -composite \
     \) -alpha off -compose CopyOpacity -composite /tmp/image.png

# author
echo -n " {author} " | convert {target_file} \
-gravity {author_position[0]} -pointsize {font_size} -fill '{color_fg}' \
-undercolor '{color_bg}' -font {font} \
-annotate {author_position[1]} @- {target_file}

# shadow
convert /tmp/image.png \( +clone -background black -shadow 40x5+0+0 \) \
+swap -background none -layers merge +repage /tmp/image.png; \

# white backdrop
convert /tmp/image.png -bordercolor white -border 10 /tmp/image.png

# copy to clipboard
xclip -selection clipboard -i /tmp/image.png -t image/png
