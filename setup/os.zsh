#####################################################################

setup.os() {
	setup.os._.make-required-resources || return 1
	[[ "${CI}" == true ]] && { echo.status 'detected CI; skipping os setup'; return 0; }
	utils.io.getsudo

	local OS_NAME="$(setup.os._.get-os)"
	[ ! "${OS_NAME}" ] && utils.abort

	setup.os._.install-source-dependencies  || return 2
	setup.os._.install-managed-dependencies || return 3
}

setup.os._.get-os() {
	local OS_NAME="$(lsb_release -is 2>/dev/null | tr '[:upper:]' '[:lower:]')"

	[ ! "${OS_NAME}" ] \
		&& OS_NAME="$(sed -n 's/^ID=//p' /etc/os-release 2>/dev/null)"

	uname -s | grep -q Darwin \
		&& OS_NAME=macos

	[ ! "${OS_NAME}" ] \
		&& echo.warning 'failed to detect operating system' \
		&& OS_NAME="$(echo -e "arch\ndebian\nother" | utils.fzf 'select an operating system')" \
		;

	[[ "${OS_NAME}" =~ ^ubuntu$ ]] && OS_NAME=debian

	[[ "${OS_NAME}" =~ ^[Ee]ndeavour[Oo][Ss]$ ]] && OS_NAME=arch

	echo "${OS_NAME}"
}

#####################################################################

setup.os._.install-from-source() {  # clone + build/install a git-hosted package (AUR PKGBUILD or Makefile)
	local target_url="${1}"
	local name="${2:-$(echo "${target_url}" | sed 's/.*\///; s/\.git$//')}"
	local install_dir="${HOME}/.local/share/source-packages"
	mkdir -p "${install_dir}"

	if [ -d "${install_dir}/${name}" ]
	then
		echo.status "updating '${name}'"
		( cd "${install_dir}/${name}" && git pull origin "$(git rev-parse --abbrev-ref HEAD)" ) \
			&& echo.success "successfully updated '${name}'" \
			|| { echo.error "failed to update '${name}'"; return 1; }
	else
		echo.status "downloading '${name}'"
		git clone "${target_url}" "${install_dir}/${name}" \
			&& echo.success "successfully downloaded '${name}'" \
			|| { echo.error "failed to download '${name}'"; return 2; }
	fi

	cd "${install_dir}/${name}"
	if [ -f ./PKGBUILD ]
	then
		echo.status "installing '${name}'"
		yes | makepkg -si \
			&& echo.success "successfully installed '${name}'" \
			|| { echo.error "failed to install '${name}'"; return 3; }
	elif [ -f ./Makefile ]
	then
		echo.status "building '${name}'"
		make \
			&& echo.success "finished building '${name}'" \
			|| { echo.error "build failed for '${name}'"; return 4; }

		echo.status "installing '${name}'"
		utils.io.getsudo
		sudo make install \
			&& echo.success "successfully installed '${name}'" \
			|| { echo.error "failed to install '${name}'"; return 5; }
	else
		echo.warning 'could not detect supported installation method'
		echo.reminder "complete manual installation in the directory below:"
		echo.reminder "${install_dir}/${name}"
	fi
}

setup.os._.install-source-dependencies() {
	case "${OS_NAME}" in
		( arch )
			command -v yay >/dev/null 2>&1 \
				|| setup.os._.install-from-source 'https://aur.archlinux.org/yay.git' 'yay' \
				;
			;;

		( fedora ) ;;

		( debian ) ;;

		( macos )
			xcode-select -p &>/dev/null || {  # brew requires the xcode command line tools
				echo.status 'installing xcode command line tools'
				touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
				local clt_package="$(softwareupdate -l | grep '\*.*Command Line' | tail -n1 | sed 's/^[^C]*\(C.*\)/\1/')"
				sudo softwareupdate -i "${clt_package}" --verbose \
					&& echo.success 'successfully installed xcode command line tools' \
					|| echo.error 'failed to install xcode command line tools' \
					;
				rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
			}

			command -v brew &>/dev/null || {
				/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
				eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null)"
			}
			;;

		( * ) ;;
	esac

	[[ "${OS_NAME}" != macos ]] && [[ "${COMPILE_DMENU}" == true ]] \
		&& setup.os._.install-from-source 'https://github.com/tiyn/dmenu' 'patched-dmenu'

	return 0
}

#####################################################################

