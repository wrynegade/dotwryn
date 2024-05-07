" backslash for Leader and backspace for LocalLeader
nmap <BS> <Nop>
let mapleader = "\\"
let maplocalleader = "\<BS>"

" (e)dit / (s)ource (v)imrc
nnoremap <Leader>ev :tabedit $VIMRC<CR>
nnoremap <Leader>sv :source $VIMRC<CR>
