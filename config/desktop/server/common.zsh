#
# shared by every desktop session (config/desktop/*/session)
#

case "${XDG_SESSION_TYPE}" in
	( x11 | wayland ) ;;
	( '' )
		echo "ERROR : XDG_SESSION_TYPE must be set to one of 'x11' or 'wayland' (currently unset)" >&2
		return 1
		;;
	( * )
		echo "ERROR : XDG_SESSION_TYPE must be 'x11' or 'wayland' (got '${XDG_SESSION_TYPE}')" >&2
		return 1
		;;
esac

#####################################################################

for PREFERRED_TERMINAL in \
	alacritty \
	kitty \
	;
do
	command -v ${PREFERRED_TERMINAL} &>/dev/null \
		&& export TERMINAL="$(which ${PREFERRED_TERMINAL})" \
		&& break
done
unset PREFERRED_TERMINAL

#####################################################################

for PREFERRED_BROWSER in \
	brave \
	firefox \
	google-chrome-stable \
	google-chrome \
	;
do
	command -v ${PREFERRED_BROWSER} &>/dev/null \
		&& export BROWSER="$(which ${PREFERRED_BROWSER})" \
		&& break
done
unset PREFERRED_BROWSER

#####################################################################

source "${DOTWRYN}/config/desktop/server/${XDG_SESSION_TYPE}.zsh"
