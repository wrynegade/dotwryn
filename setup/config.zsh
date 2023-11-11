function SETUP__CONFIG() {
	STATUS 'starting application configuration'

	SCWRYPTS system/config/update || return 1

	CONFIG__ZSH || return 2
	CONFIG__VIM || return 3

	SUCCESS 'finished application configuration'
}

#####################################################################

CONFIG__ZSH() {
	CONFIG__ENV zsh || return 1
	CONFIG__RC  zsh || return 2
	CONFIG__SET_DEFAULT_SHELL || return 3
}

CONFIG__SET_DEFAULT_SHELL() {
	local DEFAULT_SHELL=$(awk -F: -v user="$USER" '$1 == user {print $NF}' /etc/passwd)
	[[ $DEFAULT_SHELL =~ zsh ]] && return 0

	[ $FORCE_ROOT ] && return 0

	STATUS 'setting zsh as default shell'
	sudo chsh -s $(which zsh) $(whoami) 2>&1 \
		&& SUCCESS "set zsh as default shell for '$USER'" \
		|| FAIL 1 'failed to set zsh as default shell' \
		;
}

#####################################################################

CONFIG__VIM() {
	CONFIG__ENV vim || return 1
	CONFIG__RC  vim || return 2

	[ $COMPILE_VIM ] && [[ $COMPILE_VIM -eq 1 ]] && return 0

	STATUS 'starting vim setup'
	"$DOTWRYN_PATH/vim/update" \
		&& SUCCESS 'completed vim setup' \
		|| FAIL 1 'error detected in vim setup (see above)' \
		;
}

#####################################################################

CONFIG__ENV() {
	local DEFAULT_CONFIG="$DOTWRYN_PATH/config/dotwryn.env.$1"
	local LOCAL_CONFIG="$HOME/.config/wryn/env.$1"

	[ -f $LOCAL_CONFIG ] && {
		WARNING "local $1 configuration exists ($LOCAL_CONFIG)"
		yN 'overwrite this configuration?' || return 0

		mv "$LOCAL_CONFIG" "$LOCAL_CONFIG.bak" >/dev/null 2>&1 \
			&& INFO "created backup of local configuration ($LOCAL_CONFIG.bak)"
	}

	STATUS "setting up $1 configuration ($LOCAL_CONFIG)"

	case $1 in
		vim ) COMMENT='"' ;;
		zsh ) COMMENT='#' ;;
	esac

	{
		echo "source $DEFAULT_CONFIG"
		echo -e "\\n$COMMENT\n$COMMENT .wryn configuration overrides\n$COMMENT\n"
		sed "s/^[^$COMMENT].*/$COMMENT&/" $DEFAULT_CONFIG
	} > $LOCAL_CONFIG \
		&& SUCCESS "created $1 configuration" \
		|| FAIL 1 "unable to create $1 configuration" \
		;

	EDIT "$LOCAL_CONFIG"
}


CONFIG__RC() {
	local TYPE="$1"
	local RC="$HOME/.${TYPE}rc";

	local SOURCE_LINE
	case $TYPE in
		zsh ) SOURCE_LINE="source $DOTWRYN_PATH/zsh/rc" ;;
		vim ) SOURCE_LINE="source $DOTWRYN_PATH/vim/rc.vim" ;;
	esac

	grep -q "^$SOURCE_LINE$" "$RC" \
		|| echo "$SOURCE_LINE" >> $RC

	grep -q "^$SOURCE_LINE$" "$RC" \
		&& SUCCESS "${TYPE}rc is configured correctly" \
		|| FAIL 1 "failed to configure ${TYPE}rc" \
		;
}

