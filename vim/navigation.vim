
" (shift + direction) for tabs
nnoremap <S-l> gt
nnoremap <S-h> gT
nnoremap <S-t> <C-w>T

" (ctrl + direction) for panes
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
tnoremap <C-l> <C-w>l
tnoremap <C-h> <C-w>h
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k

" (ctrl + n/p) for buffers
nnoremap <C-n> :n<CR>
nnoremap <C-p> :N<CR>

" flip (gf) / (ctrl+w gf) bindings
nnoremap <C-w>gf gf
vnoremap <C-w>gf gf
nnoremap gf <C-w>gf
vnoremap gf <C-w>gf
