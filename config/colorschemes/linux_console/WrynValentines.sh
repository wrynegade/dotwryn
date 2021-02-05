#!/bin/sh

##############################

foreground='E3DFD2'
background='150015'

red='DB133F'
brightred='DF5472'

green='DC39DC'
brightgreen='ED7BEE'

yellow='7918F4'
brightyellow='7D72FE'

blue='951255'
brightblue='E75BA2'

magenta='7D1295'
brightmagenta='934BA3'

cyan='DEB88D'
brightcyan='FEE3CD'

gray='460020'
brightgray='900045'

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
