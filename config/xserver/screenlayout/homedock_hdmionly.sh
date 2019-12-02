#!/bin/sh
xrandr --output DP-0 --off\
	   --output DP-1 --off\
	   --output DP-2 --off\
	   --output DP-3 --off\
	   --output DP-4 --off\
	   --output HDMI-0 --primary --mode 3840x2160 --pos 2880x0 --rotate normal


ROLL=$(($RANDOM%3));

if   [ $ROLL -eq 0 ]; then
	feh --bg-fill $HOME/Pictures/bg/detective.jpg >/dev/null 2>&1
elif [ $ROLL -eq 1 ]; then
	feh --bg-fill $HOME/Pictures/bg/link.png >/dev/null 2>&1
elif [ $ROLL -eq 2 ]; then
	feh --bg-fill $HOME/Pictures/bg/snow2.jpg >/dev/null 2>&1
fi
