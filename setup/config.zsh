setup.config() {
	echo.status 'starting application configuration'

	setup.config._.generate-initial-local-config

	setup.config._.zsh || return 2
	setup.config._.vim || return 3

	setup.config._.system || return 4

	SCWRYPTS generate i3 config || return 5

	echo.success 'finished application configuration'
}

#####################################################################

setup.config._.generate-initial-local-config() {
	local local_hostname="$(hostnamectl --static 2>/dev/null || hostname 2>/dev/null | sed 's/\.local$//')"
	[ "${local_hostname}" ] || return 0

	mkdir -p "${DOTWRYN_PATH}/bin/${local_hostname}"

	local env_dir="${DOTWRYN_PATH}/config/scwrypts/environments"
	local group
	for group in $(find "${env_dir}" -type f -name \*env.yaml | sed -n 's|.*/local\.\([^.]*\)\.env\.yaml|\1|p')
	do
		[ -f "${env_dir}/local.${local_hostname}.${group}.env.yaml" ] && continue

		if [ -f "${env_dir}/local.altaria.${group}.env.yaml" ]
		then
			cp "${env_dir}/local.altaria.${group}.env.yaml" "${env_dir}/local.${local_hostname}.${group}.env.yaml"
		else
			cp "${env_dir}/local.${group}.env.yaml" "${env_dir}/local.${local_hostname}.${group}.env.yaml"
		fi
	done
	unset group

	local local_override
	for local_override in \
		i3/local.yaml \
		polybar/local.ini \
		alacritty/local.toml \
		;
	do
		mkdir -p -- "${DOTWRYN_PATH}/config/${local_hostname}/user/$(dirname -- "${local_override}")"
		touch -- "${DOTWRYN_PATH}/config/${local_hostname}/user/${local_override}"
	done
	unset local_override
}

#####################################################################

setup.config._.zsh() {
	setup.config._.env zsh || return 1
	setup.config._.rc  zsh || return 2
	setup.config._.set-default-shell || return 3
}

setup.config._.set-default-shell() {
	local default_shell="$(awk -F: -v user="${USER}" '$1 == user {print $NF}' /etc/passwd)"
	[[ "${default_shell}" =~ zsh ]] && return 0

	[[ "${FORCE_ROOT}" == true ]] && return 0

	echo.status 'setting zsh as default shell'
	sudo chsh -s "$(which zsh)" "$(whoami)" 2>&1 \
		&& echo.success "set zsh as default shell for '${USER}'" \
		|| utils.fail 1 'failed to set zsh as default shell' \
		;
}

#####################################################################

setup.config._.vim() {
	setup.config._.rc vim || return 1

	echo.status 'starting vim setup'
	SCWRYPTS dotwryn vundle update || return 2

	setup.config._.vim.link-superuser-rc

	return 0
}

setup.config._.vim.link-superuser-rc() {
	sudo [ -f /root/.vimrc ] && return 0

	echo "let \$DOTWRYN=\"${DOTWRYN_PATH}\"\nsource \"${DOTWRYN_PATH}/vim/rc.vim\"" \
		| sudo tee /root/.vimrc >/dev/null

	sudo mkdir -p /root/.vim
	sudo ln -s "${HOME}/.vim/bundle" /root/.vim/bundle
}

#####################################################################

setup.config._.system() {
	SCWRYPTS dotwryn system setup
}

#####################################################################

setup.config._.env() {
	local config_type="${1}"
	local default_config="${DOTWRYN_PATH}/${config_type}/env.${config_type}"
	local local_config="${HOME}/.config/wryn/env.${config_type}"

	[ -f "${local_config}" ] && {
		case "${OVERWRITE_EXISTING}" in
			( false ) return 0 ;;
			( true )
				echo.warning "local ${config_type} configuration exists (${local_config})"
				utils.yN 'overwrite this configuration?' || return 0

				mv "${local_config}" "${local_config}.bak" >/dev/null 2>&1 \
					&& echo.status "created backup of local configuration (${local_config}.bak)"
				;;
		esac
	}

	echo.status "setting up ${config_type} configuration (${local_config})"

	local comment
	case "${config_type}" in
		( zsh ) comment='#' ;;
	esac

	{
		echo "source ${default_config}"
		echo -e "\\n${comment}\n${comment} .wryn configuration overrides\n${comment}\n"
		sed "s/^[^${comment}].*/${comment}&/" "${default_config}"
	} > "${local_config}" \
		&& echo.success "created ${config_type} configuration" \
		|| utils.fail 1 "unable to create ${config_type} configuration" \
		;

	EDITOR=vim VISUAL=vim utils.io.edit "${local_config}"
}


setup.config._.rc() {
	local config_type="${1}"
	local rc
	case "${config_type}" in
		( vim )
			rc="${XDG_CONFIG_HOME:-${HOME}/.config}/vim/vimrc"
			mkdir -p -- "$(dirname -- "${rc}")"
			[ -f "${HOME}/.vimrc" ] \
				&& cat "${HOME}/.vimrc" >> "${XDG_CONFIG_HOME:-${HOME}/.config}/vim/vimrc" \
				&& rm "${HOME}/.vimrc" \
				;
			;;
		( * ) rc="${HOME}/.${config_type}rc" ;;
	esac

	local source_line
	case "${config_type}" in
		( zsh ) source_line="source ${DOTWRYN_PATH}/zsh/rc" ;;
		( vim ) source_line="source ${DOTWRYN_PATH}/vim/rc.vim" ;;
	esac

	grep -q "^${source_line}$" "${rc}" \
		|| echo "${source_line}" >> "${rc}"

	grep -q "^${source_line}$" "${rc}" \
		&& echo.success "${config_type}rc is configured correctly" \
		|| utils.fail 1 "failed to configure ${config_type}rc" \
		;
}
