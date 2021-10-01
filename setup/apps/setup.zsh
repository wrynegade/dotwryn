APPS__PACKAGE_DIR="$HOME/.packages"

function SETUP__APPS() {
	STATUS 'starting application source-build installs'

	APPS__SIMPLE_INSTALL 'https://github.com/tiyn/dmenu' 'patched-dmenu'
}


function APPS__SIMPLE_INSTALL() {
	[ ! -d $APPS__PACKAGE_DIR ] && mkdir $APPS__PACKAGE_DIR

	local TARGET="$1"
	local NAME="$2"
	local LOCAL_BUILD="$APPS_PACKAGE_DIR/$NAME"

	CHECK "Downloading $NAME"
	git clone $TARGET $LOCAL_BUILD >>$LOG 2>&1 \
		&& { OK; cd $LOCAL_BUILD; } || { WARN; return 1; }

	CHECK "Building $NAME"
	make clean >>$LOG 2>&1 \
		&& OK || { WARN; return 2; }

	CHECK "Installing $NAME"
	sudo make install >>$LOG 2>&1 \
		&& OK || { WARN; return 3; }
}
