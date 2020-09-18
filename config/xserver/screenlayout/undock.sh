#!/bin/sh
NATIVE_MONITOR='eDP1';

xrandr\
	--output "$NATIVE_MONITOR" --primary\
	--rotate normal\
	--pos 0x0\
	--mode $(xrandr | grep -A 2 "$NATIVE_MONITOR" | sed -n '2 p' | awk '{print $1;}')\
	;

for display in $(xrandr | grep connect | awk '{print $1;}' | grep -v "$NATIVE_MONITOR"); do
	xrandr --output $display --off;
done;

feh --bg-fill --randomize $HOME/.config/wryn/wallpaper;
