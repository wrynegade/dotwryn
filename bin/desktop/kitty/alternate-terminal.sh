#!/bin/sh

source "$HOME/.config/wryn/env/env"

CONFIG_DIR="$DOTWRYN/config/kitty"

[ -f "$CONFIG_DIR/temp.conf" ] && return 1 # race condition lock

mv "$CONFIG_DIR/theme.conf" "$CONFIG_DIR/temp.conf"
mv "$CONFIG_DIR/alternate.conf" "$CONFIG_DIR/theme.conf"

i3-sensible-terminal &
sleep 0.1

mv "$CONFIG_DIR/theme.conf" "$CONFIG_DIR/alternate.conf"
mv "$CONFIG_DIR/temp.conf" "$CONFIG_DIR/theme.conf"
