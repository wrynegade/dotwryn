" -- Settings --------------------------------------------
set lbr " automatically wraps text
set formatoptions=l " prevents the breaking up of words
set breakindent " indent for single-line wrap
set breakindentopt=shift:3 " indent amout for single-line wrap

let &t_Co=256 " use 256-color

set number " show line numbers
syntax on " detect syntax
set autoindent " match indentation with next line
set smartindent " match indentation with syntax

set spelllang=en " spell check language is english
set spellfile=$RC_DIR/en.utf-8.add " spell file


" -- Key bindings ----------------------------------------

" <SPACE> to execute macro on q
:nnoremap <Space> @q

" Q to replace current line/selection with bash execution
:noremap Q !!$SHELL<CR>
:vnoremap Q !$SHELL<CR>
