" set the following environment variables:
" $RC_DIR $VIM_DIR $WRYNVIMRC $BASHRC $ZSHRC $WEBBROWSER
source $HOME/.wryn/env/env.vim

if isdirectory(expand("$HOME/.vim/bundle/Vundle.vim"))
	source $VIM_DIR/vundle.vim
endif

source $VIM_DIR/global_sets.vim
source $VIM_DIR/formatting.vim
source $VIM_DIR/abbreviations.vim
source $VIM_DIR/navigation.vim
source $VIM_DIR/color.vim

let mapleader = "\\"
"let localmapleader = ','

augroup personal_bindings
" {{{

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
	nnoremap - :m +1 <CR> 
	nnoremap _ :m -2 <CR>

	" \t for rerun last 'test' command:
	nnoremap <Leader>t q:?test<CR><CR>

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
augroup end
