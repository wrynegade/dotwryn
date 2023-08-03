#####################################################################

DEPENDENCIES+=(
	xrandr
)
REQUIRED_ENV+=()

#####################################################################

XRANDR__DISCONNECT_ALL_DISPLAYS() {
	STATUS 'disconnecting all displays' \
		&& xrandr $(xrandr | grep ' connected' | awk '{print "--output "$1" --off"}') \
		&& sleep 1 \
		&& SUCCESS 'all displays disconnected' \
		|| { ERROR 'unable to disconnect displays'; return 1; }
}
