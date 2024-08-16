if !empty(glob(expand("$HOME/.vim/bundle")))
	let $VIM_PLUGIN_DIR=expand("$HOME/.vim/bundle")
elseif !empty(expand("$XDG_CONFIG_HOME"))
	let $VIM_PLUGIN_DIR=expand("$XDG_CONFIG_HOME/vim/bundle")
else
	let $VIM_PLUGIN_DIR=expand("$HOME/.config/vim/bundle")
endif

if !isdirectory(expand("$VIM_PLUGIN_DIR/Vundle.vim")) | let g:plugins_ok = 0 | finish | endif
" -------------------------------------------------------------------

set nocompatible
filetype off
set rtp+=$VIM_PLUGIN_DIR/Vundle.vim

call vundle#begin("$VIM_PLUGIN_DIR")
	Plugin 'VundleVim/Vundle.vim'      " 00.plugin-vundle.vim
	Plugin 'valloric/youcompleteme'    " 01.plugin-youcompleteme.vim
	Plugin 'w0rp/ale'                  " 02.plugin-ale.vim
	Plugin 'scrooloose/nerdtree'       " 03.plugin-nerdtree.vim
	Plugin 'tpope/vim-surround'        " 04.plugin-vim-surround.vim
	Plugin 'tpope/vim-fugitive'        " 05.plugin-vim-fugitive.vim
	Plugin 'jeffkreeftmeijer/vim-dim'  " 07.plugin-vim-dim.vim
	Plugin 'chrisbra/unicode.vim'      " 08.plugin-unicode.vim
	Plugin 'rrethy/vim-hexokinase'     " 09.plugin-vim-hexokinase.vim
	Plugin 'fatih/vim-go'              " 10.plugin-vim-go.vim
	Plugin 'rust-lang/rust.vim'        " 11.plugin-rust.vim
" ---------------------------------------------------------------------
call vundle#end()

filetype plugin indent on
let g:plugins_ok = 1
