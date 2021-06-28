#!/bin/sh

background='22002a';
foreground='ffffff';

red='5fff00';
brightred='3a3a3a';

green='e17000';
brightgreen='dd9210';

yellow='ff7a48';
brightyellow='ff8200';

blue='ff0000';
brightblue='edb877';

magenta='ff4e4e';
brightmagenta='aa005c';

cyan='8a41d5';
brightcyan='cc00ff';

gray='0da4cd';
brightgray='acacac';

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

