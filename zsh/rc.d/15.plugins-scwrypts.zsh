#####################################################################

ZSH_PLUGINS+=(
	"$(scwrypts --root 2>/dev/null)/scwrypts.plugin.zsh"
	)

() {  # default environment name lookup
	local ENVIRONMENT_NAME HOSTNAME="$(hostnamectl --static)"

	for ENVIRONMENT_NAME in \
		"local.${HOSTNAME}.secret" \
		"local.${HOSTNAME}" \
		"local" \
		"dev" \
		;
	do
		[ -f "$HOME/.config/scwrypts/environments/scwrypts/$ENVIRONMENT_NAME" ] \
			&& export SCWRYPTS_ENV="$ENVIRONMENT_NAME" \
			&& break
	done
}

#####################################################################
return 0
