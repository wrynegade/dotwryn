#!/bin/sh

##############################

foreground='FF6622'
background='051000'

red='FF2200'
brightred='FF8700'

green='FFFF00'
brightgreen='AAAA00'

yellow='78FF00'
brightyellow='008B20'

blue='00FF88'
brightblue='BFEA83'

magenta='00A000'
brightmagenta='005000'

cyan='07FF4F'
brightcyan='648800'

gray='00FF00'
brightgray='00AA00'

##############################


if [ "$TERM" = "linux" ]; then
	/bin/echo -e "
	\e]P0$background
	\e]P1$red
	\e]P2$green
	\e]P3$yellow
	\e]P4$blue
	\e]P5$magenta
	\e]P6$cyan
	\e]P7$foreground
	\e]P8$brightred
	\e]P9$brightgreen
	\e]PA$brightyellow
	\e]PB$brightblue
	\e]PC$brightmagenta
	\e]PD$brightcyan
	\e]PE$gray
	\e]PF$brightgray
	"
	clear;
fi
