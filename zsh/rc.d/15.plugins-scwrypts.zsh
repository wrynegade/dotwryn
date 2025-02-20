#####################################################################

ZSH_PLUGINS+=(
	"$(scwrypts --root)/scwrypts.plugin.zsh"
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
		[ -f "${XDG_CONFIG_HOME:-${HOME}/.config}/scwrypts/environments/$ENVIRONMENT_NAME.scwrypts.env.yaml" ] \
			&& export SCWRYPTS_ENV="$ENVIRONMENT_NAME" \
			&& break
	done
}

#####################################################################
return 0
