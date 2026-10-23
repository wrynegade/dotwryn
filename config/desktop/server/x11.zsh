#####################################################################

for XINITRC_FILE in $(find /etc/X11/xinit/xinitrc.d | sort); do source "${XINITRC_FILE}"; done
unset XINITRC_FILE

[ -f "${XDG_CONFIG_HOME:=${HOME}/.config}/X11/xmodmap" ] \
	&& xmodmap "${XDG_CONFIG_HOME}/X11/xmodmap"

[ -f "${XDG_CONFIG_HOME}/X11/xkeymap" ] \
	&& xkbcomp "${XDG_CONFIG_HOME}/X11/xkeymap" ${DISPLAY}

#####################################################################

for BACKGROUND_APPLICATION in \
	apps \
	/usr/lib/xfce-polkit/xfce-polkit \
	/usr/lib/xfce4/notifyd/xfce4-notifyd \
	"${DOTWRYN}/config/local/$(hostnamectl --static)/bin/default" \
	;
do
	command -v ${BACKGROUND_APPLICATION} && exec ${BACKGROUND_APPLICATION} &
done

#####################################################################
true
