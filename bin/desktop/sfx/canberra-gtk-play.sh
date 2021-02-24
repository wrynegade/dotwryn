#!/bin/sh
ENGINE="$(which canberra-gtk-play) -f"
SFX="$HOME/Personal/sfx";
source "$HOME/.config/wryn/env.zsh"


PLAY() {
	eval "$ENGINE" "$SFX/$1"
}

case $1 in
	volume    ) PLAY yaru-message.oga ;;
	mute      ) PLAY smooth-dialog-warning.oga ;;
	backlight ) PLAY yaru-audio-volume-change.oga ;;
	login     ) PLAY yaru-desktop-login.oga ;;
	logout    ) PLAY smooth-desktop-login.oga ;;
	notify    ) PLAY yaru-complete.oga ;;
	undock    ) PLAY yaru-desktop-login.oga ;;
	homedock  ) PLAY homedock.oga ;;
	gamedock  ) PLAY gamedock.oga ;;
	* ) ls $SFX ;;
esac
