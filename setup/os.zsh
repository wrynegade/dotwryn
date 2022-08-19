#####################################################################

SETUP__OS() {
	OS__MAKE_REQUIRED_RESOURCES      || return 1
	[ $CI ] && { __STATUS 'detected CI; skipping os setup'; return 0; }
	__GETSUDO

	local OS_NAME=$(OS__GET_OS)
	[ ! $OS_NAME ] && __ABORT

	OS__INSTALL_SOURCE_DEPENDENCIES  || return 2
	OS__INSTALL_MANAGED_DEPENDENCIES || return 3
}

OS__GET_OS() {
	local OS_NAME=$(lsb_release -is 2>/dev/null | tr '[:upper:]' '[:lower:]')

	[ ! $OS_NAME ] \
		&& OS_NAME=$(cat /etc/os-release 2>/dev/null | grep '^ID=' | sed 's/^ID=//')

	[ ! $OS_NAME ] \
		&& __WARNING 'failed to detect operating system' \
		&& OS_NAME=$(echo -e "arch\ndebian\nother" | __FZF 'select an operating system') \
		;

	[[ $OS_NAME =~ ^ubuntu$ ]] && OS_NAME=debian

	echo $OS_NAME
}

#####################################################################

OS__INSTALL_SOURCE_DEPENDENCIES() {
	case $OS_NAME in
		arch )
			SCWRYPTS zsh/git/package/install \
				'https://aur.archlinux.org/yay.git' \
				--local-name 'yay' \
				;
			;;
		debian ) ;;
		* ) ;;
	esac

	SCWRYPTS zsh/git/package/install \
		'https://github.com/tiyn/dmenu' \
		--local-name 'patched-dmenu' \
		;
}

#####################################################################

OS__INSTALL_MANAGED_DEPENDENCIES() {
	local ERRORS=0

	__STATUS 'checking os dependencies'
	case $OS_NAME in
		arch )
			__REMINDER "package 'base-devel' is required"
			;;
		debian ) ;;
		* )
			OS_NAME='generic'
			__WARNING "no automated installer available for '$OS_NAME'"
			;;
	esac

	for DEPENDENCY in $(cat "$DOTWRYN_PATH/setup/os-dependencies/$OS_NAME.txt")
	do
		INSTALL_MANAGED__$OS_NAME $DEPENDENCY
	done

	[[ $ERRORS -ne 0 ]] && {
		__WARNING "detected $ERRORS errors; double check warnings before proceeding!"
		__yN 'continue with install?' && return 0 || __ABORT
	}

	__SUCCESS 'all dependencies satisfied'
	return 0
}

INSTALL_MANAGED__arch() {
	local TARGET="$1"

	__STATUS "checking for $TARGET"

	pacman -Qq | grep -q "^$TARGET$\|^$TARGET-git$" && {
		__SUCCESS "found installation of '$TARGET'"
	} || {
		__WARNING "'$TARGET' not found"

		__STATUS "installing '$TARGET'"
		sudo pacman -Syu --noconfirm $TARGET \
			&& __SUCCESS "successfully installed '$TARGET'" \
			|| __ERROR "failed to install '$TARGET'"
	}
}

INSTALL_MANAGED__debian() {
	__STATUS "checking / installing '$1'"
	sudo apt-get install --yes $1 \
		&& __SUCCESS "'$1' installed" \
		|| __ERROR "failed to install $TARGET" \
		;
}

INSTALL_MANAGED__generic() {
	command -v $1 >/dev/null 2>&1 \
		|| __ERROR "could not find '$1'; it's up to you to install this one!"
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

	__STATUS 'making required system resources'
	for D in $DIRECTORIES
	do
		[ ! -d $D ] && { mkdir -p $D || __ERROR "failed to create directory '$D'"; }
	done

	for F in $FILES
	do
		[ ! -f $F ] && { touch $F || __ERROR "failed to create file '$F'"; }
	done

	[[ $ERRORS -eq 0 ]] \
		&& __SUCCESS 'finished creating system resources' \
		|| __ERROR 'failed to create system resources' \
		;

	return $ERRORS
}
