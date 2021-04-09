source $HOME/.config/wryn/env/env.vim

if isdirectory(expand("$HOME/.vim/bundle/Vundle.vim"))
	source $WRYNVIMPATH/vundle.vim
endif

source $WRYNVIMPATH/options.vim
source $WRYNVIMPATH/testing.vim
source $WRYNVIMPATH/formatting.vim
source $WRYNVIMPATH/abbreviations.vim
source $WRYNVIMPATH/navigation.vim
source $WRYNVIMPATH/color.vim

" -- Bindings --------------------------------------------------- {{{

" <SPACE> to execute macro on q
nnoremap <Space> @q

" Q to replace current line/selection with bash execution
vnoremap Q !$SHELL<CR>
nnoremap Q !!$SHELL<CR>

" \q for `q:`
nnoremap <Leader>q q:

" \s previous selection command
nnoremap <Leader>s :'<,'>

" \f for fold
nnoremap <Leader>f z
nnoremap <Leader>f z

" \j for J, but append current line to the line below
nnoremap <Leader>j ddpkJ

" move the current line one below where it is
nnoremap - :move +1 <CR>
nnoremap _ :move -2 <CR>

" \t for rerun last 'vimtest' command:
nnoremap <Leader>t q:?vimtest<CR><CR>

" \b for git blame
nnoremap <Leader>b :set termwinsize=15*0<BAR>:execute "terminal git blame -L " .eval(line(".")-5) . ",+10 %"<BAR>:set termwinsize&<CR>

" \d to insert formatted date before/after cursor
nnoremap <Leader>di :let @d = system("date '+%A, %B %-d, %Y'")<CR>i<C-r>d<BS> <esc>
nnoremap <Leader>da :let @d = system("date '+%A, %B %-d, %Y'")<CR>a <C-r>d<BS><esc>

" - toggle casing for current word
inoremap <C-u> <esc>viw~ea

" \c \v to copy/paste from xclip
" @TODO: learn how to freaking compile vim with x11 compatibility so these
"        aren't necessary :)
vnoremap <Leader>c :w !xclip<CR><CR>
nnoremap <Leader>v o<esc>!!xclip -o<CR>
nnoremap <Leader>sc :'<,'>w !xclip<CR><CR>

" ------- available / rarely used bindings -------

" nnoremap <BS>
" nnoremap <C-t>
" nnoremap <C-b>
" nnoremap z
" nnoremap ^

" }}}
