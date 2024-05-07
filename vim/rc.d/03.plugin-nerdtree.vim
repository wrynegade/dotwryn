if g:plugins_ok != 1 | finish | endif
" -------------------------------------------------------------------

nnoremap <C-o> :NERDTreeToggle %<CR>
let g:NERDTreeNodeDelimiter = "\u00a0" " -- fixes ^G character
