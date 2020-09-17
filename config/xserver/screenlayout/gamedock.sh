#!/bin/sh

RESOLUTION='1920x1080';

[ $1 ] && RESOLUTION="$1";

CURRENT_MONITOR=$(xrandr | grep 'primary' | awk '{print $1;}' | tail -n 1);

xrandr\
	--output "$CURRENT_MONITOR" --primary\
	--rotate normal\
	--pos 0x0\
	--mode $RESOLUTION\
	;

for display in $(xrandr | grep connect | awk '{print $1;}' | grep -v "$CURRENT_MONITOR"); do
	xrandr --output $display --off;
done;

feh --bg-fill --randomize $HOME/.wallpaper;
