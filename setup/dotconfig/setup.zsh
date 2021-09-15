DOTCONFIG__SETUP() {
	############################################################################################
	#               Friendly Name   ~/.config/THE_REST      .wryn/config/THE_REST (if different)
	CONFIG__SYMLINK 'compton'       'compton/compton.conf'
	CONFIG__SYMLINK 'git config'    '../.gitconfig'         'git/gitconfig'
	CONFIG__SYMLINK 'i3 config'     'i3/config'
	CONFIG__SYMLINK 'i3 status'     'i3status/config'
	CONFIG__SYMLINK 'i3 utils'      'wryn/i3utils'          'i3/utils'
	CONFIG__SYMLINK 'kitty config'  'kitty/kitty.conf'
	CONFIG__SYMLINK 'kitty theme'   'kitty/theme.conf'
	CONFIG__SYMLINK 'mssqlcli'      'mssqlcli/config'
	CONFIG__SYMLINK 'pgcli'         'pgcli/config'
	CONFIG__SYMLINK 'pylint global' 'pylintrc'              'pylint/pylintrc'
	CONFIG__SYMLINK 'ripgrep'       'ripgrep/config'
	CONFIG__SYMLINK 'sfx app'       "wryn/sfx"              '../bin/desktop/sfx/play.sh'
	CONFIG__SYMLINK 'tmux'          '../.tmux.conf'         'tmux/tmux.conf'
	CONFIG__SYMLINK 'xinitrc'       '../.xinitrc'           'xorg/xinitrc'
	############################################################################################

	CONFIG__TERMINFO
}

function CONFIG__SYMLINK() {
	local CONFIG_NAME="$1"

	local TARGET="$2"
	local LOCAL_CONFIG="$HOME/.config/$TARGET"

	# don't use third argument if config layout is identical
	[ $3 ] && TARGET="$3"
	local DOTWRYN_CONFIG="$DOTWRYN_PATH/config/$TARGET"

	CHECK "linking $1"
	{
		mv "$LOCAL_CONFIG" "$LOCAL_CONFIG.bak"
		ln -s "$DOTWRYN_CONFIG" "$LOCAL_CONFIG" 
	} >>$LOG 2>&1 && OK || WARN
}

function CONFIG__TERMINFO() {
	for file in $(find "$DOTWRYN_PATH/config/terminfo" -type f); do
		CHECK "adding '$file' terminfo"
		tic -x $file >>$LOG 2>&1 \
			&& OK || WARN
	done
}
