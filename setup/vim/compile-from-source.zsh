VIM__SOURCE_TARGET='https://github.com/vim/vim.git'
VIM__LOCAL_PATH="$HOME/.packages/vim"

function VIM__COMPILE_FROM_SOURCE() {
	STATUS 'setting up vim'
	[ -d $VIM__LOCAL_PATH ] && {
		USER_PROMPT 'vim already compiled; update? [y/N]'
		READ_K yn
		[[ $yn =~ [^yY] ]] && return 0
		cd $VIM__LOCAL_PATH

		CHECK 'updating vim to latest'
		git pull >>$LOG 2>&1 \
			&& OK || { WARN 'unable to update vim'; return 1; }
	} || {
		CHECK 'getting vim source'
		git clone $VIM__SOURCE_TARGET $VIM__LOCAL_PATH >>$LOG 2>&1 \
			&& OK || { WARN 'unable to download vim'; return 1; }
	}	
	cd $VIM__LOCAL_PATH

	CHECK 'configuring vim'
	./configure \
		--with-features=huge \
		--enable-cscope \
		--enable-gtk2-check \
		--enable-gtk3-check \
		--enable-gui=auto \
		--enable-luainterp=yes \
		--enable-perlinterp=yes \
		--enable-python3interp=yes \
		--enable-rubyinterp=yes \
		--enable-terminal \
		>>$LOG 2>&1 && OK || { WARN; return 1; }

	CHECK 'building vim'
	sudo make >>$LOG 2>&1 && OK || { WARN; return 1; }

	CHECK 'installing vim'
	sudo make install >>$LOG 2>&1 && OK || WARN
}
