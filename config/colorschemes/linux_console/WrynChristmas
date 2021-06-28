#!/bin/sh

##############################

foreground='CCDDFF'
background='001010'

red='A2152D'
brightred='FF1440'

green='288B52'
brightgreen='55C9B5'

yellow='489358'
brightyellow='5BF887'

blue='0EA1EE'
brightblue='00FFFF'

magenta='A03C6F'
brightmagenta='CF4663'

cyan='8195A2'
brightcyan='DFF5FE'

gray='486A8A'
brightgray='EBFFF2'

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
