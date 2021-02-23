#!/bin/sh

##############################

foreground='FFFF00'
background='021400'

red='FE3500'
brightred='FE9800'

green='074B0F'
brightgreen='78FF00'

yellow='F4FF00'
brightyellow='FFD700'

blue='06FF84'
brightblue='BFEA83'

magenta='007015'
brightmagenta='007015'

cyan='07FF4F'
brightcyan='346800'

gray='252615'
brightgray='827000'

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
