#!/bin/zsh
source "${HOME}/.config/wryn/env.zsh"
NATIVE_MONITOR='eDP1'

GET_PRIMARY_MONITOR() {
	xrandr \
		| grep 'primary' \
		| awk '{print $1;}' \
		| head -n 1
}

PRIMARY_MONITOR=$(GET_PRIMARY_MONITOR)

GET_ALL_EXTERNAL_MONITORS() {
	xrandr \
		| grep ' connect' \
		| awk '{print $1;}' \
		| grep -v "${NATIVE_MONITOR}" \
		2>/dev/null
}
GET_DEFAULT_EXTERNAL_MONITOR() {
	GET_ALL_EXTERNAL_MONITORS | head -n 1
}
EXTERNAL_MONITOR=$(GET_DEFAULT_EXTERNAL_MONITOR)

DISCONNECT_OTHER() {
	local SFX="$1"

	local INACTIVE_MONITORS=$(\
		xrandr --listmonitors \
			| sed '1d' | awk '{print $NF;}' \
			| grep -v "^$(GET_PRIMARY_MONITOR)$"
		)

	for ACTIVE_MONITOR in ${@:2}
	do
		INACTIVE_MONITORS=$(echo ${INACTIVE_MONITORS} | grep -v "^${ACTIVE_MONITOR}$")
	done

	local MONITOR
	for MONITOR in ${INACTIVE_MONITORS}
	do
		xrandr --output ${MONITOR} --off
	done

	sleep 1
	${DOTWRYN}/bin/set-background random

	[ ${SFX} ] && ( scwrypts play sfx -- ${SFX} ) &
	return 0
}

NOTIFY() {
	notify-send 'xrandr screenlayout' $@
}
