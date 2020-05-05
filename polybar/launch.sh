#!/bin/sh

killall -q polybar
wait $!

polybar -c ~/.config/polybar/config.ini -r mainbar &
