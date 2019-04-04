" -- Vundle Config --
source ~/.vim/.vimrc-vundle

" -- Plugin Config --
source ~/.vim/.vimrc-myPlugins

" -- Smart, Single-line Indentation --
	set breakindent
	set breakindentopt=shift:3
	" prevents the breaking up of words
	set formatoptions=l
	set lbr

" -- Colorscheme Configuration --
	let &t_Co=256
	colorscheme tigrana-256-dark

" -- General --
	set number
	syntax on
	set autoindent
	set smartindent
	set spelllang=en
	set spellfile=$HOME/en.utf-8.add

" -- quick run macro recorded to q:
	:nnoremap <Space> @q

" -- execute current line as shell command
	:noremap Q !!$SHELL<CR>
	:vnoremap Q !$SHELL<CR>