setup.os._.install-managed-dependencies() {
	local ERRORS=0

	echo.status 'checking os dependencies'
	case "${OS_NAME}" in
		( arch | fedora | debian | macos )
			;;

		( * )
			OS_NAME='generic'
			echo.warning "no automated installer available for '${OS_NAME}'"
			;;
	esac

	local dependencies_file
	[[ "${MIN}" == true ]] && [ -f "${DOTWRYN_PATH}/setup/os-dependencies/${OS_NAME}.min.txt" ] \
		&& dependencies_file="${DOTWRYN_PATH}/setup/os-dependencies/${OS_NAME}.min.txt" \
		|| dependencies_file="${DOTWRYN_PATH}/setup/os-dependencies/${OS_NAME}.txt" \
		;

	[[ "${CI}" != true ]] && {
		echo.status 'updating system, repositories, and mirrors'
		"setup.os._.update-repositories.${OS_NAME}"
	}

	local dependency
	for dependency in $(cat "${dependencies_file}")
	do
		"setup.os._.install-managed.${OS_NAME}" "${dependency}"
	done
	unset dependency

	[[ "${ERRORS}" -ne 0 ]] && {
		echo.warning "detected ${ERRORS} errors; double check warnings before proceeding!"
		utils.yN 'continue with install?' && return 0 || utils.abort
	}

	case "${OS_NAME}" in
		( macos )
			local shellenv_line='eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null)"'
			grep -qF "${shellenv_line}" "${HOME}/.zprofile" 2>/dev/null \
				|| echo "${shellenv_line}" >> "${HOME}/.zprofile"

			local gnubin_path
			for gnubin_path in "$(brew --prefix)"/opt/*/libexec/gnubin(N); do export PATH="${gnubin_path}:${PATH}"; done
			unset gnubin_path

			local gnubin_line='for P in "$(brew --prefix)"/opt/*/libexec/gnubin(N); do export PATH="${P}:${PATH}"; done'
			grep -qF "${gnubin_line}" "${HOME}/.zprofile" 2>/dev/null \
				|| echo "${gnubin_line}" >> "${HOME}/.zprofile"
			;;
	esac

	echo.success 'all dependencies satisfied'
	return 0
}

##########################################

setup.os._.update-repositories.arch() { yay -Syu; }
setup.os._.install-managed.arch() {
	local target="${1}"
	[[ "${target}" =~ aws-cli-v2 ]] && {
		echo.status "skipping aws-cli-v2 checks since they are bad right now"
		return 0
	}

	yay -Qq 2>/dev/null | grep -q "^${target}$\|^${target}-git$" && {
		echo.success "found '${target}'"
	} || {
		echo.status "installing '${target}'"
		yay -Syu --noconfirm "${target}" \
			&& echo.success "successfully installed '${target}'" \
			|| echo.error "failed to install '${target}'" \
			;
	}
}

##########################################

setup.os._.update-repositories.debian() { sudo apt-get update && sudo apt-get upgrade; }
setup.os._.install-managed.debian() {
	local target="${1}"
	echo.status "checking / installing '${target}'"
	sudo apt-get install --yes "${target}" \
		&& echo.success "'${target}' installed" \
		|| echo.error "failed to install ${target}" \
		;
}

##########################################

setup.os._.update-repositories.fedora() {
	: \
		&& sudo dnf update \
		&& sudo dnf upgrade \
		&& sudo dnf install -y dnf-plugins-core \
		&& sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo \
		;
}

setup.os._.install-managed.fedora() {
	local target="${1}"
	echo.status "checking / installing '${target}'"
	sudo dnf install -y "${target}" \
		&& echo.success "'${target}' installed" \
		|| echo.error "failed to install ${target}" \
		;
}

##########################################

setup.os._.update-repositories.macos() { brew update && brew upgrade; }
setup.os._.install-managed.macos() {
	local target="${1}"
	brew list --versions "${target}" &>/dev/null && {
		echo.success "found '${target}'"
	} || {
		echo.status "installing '${target}'"
		yes | brew install "${target}" \
			&& echo.success "'${target}' installed" \
			|| echo.error "failed to install ${target}" \
			;
	}
}

##########################################

setup.os._.update-repositories.generic() { return 0; }
setup.os._.install-managed.generic() {
	local target="${1}"
	command -v "${target}" >/dev/null 2>&1 \
		|| echo.error "could not find '${target}'; it's up to you to install this one!"
}

#####################################################################

setup.os._.make-required-resources() {
	local ERRORS=0
	local directories=(
		"${XDG_CONFIG_HOME:-${HOME}/.config}/wryn"
		"${HOME}/.local/bin"
		)

	local files=(
		"${HOME}/.zshrc"
		)

	echo.status 'making required system resources'
	local directory
	for directory in "${directories[@]}"
	do
		[ ! -d "${directory}" ] && { mkdir -p "${directory}" || echo.error "failed to create directory '${directory}'"; }
	done
	unset directory

	local file
	for file in "${files[@]}"
	do
		[ ! -f "${file}" ] && { touch "${file}" || echo.error "failed to create file '${file}'"; }
	done
	unset file

	[[ "${ERRORS}" -eq 0 ]] \
		&& echo.success 'finished creating system resources' \
		|| echo.error 'failed to create system resources' \
		;

	return "${ERRORS}"
}
