YAY__SOURCE_TARGET='https://aur.archlinux.org/yay.git'
YAY__LOCAL_PATH="$HOME/.packages/yay"

YAY__INSTALL_FROM_SOURCE() {
	CHECK 'verifying yay install'
	[ -d $YAY__LOCAL_PATH ] \
		&& { OK; return 0; } || WARN

	CHECK 'downloading yay'
	git clone $ARCH__YAY_TARGET $YAY__LOCAL_PATH >>$LOG 2>&1\
		&& OK || { WARN; return 1; }

	cd $YAY__LOCAL_PATH
	CHECK 'installing yay'
	yes | makepkg -si >>$LOG 2>&1 \
		&& OK || { WARN; return 1; }
}
