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
	Plugin 'https://github.com/scrooloose/nerdtree.git'

" go-vim
	Plugin 'fatih/vim-go'

" youCompleteMe
	Plugin 'https://github.com/Valloric/YouCompleteMe.git'

" omnisharp (c#)
	Plugin 'OmniSharp/omnisharp-vim'

" ale -- asynchronus error checking
 	Plugin 'https://github.com/w0rp/ale'

" <======================================================>
" <======================================================>
call vundle#end()
filetype plugin indent on
" To ignore plugin indent changes, instead use:
" filetype plugin on

" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

" see :h vundle for more details or wiki for FAQ


" ===================================================================================
" === PLUGIN-SPECIFIC SETTINGS ======================================================
" ===================================================================================

" --- Nerd Tree ---------------------------------------------------------------------
nnoremap <C-o> :NERDTreeToggle %<CR>
let g:NERDTreeNodeDelimiter = "\u00a0" " -- Was seeing ^G character, and this should fix that


" --- YouCompleteMe -----------------------------------------------------------------
function! ToggleYCM()
	if g:ycm_auto_trigger
		let g:ycm_auto_trigger = 0
		echohl DiffDelete | echo "YouCompleteMe autocompletion disabled" | echohl None
	else
		let g:ycm_auto_trigger = 1
		echohl DiffAdd | echo "YouCompleteMe autocompletion enabled" | echohl None
	endif
endfunction

" uncomment to deactivate by default
" let g:ycm_auto_trigger=0
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_goto_buffer_command = 'new-tab'

nnoremap <S-y> :call ToggleYCM()<CR>
nnoremap gd :YcmCompleter GoToDefinition<CR>


" --- ALE ---------------------------------------------------------------------------
let g:ale_linters = {
\ 'cs' : ['OmniSharp'],
\ 'python' : ['pylint'],
\ 'go' : ['golint']
\}
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_save = 1
let g:ale_sign_column_always = 1

nmap <Leader>ae <Plug>(ale_next)
nmap <Leader>ar <Plug>(ale_previous)

" --- vim-go ------------------------------------------------------------------------
let g:go_imports_autosave = 0
let g:go_def_mapping_enabled = 0
let g:go_fmt_fail_silently = 1
let g:go_def_reuse_buffer = 1
let g:go_textobj_enabled = 0
