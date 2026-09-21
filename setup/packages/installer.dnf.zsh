#####################################################################

setup.packages.installer.dnf.update-repositories() {
	: \
		&& sudo dnf update \
		&& sudo dnf upgrade \
		&& sudo dnf install -y dnf-plugins-core \
		&& sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo \
		;
}

setup.packages.installer.dnf.list-installed() { rpm -qa --qf '%{NAME}\n' 2>/dev/null; }

setup.packages.installer.dnf.install-batch() { sudo dnf install -y "${@}"; }

setup.packages.installer.dnf.install-managed() {
	local target="${1}"
	echo.status "checking / installing '${target}'"
	sudo dnf install -y "${target}" \
		&& echo.success "'${target}' installed" \
		|| echo.error "failed to install ${target}" \
		;
}
