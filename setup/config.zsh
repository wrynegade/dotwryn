function SETUP__CONFIG() {
	STATUS 'starting application configuration'

	GENERATE_INITIAL_LOCAL_CONFIG

	SCWRYPTS system/config/update || return 1

	CONFIG__ZSH || return 2
	CONFIG__VIM || return 3

	CONFIG__SYSTEM || return 4

	SCWRYPTS generate i3 config || return 5

	SUCCESS 'finished application configuration'
}

#####################################################################

GENERATE_INITIAL_LOCAL_CONFIG() {
	local HOSTNAME="$(hostnamectl --static || hostname | sed 's/\.local$//')"
	[ ${HOSTNAME} ] || return 0

	mkdir -p "${DOTWRYN_PATH}/bin/${HOSTNAME}"

	local ENV_DIR="${DOTWRYN_PATH}/config/scwrypts/environments"
	local GROUP
	for GROUP in $(find "${ENV_DIR}" -type f -name \*env.yaml | sed -n 's|.*/local\.\([^.]*\)\.env\.yaml|\1|p')
	do
		[ -f "${ENV_DIR}/local.${HOSTNAME}.${GROUP}.env.yaml" ] \
			|| cp "${ENV_DIR}/local.altaria.${GROUP}.env.yaml" "${ENV_DIR}/local.${HOSTNAME}.${GROUP}.env.yaml"
	done
}

#####################################################################

CONFIG__ZSH() {
	CONFIG__ENV zsh || return 1
	CONFIG__RC  zsh || return 2
	CONFIG__SET_DEFAULT_SHELL || return 3
}

CONFIG__SET_DEFAULT_SHELL() {
	local DEFAULT_SHELL=$(awk -F: -v user="${USER}" '$1 == user {print $NF}' /etc/passwd)
	[[ ${DEFAULT_SHELL} =~ zsh ]] && return 0

	[ ${FORCE_ROOT} ] && return 0

	STATUS 'setting zsh as default shell'
	sudo chsh -s $(which zsh) $(whoami) 2>&1 \
		&& SUCCESS "set zsh as default shell for '${USER}'" \
		|| FAIL 1 'failed to set zsh as default shell' \
		;
}

#####################################################################

CONFIG__VIM() {
	CONFIG__RC  vim || return 1

	STATUS 'starting vim setup'
	SCWRYPTS --name system/vim/vundle/install --group scwrypts --type zsh || return 2

	CONFIG__VIM__LINK_SUPERUSER_RC

	return 0
}

CONFIG__VIM__LINK_SUPERUSER_RC() {
	sudo [ /root/.vimrc ] && return 0

	echo "let ${DOTWRYN}=\"${DOTWRYN_PATH}\"\nsource \"${DOTWRYN_PATH}/vim/rc.vim\"" \
		| sudo tee /root/.vimrc >/dev/null

	sudo mkdir -p /root/.vim
	sudo ln -s /home/w0ryn/.vim/bundle /root/.vim/bundle
}

#####################################################################

CONFIG__SYSTEM() {
	SCWRYPTS dotwryn system setup
}

#####################################################################

CONFIG__ENV() {
	local DEFAULT_CONFIG="${DOTWRYN_PATH}/config/dotwryn.env.$1"
	local LOCAL_CONFIG="${HOME}/.config/wryn/env.$1"

	[ -f ${LOCAL_CONFIG} ] && {
		case ${OVERWRITE_EXISTING} in
			0 ) return 0 ;;
			1 )
				WARNING "local $1 configuration exists (${LOCAL_CONFIG})"
				yN 'overwrite this configuration?' || return 0

				mv "${LOCAL_CONFIG}" "${LOCAL_CONFIG}.bak" >/dev/null 2>&1 \
					&& INFO "created backup of local configuration (${LOCAL_CONFIG}.bak)"
		esac
	}

	STATUS "setting up $1 configuration (${LOCAL_CONFIG})"

	case $1 in
		zsh ) COMMENT='#' ;;
	esac

	{
		echo "source ${DEFAULT_CONFIG}"
		echo -e "\\n${COMMENT}\n${COMMENT} .wryn configuration overrides\n${COMMENT}\n"
		sed "s/^[^${COMMENT}].*/${COMMENT}&/" ${DEFAULT_CONFIG}
	} > ${LOCAL_CONFIG} \
		&& SUCCESS "created $1 configuration" \
		|| FAIL 1 "unable to create $1 configuration" \
		;

	EDITOR=vim VISUAL=vim EDIT "${LOCAL_CONFIG}"
}


CONFIG__RC() {
	local TYPE="$1"
	local RC
	case ${TYPE} in
		vim )
			RC="${XDG_CONFIG_HOME:-${HOME}/.config}/vim/vimrc"
			mkdir -p -- "$(dirname -- "${RC}")"
			[ -f "${HOME}/.vimrc" ] \
				&& cat "${HOME}/.vimrc" >> "${XDG_CONFIG_HOME:-${HOME}/.config}/vim/vimrc" \
				&& rm "${HOME}/.vimrc" \
				;
			;;
		* ) RC="${HOME}/.${TYPE}rc";
			;;
	esac

	local SOURCE_LINE
	case ${TYPE} in
		zsh ) SOURCE_LINE="source ${DOTWRYN_PATH}/zsh/rc" ;;
		vim ) SOURCE_LINE="source ${DOTWRYN_PATH}/vim/rc.vim" ;;
	esac


	grep -q "^${SOURCE_LINE}$" "${RC}" \
		|| echo "${SOURCE_LINE}" >> ${RC}

	grep -q "^${SOURCE_LINE}$" "${RC}" \
		&& SUCCESS "${TYPE}rc is configured correctly" \
		|| FAIL 1 "failed to configure ${TYPE}rc" \
		;
}
