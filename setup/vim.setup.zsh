function SETUP__VIM() {
	STATUS 'starting vim setup'
	"$DOTWRYN_PATH/bin/vim/compile"
	VIM__SOURCE_RC
	"$DOTWRYN_PATH/bin/vim/install-plugins"
	VIM__CREATE_PANE_DEFAULT_APP
	STATUS 'finished vim setup'
}

#####################################################################

function VIM__SOURCE_RC() {
	local LOCAL_VIMRC="$HOME/.vimrc";
	local SOURCE_LINE="source $DOTWRYN_PATH/vim/rc.vim";

	grep -q "^$SOURCE_LINE$" $LOCAL_VIMRC && {
		STATUS 'already set up vimrc'
	} || {
		CHECK 'setting up vimrc'
		echo $SOURCE_LINE >> $LOCAL_VIMRC \
			&& OK || WARN
	}
}

function VIM__CREATE_PANE_DEFAULT_APP() {
	which vim | grep "$HOME/.local/bin/vim" && return 0

	CHECK 'updating vim to open in panes by default'
	{
		echo '#!/bin/sh'
		echo "exec $(which vim) -p "'"$@"'
	} > "$HOME/.local/bin/vim" && OK || WARN
	chmod +x "$HOME/.local/bin/vim"
}
