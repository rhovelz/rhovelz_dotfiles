#!/bin/bash

if [[ "$(playerctl --player=spotify status)" == "Paused" || "Playing" ]]
then
	echo $(playerctl --player=spotify metadata --format "{{ title }} - {{ artist }}")
else
	echo ""
fi