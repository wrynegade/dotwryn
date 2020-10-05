" ===================================================================================
" === VUNDLE SETTINGS ===============================================================
" ===================================================================================
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" <======================================================>
" <==== Insert plugins here =============================>

" tpope/surround
	Plugin 'tpope/vim-surround'
" nerdtree
	Plugin 'git://github.com/scrooloose/nerdtree.git'
" youCompleteMe
	Plugin 'git://github.com/Valloric/YouCompleteMe.git'
" omnisharp (c#)
	Plugin 'OmniSharp/omnisharp-vim'
" ale -- asynchronus error checking
 	Plugin 'https://github.com/w0rp/ale'

" <======================================================>
call vundle#end()
filetype plugin indent on
" To ignore plugin indent changes, instead use:
" filetype plugin on

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

" see :h vundle for more details or wiki for FAQ

" ===================================================================================
" === PLUGIN-SPECIFIC SETTINGS ======================================================
" ===================================================================================

" --- Nerd Tree ---
map <C-o> :NERDTreeToggle %<CR>
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

let g:ycm_goto_buffer_command = 'new-tab'

nnoremap <C-p> :call ToggleYCM()<CR>
nnoremap gd :YcmCompleter GoToDefinition<CR>
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
