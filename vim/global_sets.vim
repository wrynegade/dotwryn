set linebreak " automatically wraps text
set breakindent " indent for single-line wrap
set breakindentopt=shift:3 " indent amount for single-line wrap

set formatoptions=lj
" l = prevents the breaking up of words
" j = remove comment leaders when joining lines

let &t_co=256 " use 256-color

set number " show line numbers
set relativenumber

set autoindent " match indentation with next line
set smartindent " match indentation with syntax

set spellfile=$VIM_DIR/en.utf-8.add
set spelllang=en

set showmatch   " -- emit 'beep' when no matching symbol,
set matchtime=0 " -- but don't jump to it.

set timeoutlen=200 " -- short timeout for multi-key functions
