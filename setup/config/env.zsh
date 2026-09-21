#####################################################################

setup.config.env() {
	local config_type="${1}"
	local default_config="${DOTWRYN_SETUP__DOTWRYN}/${config_type}/env.${config_type}"
	local local_config="${HOME}/.config/wryn/env.${config_type}"

	if [[ -f "${local_config}" ]]
	then
		case "${DOTWRYN_SETUP__OVERWRITE_EXISTING}" in
			( false ) return 0 ;;
			( true )
				echo.warning "local ${config_type} configuration exists (${local_config})"
				utils.yN 'overwrite this configuration?' || return 0

				mv -- "${local_config}" "${local_config}.bak" &>/dev/null \
					&& echo.status "created backup of local configuration (${local_config}.bak)"
				;;
		esac
	fi

	echo.status "setting up ${config_type} configuration (${local_config})"

	local comment='#'

	{
		echo "source ${default_config}"
		echo -e "\\n${comment}\n${comment} .wryn configuration overrides\n${comment}\n"
		sed "s/^[^${comment}].*/${comment}&/" "${default_config}"
	} > "${local_config}" \
		&& echo.success "created ${config_type} configuration" \
		|| echo.error "unable to create ${config_type} configuration" \
		|| return 1

	EDITOR=vim VISUAL=vim utils.io.edit "${local_config}"
}
