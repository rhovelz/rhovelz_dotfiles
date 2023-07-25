#!/bin/bash
#
#zscroll -l 30 \
#        --delay 0.09 \
#        --match-command "playerctl --player=spotify status" \
#        --match-text "Playing" "--scroll true" \
#        --match-text "Paused" "--scroll false" \
#        --update-check true '/home/corshine/.config/polybar/draculatheme/spotify_status.sh' &
#
#wait


main() {
  if ! pgrep -x spotify >/dev/null; then
    echo ""; exit
  fi

  cmd="org.freedesktop.DBus.Properties.Get"
  domain="org.mpris.MediaPlayer2"
  path="/org/mpris/MediaPlayer2"

  meta=$(dbus-send --print-reply --dest=${domain}.spotify \
    /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:${domain}.Player string:Metadata)

  artist=$(echo "$meta" | sed -nr '/xesam:artist"/,+2s/^ +string "(.*)"$/\1/p' | tail -1  | sed 's/\&/\\&/g' | sed 's#\/#\\/#g')
  album=$(echo "$meta" | sed -nr '/xesam:album"/,+2s/^ +variant +string "(.*)"$/\1/p' | tail -1| sed 's/\&/\\&/g'| sed 's#\/#\\/#g')
  title=$(echo "$meta" | sed -nr '/xesam:title"/,+2s/^ +variant +string "(.*)"$/\1/p' | tail -1 | sed 's/\&/\\&/g'| sed 's#\/#\\/#g')

  echo "   ${*:-%artist% - %title%} " | sed "s/%artist%/$artist/g;s/%title%/$title/g;s/%album%/$album/g"i | sed "s/\&/\&/g" | sed "s#\/#\/#g"

}

main "$@"
