if !isdirectory(expand("$HOME/.vim/bundle/Vundle.vim")) | let g:plugins_ok = 0 | finish | endif
" -------------------------------------------------------------------

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
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
