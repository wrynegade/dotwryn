#!/bin/sh
ENGINE="$(which canberra-gtk-play) -f"
SFX="$HOME/Personal/sfx";


PLAY() {
	eval "$ENGINE" "$SFX/$1"
}

case $1 in
	volume    ) PLAY yaru-message.oga ;;
	mute      ) PLAY smooth-dialog-warning.oga ;;
	backlight ) PLAY yaru-audio-volume-change.oga ;;
	login     ) PLAY yaru-desktop-login.oga ;;
	logout    ) PLAY smooth-desktop-login.oga ;;

	* ) ls $SFX ;;
esac
