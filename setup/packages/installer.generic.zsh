#####################################################################

setup.packages.installer.generic.install-managed() {
	local target="${1}"
	command -v "${target}" &>/dev/null \
		|| echo.error "could not find '${target}'; it's up to you to install this one!"
}
