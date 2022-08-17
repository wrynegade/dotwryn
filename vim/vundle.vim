set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
" --- installed plugins -----------------------------------------------
" {{{
	Plugin 'fatih/vim-go'
	Plugin 'jeffkreeftmeijer/vim-dim'
	Plugin 'rrethy/vim-hexokinase'
	Plugin 'scrooloose/nerdtree'
	Plugin 'tpope/vim-fugitive'
	Plugin 'tpope/vim-surround'
	Plugin 'valloric/youcompleteme'
	Plugin 'w0rp/ale'
" }}}
" ---------------------------------------------------------------------
call vundle#end()
filetype plugin indent on

" --- plugin configuration --------------------------------------------
" {{{

" fatih/vim-go
let g:go_imports_autosave = 0
let g:go_def_mapping_enabled = 0
let g:go_fmt_fail_silently = 1
let g:go_def_reuse_buffer = 1
let g:go_textobj_enabled = 0


" rrethy/vim-hexokinase
let g:Hexokinase_highlighters = ['foregroundfull']

" scrooloose/nerdtree
nnoremap <C-o> :NERDTreeToggle %<CR>
let g:NERDTreeNodeDelimiter = "\u00a0" " -- fixes ^G character


" Valloric/YouCompleteMe
function! ToggleYCM()
	if g:ycm_auto_trigger
		let g:ycm_auto_trigger = 0
		echohl DiffDelete | echo "YouCompleteMe autocompletion disabled" | echohl None
	else
		let g:ycm_auto_trigger = 1
		echohl DiffAdd | echo "YouCompleteMe autocompletion enabled" | echohl None
	endif
endfunction

let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_goto_buffer_command = 'new-tab'

nnoremap <S-y> :call ToggleYCM()<CR>
nnoremap gd :YcmCompleter GoToDefinition<CR>


" w0ryn/ale
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

" }}}
" ---------------------------------------------------------------------
