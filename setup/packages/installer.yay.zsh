#####################################################################

setup.packages.installer.yay.setup-package-manager() {
	command -v yay &>/dev/null && return 0
	setup.packages.install-from-source 'https://aur.archlinux.org/yay.git' 'yay'
}

setup.packages.installer.yay.update-repositories() { yay -Syu; }
setup.packages.installer.yay.list-installed()      { yay -Qq 2>/dev/null; }
setup.packages.installer.yay.install-batch()       { yay -Syu --noconfirm "${@}"; }

setup.packages.installer.yay.install-managed() {
	local target="${1}"
	local installed_target="$(setup.packages.installer.yay.list-installed | grep "^${target}$\|^${target}-git$")"

	[[ "${installed_target}" ]] \
		&& echo.success "found '${installed_target}'" \
		&& return 0

	: \
		&& echo.status "installing '${target}'" \
		&& yay -Syu --noconfirm "${target}" \
		&& : \
		&& echo.success "successfully installed '${target}'" \
		|| echo.error "failed to install '${target}'" \
	;
}
