function SETUP__CONFIG() {
	############################################################################################
	#               Friendly Name   ~/.config/THE_REST      .wryn/config/THE_REST (if different)
	CONFIG__SYMLINK 'compton'       'compton/compton.conf'
	CONFIG__SYMLINK 'i3 config'     'i3/config'
	CONFIG__SYMLINK 'i3 status'     'i3status/config'
	CONFIG__SYMLINK 'kitty config'  'kitty/kitty.conf'
	CONFIG__SYMLINK 'kitty theme'   'kitty/theme.conf'
	CONFIG__SYMLINK 'mssqlcli'      'mssqlcli/config'
	CONFIG__SYMLINK 'pgcli'         'pgcli/config'
	CONFIG__SYMLINK 'ripgrep'       'ripgrep/config'

	CONFIG__SYMLINK 'git config'    '../.gitconfig'         'git/gitconfig'
	CONFIG__SYMLINK 'i3 utils'      'wryn/i3utils'          'i3/utils'
	CONFIG__SYMLINK 'pylint global' 'pylintrc'              'pylint/pylintrc'
	CONFIG__SYMLINK 'sfx app'       "wryn/sfx"              '../bin/desktop/sfx/play.sh'
	CONFIG__SYMLINK 'tmux'          '../.tmux.conf'         'tmux/tmux.conf'
	CONFIG__SYMLINK 'xinitrc'       '../.xinitrc'           'xorg/xinitrc'
	############################################################################################

	CONFIG__TERMINFO

	CONFIG__RC 'zsh'
	CONFIG__RC 'vim'
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
		CHECK "adding $(basename $file)"
		tic -x $file >>$LOG 2>&1 \
			&& OK || WARN
	done
}

function CONFIG__RC() {
	local DEFAULT_CONFIG="$DOTWRYN_PATH/env/env.$1"
	local LOCAL_CONFIG="$HOME/.config/wryn/env/env.$1"

	[ -f $LOCAL_CONFIG ] && {
		WARNING "local $1 configuration exists ($LOCAL_CONFIG)"
		USER_PROMPT 'overwrite? [y/N]'
		READ_K yn
		[[ $yn =~ ^[yY] ]] && {
			CHECK "backing up local copy ($LOCAL_CONFIG.bak)"
			mv "$LOCAL_CONFIG" "$LOCAL_CONFIG.bak" && OK || WARN
		} || {
			STATUS 'skipping'
			return
		}
	}

	CHECK "setting up $1 configuration ($LOCAL_CONFIG)"

	case $1 in
		vim ) COMMENT='"' ;;
		zsh ) COMMENT='#' ;;
	esac

	{
		echo "source $DEFAULT_CONFIG"
		echo -e "\\n$COMMENT\n$COMMENT .wryn configuration overrides\n$COMMENT\n"
		sed "s/^[^$COMMENT].*/$COMMENT&/" $DEFAULT_CONFIG
	} > $LOCAL_CONFIG && OK || WARN

	USER_PROMPT 'change local configuration options? [y/N]'
	READ_K yn

	[[ $yn =~ ^[yY] ]] && {
		[ ! $EDITOR ] && EDITOR=vi
		$EDITOR "$HOME/.config/wryn/env/env.$1"
	}
}
