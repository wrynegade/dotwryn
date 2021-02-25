#!/bin/sh
source "$HOME/.config/wryn/env/env"

NATIVE_MONITOR='eDP1';
TV_DISPLAY=$(xrandr | grep ' connect' | awk '{print $1;}' | grep -v "$NATIVE_MONITOR" | head -n 1);

[ -z $TV_DISPLAY ] && return; # no external monitor connected; do nothing

xrandr\
	--output "$TV_DISPLAY" --primary\
	--rotate normal\
	--pos 0x0\
	--mode 1920x1080\
	;

for display in $(xrandr | grep connect | awk '{print $1;}' | grep -v "$TV_DISPLAY"); do
	xrandr --output $display --off;
done;

"$DOTWRYN/bin/desktop/feh/randomize-background.sh"
[ -f $HOME/.config/wryn/sfx ] && $HOME/.config/wryn/sfx gamedock
