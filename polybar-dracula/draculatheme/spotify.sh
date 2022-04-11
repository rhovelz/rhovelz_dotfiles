#!/bin/bash

zscroll -l 30 \
        --delay 0.099 \
        --match-command "playerctl --player=spotify status" \
        --match-text "Playing" "--scroll true" \
        --match-text "Paused" "--scroll false" \
        --update-check true '/home/corshine/.config/polybar/draculatheme/spotify_status.sh' &

wait