#!/bin/zsh
source "$HOME/.zshrc" &>/dev/null
source "$DOTWRYN/config/xinitrc.common"

for BACKGROUND_APPLICATION in \
	apps \
	/usr/lib/xfce-polkit/xfce-polkit \
	/usr/lib/xfce4/notifyd/xfce4-notifyd \
	"$DOTWRYN/bin/xorg-activate-default" \
	;
do
	command -v $BACKGROUND_APPLCATION \
		&& exec $BACKGROUND_APPLICATION &
done

export DESKTOP_SESSION=i3wm

cd; exec i3
