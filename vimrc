" -- Environment Variables --------------------------------------- {{{
let $RC_DIR="/Users/w0ryn/.wryn"
let $WRYNVIMRC="$RC_DIR/vimrc"
let $WRYNBASH="$RC_DIR/bashrc"
let $MYBASHRC="/Users/w0ryn/.bashrc"
" }}}

" -- General Settings -------------------------------------------- {{{
set linebreak " automatically wraps text
set breakindent " indent for single-line wrap
set breakindentopt=shift:3 " indent amount for single-line wrap

set formatoptions=lj
" l = prevents the breaking up of words
" j = remove comment leaders when joining lines

let &t_co=256 " use 256-color

set number " show line numbers
syntax on " detect syntax
set autoindent " match indentation with next line
set smartindent " match indentation with syntax

set spellfile=$RC_DIR/en.utf-8.add
set spelllang=en

set showmatch   " -- emit 'beep' when no matching symbol,
set matchtime=0 " -- but don't jump to it.

set timeoutlen=200 " -- short timeout for multi-key functions
" }}}

" -- File Formatting ------------------------------------- {{{
augroup filetype_specific_formatting
	autocmd!
	autocmd FileType python     setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab foldmethod=indent foldlevel=99
	autocmd FileType java       setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab foldmethod=indent foldlevel=99
	autocmd FileType cs         setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab foldmethod=indent foldlevel=99
	autocmd FileType html       setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab foldmethod=indent foldlevel=99
	autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab foldmethod=indent foldlevel=99
	autocmd FileType vim        setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab foldmethod=marker foldlevel=1
augroup END
" }}}

" -- Key bindings ---------------------------------------- {{{
let mapleader = "\\"
"let localmapleader = ','

" -- VIMRC ------------------------------------------- {{{
nnoremap <Leader>ev :vsp $WRYNVIMRC<CR>
nnoremap <Leader>sv :source $MYVIMRC<CR>
nnoremap <Leader>eb :vsp $MYBASHRC<CR>
nnoremap <Leader>emb :vsp $WRYNBASH<CR>
" }}}

" -- Abbreviation Dictionary ------------------------- {{{
iabbrev @@ wagner.wryn@gmail.com
iabbrev ssig <CR>-----------------------<CR>Wryn Wagner<CR>wagner.wryn@gmail.com<CR>(720)557-5443<CR>-----------------------

iabbrev psvm public static void main(String[] args) {<CR>}
" }}}

" -- Pane/Window Navigation -------------------------- {{{
" (SHIFT + DIRECTION) for tabs 
nnoremap <S-l> gt
nnoremap <S-h> gT
" (CTRL + DIRECTION)  for panes
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
" }}}

" <SPACE> to execute macro on q
nnoremap <Space> @q

" Q to replace current line/selection with bash execution
vnoremap Q !$SHELL<CR>
nnoremap Q !!$SHELL<CR>

" \q for `q:`
nnoremap <Leader>q q:

" \f for fold
nnoremap <Leader>f z
nnoremap <Leader>f z

" append current line to the line below
nnoremap <Leader>j ddpkJ

" - to move the current line one below where it is
nnoremap - :m +1 <CR> 
nnoremap _ :m -2 <CR>

" - (insert mode) set current word to upper-case
inoremap <c-u> <esc>viwUea

" }}}


