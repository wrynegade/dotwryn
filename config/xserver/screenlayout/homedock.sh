#!/bin/sh
NATIVE_MONITOR='eDP1';
HOMEDOCK_MONITOR=$(xrandr | grep ' connect' | awk '{print $1;}' | grep -v "$NATIVE_MONITOR" | head -n 1);

[ -z $HOMEDOCK_MONITOR ] && return; # no external monitor connected; do nothing

xrandr\
	--output "$HOMEDOCK_MONITOR" --primary\
	--rotate normal\
	--pos 0x0\
	--mode $(xrandr | grep -A 2 "$HOMEDOCK_MONITOR" | sed -n '2 p' | awk '{print $1;}')\
	;

for display in $(xrandr | grep connect | awk '{print $1;}' | grep -v "$HOMEDOCK_MONITOR"); do
	xrandr --output $display --off;
done;

feh --bg-fill --randomize $HOME/.wallpaper;
