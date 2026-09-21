#####################################################################

setup.config.rc() {
	local config_type="${1}"
	local rc
	case "${config_type}" in
		( vim )
			rc="${XDG_CONFIG_HOME:-${HOME}/.config}/vim/vimrc"
			mkdir -p -- "$(dirname -- "${rc}")"
			[[ -f "${HOME}/.vimrc" ]] \
				&& cat "${HOME}/.vimrc" >> "${rc}" \
				&& rm -- "${HOME}/.vimrc" \
				;
			;;
		( * ) rc="${HOME}/.${config_type}rc" ;;
	esac
	touch -- "${rc}"

	local source_line comment
	case "${config_type}" in
		( zsh )
			source_line="source ${DOTWRYN_SETUP__DOTWRYN}/zsh/rc"
			comment='#'
			;;
		( vim )
			source_line="source ${DOTWRYN_SETUP__DOTWRYN}/vim/rc.vim"
			comment='"'
			;;
		( * )
			echo.error "no rc source-line defined for '${config_type}'"
			return 1
			;;
	esac

	setup.filesystem.write-managed-block "${rc}" --comment "${comment}" --tag dotwryn-rc --one-line <<-EOF
		${source_line}
	EOF

	grep -qF -- "${source_line}" "${rc}" \
		&& echo.success "${config_type}rc is configured correctly" \
		|| echo.error "failed to configure ${config_type}rc" \
		|| return 1
}
