#####################################################################

setup.config.zsh() { : \
	&& setup.config.env zsh \
	&& setup.config.rc  zsh \
	&& setup.config._.set-default-shell \
; }

setup.config._.set-default-shell() {
	local default_shell="$(awk -F: -v user="${USER}" '$1 == user {print $NF}' /etc/passwd)"
	[[ "${default_shell}" =~ zsh ]] && return 0

	[[ "${DOTWRYN_SETUP__FORCE_ROOT}" == true ]] && return 0

	: \
		&& echo.status 'setting zsh as default shell' \
		&& sudo chsh -s "$(command -v zsh)" "${USER}" 2>&1 \
		&& echo.success "set zsh as default shell for '${USER}'" \
		|| echo.error 'failed to set zsh as default shell' \
		|| return 1 \
	;
}
