#!/bin/sh
source "$HOME/.config/wryn/env/env"

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

"$DOTWRYN/bin/desktop/feh/randomize-background.sh"
[ -f $HOME/.config/wryn/sfx ] && $HOME/.config/wryn/sfx gamedock
