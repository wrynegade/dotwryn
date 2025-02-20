#####################################################################

utils.vim() {
	utils.dependencies.check vim \
		|| return 1

	vim $@ </dev/tty >/dev/tty;
}

#####################################################################

config.vim.get-config-dir() {
	local VIM_CONFIG_DIR

	[ -d "${HOME}/.vim" ] \
		&& VIM_CONFIG_DIR="${HOME}/.vim" \
		|| VIM_CONFIG_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/vim" \
		;

	mkdir -p -- "${VIM_CONFIG_DIR}" \
		&& echo "${VIM_CONFIG_DIR}" \
		|| echo.error "unable to determine vim config dir" \
		;
}

config.vim.get-plugin-dir() {
	local VIM_CONFIG_DIR="$(config.vim.get-config-dir)"
	[ "${VIM_CONFIG_DIR}" ] || return 1

	echo "${VIM_CONFIG_DIR}/bundle"
}
