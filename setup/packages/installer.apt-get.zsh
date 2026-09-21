#####################################################################

setup.packages.installer.apt-get.update-repositories() { sudo apt-get update && sudo apt-get upgrade; }

setup.packages.installer.apt-get.list-installed() { dpkg-query -W -f='${Package}\n' 2>/dev/null; }

setup.packages.installer.apt-get.install-batch() { sudo apt-get install --yes "${@}"; }

setup.packages.installer.apt-get.install-managed() {
	local target="${1}"
	echo.status "checking / installing '${target}'"
	sudo apt-get install --yes "${target}" \
		&& echo.success "'${target}' installed" \
		|| echo.error "failed to install ${target}" \
		;
}
