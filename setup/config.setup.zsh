function SETUP__CONFIG() {
	############################################################################################
	#               ~/.config/THE_REST                .wryn/config/THE_REST
	CONFIG__SYMLINK '../.XCompose'                    'xcompose.conf'
	CONFIG__SYMLINK '../.XConfig'                     'xconfig.conf'
	CONFIG__SYMLINK '../.tmux.conf'                   'tmux.conf'
	CONFIG__SYMLINK '../.xinitrc'                     'xinitrc'
	CONFIG__SYMLINK 'bat/config'                      'bat.conf'
	CONFIG__SYMLINK 'code-activator-zsh/settings.zsh' 'code-activator.conf'
	CONFIG__SYMLINK 'compton/compton.conf'            'compton.conf'
	CONFIG__SYMLINK 'git/config'                      'git.conf'
	CONFIG__SYMLINK 'i3/config'                       'i3.conf'
	CONFIG__SYMLINK 'i3/utils'                        '../bin/i3/utils'
	CONFIG__SYMLINK 'i3status/config'                 'i3status.conf'
	CONFIG__SYMLINK 'kitty/kitty.conf'                'kitty.conf'
	CONFIG__SYMLINK 'kitty/theme.conf'                '../colorschemes/kitty.main'
	CONFIG__SYMLINK 'mssqlcli/config'                 'mssqlcli.conf'
	CONFIG__SYMLINK 'pgcli/config'                    'pgcli.conf'
	CONFIG__SYMLINK 'pylintrc'                        'pylint.conf'
	CONFIG__SYMLINK 'ripgrep/config'                  'ripgrep.conf'
	############################################################################################

	CONFIG__TERMINFO

	CONFIG__RC 'zsh'
	CONFIG__RC 'vim'
}

function CONFIG__SYMLINK() {
	local LOCAL_CONFIG="$HOME/.config/$1"
	local DOTWRYN_CONFIG="$DOTWRYN_PATH/config/$2"
	local FRIENDLY_NAME=$(echo $2 | sed 's/\.conf$//')

	CHECK "linking $FRIENDLY_NAME"
	{
		[ ! -d $(dirname $LOCAL_CONFIG) ] && mkdir -p $(dirname $LOCAL_CONFIG)
		mv "$LOCAL_CONFIG" "$LOCAL_CONFIG.bak"
		ln -s "$DOTWRYN_CONFIG" "$LOCAL_CONFIG"
	} >>$LOG 2>&1 && OK || WARN
}

function CONFIG__TERMINFO() {
	for file in $(find "$DOTWRYN_PATH/setup/terminfo" -type f); do
		CHECK "adding $(basename $file)"
		tic -x $file >>$LOG 2>&1 \
			&& OK || WARN
	done
}

function CONFIG__RC() {
	local DEFAULT_CONFIG="$DOTWRYN_PATH/setup/env/env.$1"
	local LOCAL_CONFIG="$HOME/.config/wryn/env.$1"

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
		$EDITOR "$HOME/.config/wryn/env.$1"
	}
}
