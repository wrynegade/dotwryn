#####################################################################

SETUP__OS() {
	OS__MAKE_REQUIRED_RESOURCES      || return 1
	[ ${CI} ] && { STATUS 'detected CI; skipping os setup'; return 0; }
	GETSUDO

	local OS_NAME=$(OS__GET_OS)
	[ ! ${OS_NAME} ] && ABORT

	OS__INSTALL_SOURCE_DEPENDENCIES  || return 2
	OS__INSTALL_MANAGED_DEPENDENCIES || return 3
}

OS__GET_OS() {
	local OS_NAME=$(lsb_release -is 2>/dev/null | tr '[:upper:]' '[:lower:]')

	[ ! ${OS_NAME} ] \
		&& OS_NAME=$(cat /etc/os-release 2>/dev/null | sed -n 's/^ID=//p')

	uname -s | grep -q Darwin \
		&& OS_NAME=macos

	[ ! ${OS_NAME} ] \
		&& WARNING 'failed to detect operating system' \
		&& OS_NAME=$(echo -e "arch\ndebian\nother" | FZF 'select an operating system') \
		;

	[[ ${OS_NAME} =~ ^ubuntu$ ]] && OS_NAME=debian

	[[ ${OS_NAME} =~ ^[Ee]ndeavour[Oo][Ss]$ ]] && OS_NAME=arch

	echo ${OS_NAME}
}

#####################################################################

OS__INSTALL_SOURCE_DEPENDENCIES() {
	case ${OS_NAME} in
		( arch )
			command -v yay >/dev/null 2>&1 \
				|| SCWRYPTS packages/install -- 'https://aur.archlinux.org/yay.git' --local-name 'yay' \
				;
			;;

		( fedora ) ;;

		( debian ) ;;

		( macos )
			command -v brew &>/dev/null \
				|| /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
			;;

		( * ) ;;
	esac

	[ ${COMPILE_DMENU} ] && [[ ${COMPILE_DMENU} -eq 1 ]] \
		&& SCWRYPTS packages/install -- 'https://github.com/tiyn/dmenu' --local-name 'patched-dmenu'

	return 0
}

#####################################################################

OS__INSTALL_MANAGED_DEPENDENCIES() {
	local ERRORS=0

	STATUS 'checking os dependencies'
	case ${OS_NAME} in
		( arch | fedora | debian | macos )
			;;

		( * )
			OS_NAME='generic'
			WARNING "no automated installer available for '${OS_NAME}'"
			;;
	esac

	[ ${MIN} ] && [[ ${MIN} -eq 1 ]] && [ -f "${DOTWRYN_PATH}/setup/os-dependencies/${OS_NAME}.min.txt" ] \
		&& DEPENDENCIES="${DOTWRYN_PATH}/setup/os-dependencies/${OS_NAME}.min.txt" \
		|| DEPENDENCIES="${DOTWRYN_PATH}/setup/os-dependencies/${OS_NAME}.txt" \
		;

	[ ! ${CI} ] && {
		STATUS 'updating system, repositories, and mirrors'
		UPDATE_REPOSITORIES__${OS_NAME}
	}

	for DEPENDENCY in $(cat "${DEPENDENCIES}")
	do
		INSTALL_MANAGED__${OS_NAME} ${DEPENDENCY}
	done

	[[ ${ERRORS} -ne 0 ]] && {
		WARNING "detected ${ERRORS} errors; double check warnings before proceeding!"
		yN 'continue with install?' && return 0 || ABORT
	}

	case ${OS_NAME} in
		( macos )
			zsh -c 'source ~/.zprofile &>/dev/null; sed --version 2>&1 | grep GNU | grep -qv BSD' || {
				STATUS "detected BSD sed priority; updating GNU utilities in homebrew"
				for P in "$(brew --prefix)"/opt/*/libexec/gnubin; do export PATH="$P:$PATH"; done

				echo 'for P in "$(brew --prefix)"/opt/*/libexec/gnubin; do export PATH="$P:$PATH"; done' >> "${HOME}/.zprofile"
			}
			;;
	esac

	SUCCESS 'all dependencies satisfied'
	return 0
}

##########################################

UPDATE_REPOSITORIES__arch() { yay -Syu; }
INSTALL_MANAGED__arch() {
	local TARGET="$1"
	[[ ${TARGET} =~ aws-cli-v2 ]] && {
		STATUS "skipping aws-cli-v2 checks since they are bad right now"
		return 0
	}

	yay -Qq 2>/dev/null | grep -q "^${TARGET}$\|^${TARGET}-git$" && {
		SUCCESS "found '${TARGET}'"
	} || {
		STATUS "installing '${TARGET}'"
		yay -Syu --noconfirm ${TARGET} \
			&& SUCCESS "successfully installed '${TARGET}'" \
			|| ERROR "failed to install '${TARGET}'" \
			;
	}
}

##########################################

UPDATE_REPOSITORIES__debian() { sudo apt-get update && sudo apt-get upgrade; }
INSTALL_MANAGED__debian() {
	STATUS "checking / installing '$1'"
	sudo apt-get install --yes $1 \
		&& SUCCESS "'$1' installed" \
		|| ERROR "failed to install $1" \
		;
}

##########################################

UPDATE_REPOSITORIES__fedora() {
	: \
		&& sudo dnf update \
		&& sudo dnf upgrade \
		&& sudo dnf install -y dnf-plugins-core \
		&& sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo \
		;
}

INSTALL_MANAGED__fedora() {
	STATUS "checking / installing '$1'"
	sudo dnf install -y $1 \
		&& SUCCESS "'$1' installed" \
		|| ERROR "failed to install $1" \
		;
}

##########################################

UPDATE_REPOSITORIES__macos() { brew update && brew upgrade; }
INSTALL_MANAGED__macos() {
	STATUS "checking / installing '$1'"
	yes | brew install $1 \
		&& SUCCESS "'$1' installed" \
		|| ERROR "failed to install $1" \
		;
}

##########################################

UPDATE_REPOSITORIES__generic() { return 0; }
INSTALL_MANAGED__generic() {
	command -v $1 >/dev/null 2>&1 \
		|| ERROR "could not find '$1'; it's up to you to install this one!"
}

#####################################################################

OS__MAKE_REQUIRED_RESOURCES() {
	local ERRORS=0
	local DIRECTORIES=(
		"${XDG_CONFIG_HOME:-${HOME}/.config}/wryn"
		"${HOME}/.local/bin"
		)

	local FILES=(
		"${HOME}/.zshrc"
		)

	STATUS 'making required system resources'
	for D in ${DIRECTORIES}
	do
		[ ! -d ${D} ] && { mkdir -p ${D} || ERROR "failed to create directory '${D}'"; }
	done

	for F in ${FILES}
	do
		[ ! -f ${F} ] && { touch ${F} || ERROR "failed to create file '${F}'"; }
	done

	[[ ${ERRORS} -eq 0 ]] \
		&& SUCCESS 'finished creating system resources' \
		|| ERROR 'failed to create system resources' \
		;

	return ${ERRORS}
}
