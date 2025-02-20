#!/bin/zsh
source $HOME/.config/wryn/env.zsh
[ ! $DISPLAY ] && export DISPLAY=:0

ALL_OTHER_DISPLAYS_OFF() {
	for OUTPUT in $(xrandr | grep connect | grep -v $1 | awk '{print $1;}')
	do
		echo --output $OUTPUT --off
	done
}
