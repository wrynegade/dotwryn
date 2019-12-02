#!/bin/sh
xrandr --output DP-0 --off\
	   --output DP-4 --off\
	   --output HDMI-0 --off\
	   --output DP-1 --mode 1920x1080 --pos 0x0 --rotate normal\
	   --output DP-2 --mode 2880x1800 --pos 3840x0 --rotate normal --scale 0.8x0.8\
	   --output DP-3 --mode 1920x1080 --pos 1920x0 --rotate normal


ROLL=$(($RANDOM%4));

if   [ $ROLL -eq 0 ]; then
	feh --bg-fill\
		$HOME/Pictures/bg/midoriya.jpg\
		$HOME/Pictures/bg/altaria.jpg\
		$HOME/Pictures/bg/captainfalcon.jpg\
		>/dev/null 2>&1
elif [ $ROLL -eq 1 ]; then
	feh --bg-fill\
		$HOME/Pictures/bg/dimitri.jpg\
		$HOME/Pictures/bg/claude.jpg\
		$HOME/Pictures/bg/edelgard.jpg\
		>/dev/null 2>&1
elif [ $ROLL -eq 2 ]; then
	feh --bg-fill\
		$HOME/Pictures/bg/roy.jpg\
		$HOME/Pictures/bg/fe8.jpg\
		$HOME/Pictures/bg/micaiah.jpg\
		>/dev/null 2>&1
elif [ $ROLL -eq 3 ]; then
	feh --bg-fill\
		$HOME/Pictures/bg/chrom.jpg\
		$HOME/Pictures/bg/byleth.jpg\
		$HOME/Pictures/bg/link.jpg\
		>/dev/null 2>&1
fi
