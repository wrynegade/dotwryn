################################################################################
### Automated System Dependency Install ########################################
################################################################################

[ $DOTWRYN_PATH ]\
	&& DEPENDENCY_DIR="$DOTWRYN_PATH/setup/os-dependencies" \
	|| DEPENDENCY_DIR="${0:a:h}"

function OS_DEPENDENCY__SETUP() {
	local ERROR=0
	STATUS 'checking os dependencies'

	local OS_NAME=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
	STATUS "detected os '$OS_NAME'"

	case $OS_NAME in
		arch )
			OS_INSTALL() { OS_INSTALL__ARCH $@; }
			;;
		debian | ubuntu )
			OS_INSTALL() { OS_INSTALL__DEBIAN $@; }
			OS_NAME='debian'
			;;
		* )
			WARNING
			WARNING "no automated installer available for '$OS_NAME'"
			WARNING "if dependency shows a warning, install the indicated package"
			WARNING
			OS_INSTALL() { OS_INSTALL__GENERIC $@; }
			OS_NAME='generic'
			;;
	esac

	for DEPENDENCY in $(cat "$DEPENDENCY_DIR/$OS_NAME.txt")
	do
		OS_INSTALL $DEPENDENCY || ERROR=1
	done
	unset -f OS_INSTALL

	[[ $ERROR -eq 0 ]] && {
		SUCCESS 'all dependencies satisfied'
		USER_PROMPT 'continue with install? [Y/n]'
		READ_K yn
		[[ $yn =~ ^[nN] ]] && ERROR=1; true
	} || {
		WARNING 'detected errors; double check warnings before proceeding!'
		USER_PROMPT 'continue with install? [y/N]'
		READ_K yn
		[[ $yn =~ ^[yY] ]] && ERROR=0
	}

	return $ERROR
}

function OS_INSTALL__ARCH() {
	local TARGET="$1"
	CHECK "checking for $TARGET"
	pacman -Qq | grep -q "^$TARGET$" && OK || {
		WARN "$TARGET not found"
		CHECK "installing $TARGET"
		sudo pacman -Syu --noconfirm $TARGET >>$LOG 2>&1 \
			&& OK || { WARN "failed to install $TARGET"; return 1; }
	}
}

function OS_INSTALL__DEBIAN() {
	local TARGET="$1"
	CHECK "checking / installing $PACKAGE"
	sudo apt-get install --yes $PACKAGE >>$LOG 2>&1 \
		&& OK || { WARN "failed to install $TARGET"; return 1; }
}

function OS_INSTALL__GENERIC() {
	local COMMAND="$1"
	CHECK "checking for $COMMAND"
	command -v $COMMAND >/dev/null 2>&1 \
		&& OK || { WARN; return 1; }
}
