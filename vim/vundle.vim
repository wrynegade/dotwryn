set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" <======================================================>
" <==== Insert plugins here =============================>
" command-t (
"	Plugin 'git://git.wincent.com/command-t.git'
" tpope/surround
	Plugin 'tpope/vim-surround'
" nerdtree
	Plugin 'git://github.com/scrooloose/nerdtree.git'
" youCompleteMe
	Plugin 'git://github.com/Valloric/YouCompleteMe.git'
" leafgarland -- typescript recognition
"	Plugin 'https://github.com/leafgarland/typescript-vim'
" omnisharp (c#)
	Plugin 'OmniSharp/omnisharp-vim'
" ale -- asynchronus error checking
 	Plugin 'https://github.com/w0rp/ale'

" example for local command:
"	Plugin 'file:///home/gmarik/path/to/plugin'
" <======================================================>
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" ===================================================================================
" === MY PLUGIN SETTINGS ============================================================
" ===================================================================================

" --- Nerd Tree ---
map <C-o> :NERDTreeToggle<CR>
let g:NERDTreeNodeDelimiter = "\u00a0" " -- Was seeing ^G character, and this should fix that

" --- YouCompleteMe (YCM) ---
function! ToggleYCM()
	if g:ycm_auto_trigger
		let g:ycm_auto_trigger = 0
		echohl DiffDelete | echo "YouCompleteMe autocompletion disabled" | echohl None
	else
		let g:ycm_auto_trigger = 1
		echohl DiffAdd | echo "YouCompleteMe autocompletion enabled" | echohl None
	endif
endfunction
nnoremap <C-p> :call ToggleYCM()<CR>
" STARTS DEACTIVATED
" let g:ycm_auto_trigger=0

" --- ALE ---
let g:ale_linters = {
\ 'cs' : ['OmniSharp'],
\ 'python' : ['pylint']
\}
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 'never'

nnoremap <Leader>ae :ALENext<cr>
nnoremap <Leader>ar :ALEPrevious<cr>

" --- command t ---
nnoremap T :CommandT<cr>
