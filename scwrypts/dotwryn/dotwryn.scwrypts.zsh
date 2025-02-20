readonly ${scwryptsgroup}__type=zsh
readonly ${scwryptsgroup}__color=$(utils.colors.red)

#####################################################################

[ "${DOTWRYN}" ] \
	|| export DOTWRYN=$(git -C "${0:a:h}" rev-parse --show-toplevel 2>/dev/null)

export DOTWRYN_HOSTNAME=$(hostnamectl --static)

[ "${XDG_CONFIG_HOME}" ] \
	|| export XDG_CONFIG_HOME="${HOME}/.config"

[ "${XDG_DATA_HOME}" ] \
	|| export XDG_DATA_HOME="${HOME}/.local/share"

##########################################

for DOTWRYN_REQUIRED_VAR in \
	DOTWRYN \
	DOTWRYN_HOSTNAME \
	;
do
	[ "${(P)DOTWRYN_REQUIRED_VAR}" ] \
		|| echo.error "cannot determine ${DOTWRYN_REQUIRED_VAR}" \
		|| return 1
done

unset DOTWRYN_REQUIRED_VAR

#####################################################################
