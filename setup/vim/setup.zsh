#####################################################################

function VIM__SETUP() {
	VIM__SOURCE_RC
	VIM__SET_LOCAL_CONFIG
	VIM__UPDATE_COLORSCHEMES
	VIM__INSTALL_VUNDLE_PLUGINS
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

function VIM__SET_LOCAL_CONFIG() {
	local DEFAULT_CONFIG="$DOTWRYN_PATH/env/env.vim"
	local LOCAL_CONFIG="$HOME/.config/wryn/env/env.vim"

	[ -f $LOCAL_CONFIG ] && {
		WARNING "local vim env configuration ($LOCAL_CONFIG)"
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

	CHECK "setting vim configuration file ($LOCAL_CONFIG)"
	{
		echo "source $DEFAULT_CONFIG"
		echo -e '\n"\n" .wryn configuration overrides\n"\n'
		sed 's/["]*\(.*\)/"\1/' $DEFAULT_CONFIG
	} > $LOCAL_CONFIG && OK || WARN
}

function VIM__UPDATE_COLORSCHEMES() {
	CHECK 'updating colorschemes'
	$DOTWRYN_PATH/bin/vim/update_colorschemes >>$LOG 2>&1\
		&& OK || WARN
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

	CHECK 'installing vundle plugins'
	vim +PluginInstall +qall \
		&& OK || WARN

	STATUS 'building plugins'
	$DOTWRYN_PATH/bin/vim/rebuild_plugins
}
