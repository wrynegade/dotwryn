#!/bin/sh
xrandr --output DP-0 --off\
	   --output DP-1 --off\
	   --output HDMI-0 --off\
	   --output DP-3 --off\
	   --output DP-4 --off\
	   --output DP-2 --primary --mode 2880x1800 --scale 0.8x0.8 --pos 0x0 --rotate normal

ROLL=$(($RANDOM%10));

if   [ $ROLL -eq 0 ]; then
	feh --bg-fill $HOME/Pictures/bg/vegeta.jpg >/dev/null 2>&1
elif [ $ROLL -eq 1 ]; then
	feh --bg-fill $HOME/Pictures/bg/claude.jpg >/dev/null 2>&1
elif [ $ROLL -eq 2 ]; then
	feh --bg-fill $HOME/Pictures/bg/ike_vs_bk.jpg >/dev/null 2>&1
elif [ $ROLL -eq 3 ]; then
	feh --bg-fill $HOME/Pictures/bg/snow1.jpg >/dev/null 2>&1
elif [ $ROLL -eq 4 ]; then
	feh --bg-fill $HOME/Pictures/bg/midoriya.jpg >/dev/null 2>&1
elif [ $ROLL -eq 5 ]; then
	feh --bg-fill $HOME/Pictures/bg/pikachu.jpg >/dev/null 2>&1
elif [ $ROLL -eq 6 ]; then
	feh --bg-fill $HOME/Pictures/bg/captainfalcon.jpg >/dev/null 2>&1
elif [ $ROLL -eq 7 ]; then
	feh --bg-fill $HOME/Pictures/bg/seiros_vs_nemesis.jpg >/dev/null 2>&1
elif [ $ROLL -eq 8 ]; then
	feh --bg-fill $HOME/Pictures/bg/kirito.jpg >/dev/null 2>&1
elif [ $ROLL -eq 9 ]; then
	feh --bg-fill $HOME/Pictures/bg/altaria.jpg >/dev/null 2>&1
fi
