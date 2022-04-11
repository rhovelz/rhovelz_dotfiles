#!/bin/sh

TEMP=""
FIFO=$(mktemp)

trap "exit" INT TERM HUP
trap 'kill 0; rm -f $FIFO' EXIT

gpu() {
	TEMP="G $(sensors | grep -A 6 nouveau-pci | awk '{ if ($1 == "temp1:") { print $2 } }' | sed -nE 's/\+([0-9]+)\..*/\1/p')"
	echo "gpu" > "$FIFO"
}

cpu() {
	TEMP="C $(sensors | grep -A 8 k10temp-pci | awk '{ if ($1 == "Tdie:") { print $2 } }' | sed -nE 's/\+([0-9][0-9])\..*/\1/p')"
	echo "cpu" > "$FIFO"
}

hdd() {
	# echo is needed here!
	TEMP="H $(echo $(nc 127.0.0.1 7634) | sed -nE 's/.*ST1000LM035.*?\|([0-9]{2})\|.*/\1/p')"
	echo "hdd" > "$FIFO"
}

gpu
echo "$TEMP"

cur() {
	case "$(cat "$FIFO")" in
		gpu)
			gpu && echo "$TEMP"
			;;
		cpu)
			cpu && echo "$TEMP"
			;;
		hdd)
			hdd && echo "$TEMP"
			;;
	esac
}

next() {
	case "$(cat "$FIFO")" in
		gpu)
			cpu && echo "$TEMP"
			;;
		cpu)
			hdd && echo "$TEMP"
			;;
		hdd)
			gpu && echo "$TEMP"
			;;
	esac
}

regular() {
	while :; do
		sleep 5
		cur
	done
}

listener() {
	tmp=$(mktemp)
	nc -lvnp 8782 > "$tmp" &
	export NCPID=$!
	tail -f -n 0 "$tmp" | while read -r TASK; do
		case "$TASK" in
			current)
				cur
				;;
			next)
				next
				;;
		esac
	done
}

regular &
listener &

wait
