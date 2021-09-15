#!/bin/sh
source "$HOME/.config/wryn/env/env.zsh" 2>/dev/null

PLAY() {
	eval "$MEDIA_ENGINE" "$SFX_PATH/$1"
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
	* ) ls $SFX_PATH ;;
esac
