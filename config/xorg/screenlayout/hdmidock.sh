#!/bin/sh
NATIVE_MONITOR='eDP1';
CONNECTED_MONITOR=$(xrandr | grep ' connect' | awk '{print $1;}' | grep -v "$NATIVE_MONITOR" | head -n 1);

MONITOR_DIRECTION='--above'; # left-of, below, above, right-of

[ -z $CONNECTED_MONITOR ] && return; # no external monitor connected; do nothing
[ $1 ] && MONITOR_DIRECTION="$1";

xrandr\
	--output "$NATIVE_MONITOR" --primary\
	--rotate normal\
	--pos 0x0\
	--mode $(xrandr | grep -A 2 "$NATIVE_MONITOR" | sed -n '2 p' | awk '{print $1;}')\
	;

sleep 0.5

xrandr\
	--output "$CONNECTED_MONITOR"\
	--rotate normal\
	$MONITOR_DIRECTION $NATIVE_MONITOR\
	--mode $(xrandr | grep -A 2 "^$CONNECTED_MONITOR" | sed -n '2 p' | awk '{print $1;}')\
	;


for display in $(xrandr | grep connect | awk '{print $1;}' | grep -v "$NATIVE_MONITOR" | grep -v "$CONNECTED_MONITOR"); do
	xrandr --output $display --off;
done;

feh --recursive --bg-fill --randomize $HOME/.config/wryn/wallpaper;
[ -f $HOME/.config/wryn/sfx ] && $HOME/.config/wryn/sfx login
