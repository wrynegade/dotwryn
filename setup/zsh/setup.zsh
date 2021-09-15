#####################################################################

function ZSH__SETUP() {
    ZSH__SET_DEFAULT_SHELL
	ZSH__SOURCE_RC
	ZSH__SET_LOCAL_CONFIG
}

#####################################################################

function ZSH__SET_DEFAULT_SHELL() {
    local DEFAULT_SHELL=$(awk -F: -v user="$USER" '$1 == user {print $NF}' /etc/passwd)
    CHECK 'setting zsh as default shell'
    sudo chsh -s $(which zsh) $(whoami)>>$LOG 2>&1 \
		&& OK || WARN 'failed to set zsh as default shell'
}

function ZSH__SOURCE_RC() {
	local LOCAL_ZSHRC="$HOME/.zshrc";
	local SOURCE_LINE="source $DOTWRYN_PATH/zsh/rc";

	grep -q "^$SOURCE_LINE$" $LOCAL_ZSHRC && {
		STATUS 'already set up zshrc'
	} || {
		CHECK 'setting up zshrc'
		echo $SOURCE_LINE >> $LOCAL_ZSHRC \
			&& OK || WARN
	}
}

function ZSH__SET_LOCAL_CONFIG() {
	local DEFAULT_CONFIG="$DOTWRYN_PATH/env/env.zsh"
	local LOCAL_CONFIG="$HOME/.config/wryn/env/env.zsh"

	[ -f $LOCAL_CONFIG ] && {
		WARNING "local zsh env configuration ($LOCAL_CONFIG)"
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

	CHECK "setting zsh configuration file ($LOCAL_CONFIG)"
	{
		echo "source $DEFAULT_CONFIG"
		echo -e '\n#\n# .wryn configuration overrides\n#\n'
		sed 's/[#]*\(.*\)/#\1/' $DEFAULT_CONFIG
	} > $LOCAL_CONFIG && OK || WARN
}
