#####################################################################

function SETUP__ZSH() {
    ZSH__SET_DEFAULT_SHELL
	ZSH__SOURCE_RC
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
