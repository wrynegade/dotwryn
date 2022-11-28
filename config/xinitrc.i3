#!/bin/zsh
source "$HOME/.config/wryn/env.zsh"
source "$DOTWRYN/config/xinitrc.common"

command -v dex && dex -a
$DOTWRYN/bin/xorg-activate-default &

cd
export DESKTOP_SESSION=i3wm
exec i3
