#!/bin/sh
NATIVE_MONITOR='eDP1';
NATIVE_MODE="$(xrandr | grep -A 2 "$NATIVE_MONITOR" | sed -n '2 p' | awk '{print $1;}')";

[[ $(xrandr -q | grep ' connected' | wc -l) -eq 1 ]] \
	&& xrandr -q | grep "$NATIVE_MONITOR connected" | grep -q '3840' \
	&& NATIVE_MODE='2880x1620';

xrandr\
	--output "$NATIVE_MONITOR" --primary\
	--rotate normal\
	--pos 0x0\
	--mode "$NATIVE_MODE"\
	;

for display in $(xrandr | grep connect | awk '{print $1;}' | grep -v "$NATIVE_MONITOR"); do
	xrandr --output $display --off;
done;

feh --bg-fill --randomize $HOME/.config/wryn/wallpaper;

[ -f $HOME/.config/wryn/sfx ] && $HOME/.config/wryn/sfx undock
