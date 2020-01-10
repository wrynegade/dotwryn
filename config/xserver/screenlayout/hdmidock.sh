#!/bin/sh
xrandr --output DP-0 --off\
	   --output DP-1 --off\
	   --output DP-3 --off\
	   --output DP-4 --off\
	   --output DP-2 --primary --mode 2880x1800 --scale 0.8x0.8 --pos 0x0 --rotate normal\
	   --output HDMI-0 --pos 2880x0 --rotate normal

ROLL=$(($RANDOM%4));

if   [ $ROLL -eq 0 ]; then
	feh --bg-fill\
		$HOME/Pictures/bg/midoriya.jpg\
		$HOME/Pictures/bg/vegeta.jpg\
		>/dev/null 2>&1
elif [ $ROLL -eq 1 ]; then
	feh --bg-fill\
		$HOME/Pictures/bg/ike_vs_bk.jpg\
		$HOME/Pictures/bg/seiros_vs_nemesis.jpg\
		>/dev/null 2>&1
elif [ $ROLL -eq 2 ]; then
	feh --bg-fill\
		$HOME/Pictures/bg/captainfalcon.jpg\
		$HOME/Pictures/bg/link.jpg\
		>/dev/null 2>&1
elif [ $ROLL -eq 3 ]; then
	feh --bg-fill\
		$HOME/Pictures/bg/fe8.jpg\
		$HOME/Pictures/bg/micaiah.jpg\
		>/dev/null 2>&1
fi
