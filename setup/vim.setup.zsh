source "$DOTWRYN_PATH/setup/vim.compile.zsh"

#####################################################################

function SETUP__VIM() {
	STATUS 'starting vim setup'
	VIM__COMPILE_FROM_SOURCE
	VIM__SOURCE_RC
	VIM__INSTALL_VUNDLE_PLUGINS
	VIM__CREATE_PANE_DEFAULT_APP
	STATUS 'finished vim setup'
}

VIM__VUNDLE_TARGET='https://github.com/VundleVim/Vundle.vim.git'
VIM__VUNDLE_LOCAL="$HOME/.vim/bundle/Vundle.vim"

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

function VIM__INSTALL_VUNDLE_PLUGINS() {
	[ ! -d "$HOME/.vim/bundle/Vundle.vim" ] && {
		CHECK 'installing Vundle.vim'
		git clone $VIM__VUNDLE_TARGET $VIM__VUNDLE_LOCAL >>$LOG 2>&1 \
			&& OK || { WARN; return 1; }
	} || {
		CHECK 'updating Vundle.vim'
		local PREV_DIR=$(pwd)
		cd $VIM__VUNDLE_LOCAL >>$LOG 2>&1 \
			&& git pull >>$LOG 2>&1 \
			&& OK || WARN 'unable to pull latest Vundle.vim'

		cd $PREV_DIR >>$LOG 2>&1
	}

	STATUS 'installing Vundle.vim plugins'
	vim +PluginInstall +qall \
		&& SUCCESS 'successfully installed Vundle.vim plugins' \
		|| WARN 'failed to install one or more Vundle.vim plugins' \
		;

	CHECK 'building plugins (this may take a minute)'
	$DOTWRYN_PATH/bin/vim/rebuild-plugins >>$LOG 2>&1\
		&& OK || WARN 'retry plugin build manually'
}

function VIM__CREATE_PANE_DEFAULT_APP() {
	which vim | grep "$HOME/.local/bin/vim" && return 0

	CHECK 'updating vim to open in panes by default'
	{
		echo '#!/bin/sh'
		echo "exec $(which vim) -p "'$@'
	} > "$HOME/.local/bin/vim" && OK || WARN
	chmod +x "$HOME/.local/bin/vim"
}
