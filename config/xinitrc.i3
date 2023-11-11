#!/bin/zsh
source "$HOME/.config/wryn/env.zsh"
source "$DOTWRYN/config/xinitrc.common"

command -v dex && dex -a

[ -f /usr/lib/xfce-polkit/xfce-polkit ] \
	&& exec /usr/lib/xfce-polkit/xfce-polkit &

[ -f /usr/lib/xfce4/notifyd/xfce4-notifyd ] \
	&& exec /usr/lib/xfce4/notifyd/xfce4-notifyd &

$DOTWRYN/bin/xorg-activate-default &

cd
export DESKTOP_SESSION=i3wm
exec i3
