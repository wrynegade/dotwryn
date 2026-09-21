#####################################################################

setup.config.vim() { : \
	&& echo.status 'configuring vim rc' \
	&& setup.config.rc vim \
	&& : \
	&& echo.status 'starting vim setup' \
	&& setup.scwrypts dotwryn vundle update \
	&& setup.config.vim._.link-superuser-rc \
; }

setup.config.vim._.link-superuser-rc() {
	# already root (a container build) needs no sudo, and a machine
	# without sudo at all can't get one
	local sudo=sudo
	[[ "${EUID}" -eq 0 ]] && sudo=''
	[[ -n "${sudo}" ]] && ! command -v sudo &>/dev/null \
		&& echo.warning 'sudo unavailable; skipping superuser vimrc' \
		&& return 0

	${sudo} test -f /root/.vimrc && return 0

	echo "let \$DOTWRYN=\"${DOTWRYN_SETUP__DOTWRYN}\"\nsource \"${DOTWRYN_SETUP__DOTWRYN}/vim/rc.vim\"" \
		| ${sudo} tee /root/.vimrc >/dev/null

	${sudo} mkdir -p -- /root/.vim
	${sudo} ln -s -- "${HOME}/.vim/bundle" /root/.vim/bundle
}
