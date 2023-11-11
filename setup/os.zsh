#####################################################################

SETUP__OS() {
	OS__MAKE_REQUIRED_RESOURCES      || return 1
	[ $CI ] && { STATUS 'detected CI; skipping os setup'; return 0; }
	GETSUDO

	local OS_NAME=$(OS__GET_OS)
	[ ! $OS_NAME ] && ABORT

	OS__INSTALL_SOURCE_DEPENDENCIES  || return 2
	OS__INSTALL_MANAGED_DEPENDENCIES || return 3
}

OS__GET_OS() {
	local OS_NAME=$(lsb_release -is 2>/dev/null | tr '[:upper:]' '[:lower:]')

	[ ! $OS_NAME ] \
		&& OS_NAME=$(cat /etc/os-release 2>/dev/null | grep '^ID=' | sed 's/^ID=//')

	[ ! $OS_NAME ] \
		&& WARNING 'failed to detect operating system' \
		&& OS_NAME=$(echo -e "arch\ndebian\nother" | FZF 'select an operating system') \
		;

	[[ $OS_NAME =~ ^ubuntu$ ]] && OS_NAME=debian

	[[ $OS_NAME =~ ^[Ee]ndeavour[Oo][Ss]$ ]] && OS_NAME=arch

	echo $OS_NAME
}

#####################################################################

OS__INSTALL_SOURCE_DEPENDENCIES() {
	case $OS_NAME in
		arch )
			command -v yay >/dev/null 2>&1 \
				|| SCWRYPTS packages/install -- 'https://aur.archlinux.org/yay.git' --local-name 'yay' \
				;
			;;
		debian ) ;;
		* ) ;;
	esac

	[ $COMPILE_DMENU ] && [[ $COMPILE_DMENU -eq 1 ]] \
		&& SCWRYPTS packages/install -- 'https://github.com/tiyn/dmenu' --local-name 'patched-dmenu'

	return 0
}

#####################################################################

OS__INSTALL_MANAGED_DEPENDENCIES() {
	local ERRORS=0

	STATUS 'checking os dependencies'
	case $OS_NAME in
		arch )
			;;
		debian ) ;;
		* )
			OS_NAME='generic'
			WARNING "no automated installer available for '$OS_NAME'"
			;;
	esac

	for DEPENDENCY in $(cat "$DOTWRYN_PATH/setup/os-dependencies/$OS_NAME.txt")
	do
		INSTALL_MANAGED__$OS_NAME $DEPENDENCY
	done

	[[ $ERRORS -ne 0 ]] && {
		WARNING "detected $ERRORS errors; double check warnings before proceeding!"
		yN 'continue with install?' && return 0 || ABORT
	}

	SUCCESS 'all dependencies satisfied'
	return 0
}

INSTALL_MANAGED__arch() {
	local TARGET="$1"

	STATUS "checking for $TARGET"

	pacman -Qq | grep -q "^$TARGET$\|^$TARGET-git$" && {
		SUCCESS "found installation of '$TARGET'"
	} || {
		WARNING "'$TARGET' not found"

		STATUS "installing '$TARGET'"
		sudo pacman -Syu --noconfirm $TARGET \
			&& SUCCESS "successfully installed '$TARGET'" \
			|| ERROR "failed to install '$TARGET'"
	}
}

INSTALL_MANAGED__debian() {
	STATUS "checking / installing '$1'"
	sudo apt-get install --yes $1 \
		&& SUCCESS "'$1' installed" \
		|| ERROR "failed to install $TARGET" \
		;
}

INSTALL_MANAGED__generic() {
	command -v $1 >/dev/null 2>&1 \
		|| ERROR "could not find '$1'; it's up to you to install this one!"
}

#####################################################################

OS__MAKE_REQUIRED_RESOURCES() {
	local ERRORS=0
	local DIRECTORIES=(
		"$HOME/.config/wryn"
		"$HOME/.local/bin"
		"$HOME/.vim/bundle"
		"$HOME/.vim/colors"
		)

	local FILES=(
		"$HOME/.vimrc"
		"$HOME/.zshrc"
		)

	STATUS 'making required system resources'
	for D in $DIRECTORIES
	do
		[ ! -d $D ] && { mkdir -p $D || ERROR "failed to create directory '$D'"; }
	done

	for F in $FILES
	do
		[ ! -f $F ] && { touch $F || ERROR "failed to create file '$F'"; }
	done

	[[ $ERRORS -eq 0 ]] \
		&& SUCCESS 'finished creating system resources' \
		|| ERROR 'failed to create system resources' \
		;

	return $ERRORS
}
