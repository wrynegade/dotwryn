
" (SHIFT + DIRECTION) for tabs 
nnoremap <S-l> gt
nnoremap <S-h> gT
nnoremap <S-t> <C-w>T

" (CTRL + DIRECTION)  for panes
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

" (CTRL + n/p) for files
nnoremap <C-n> :n<CR>
nnoremap <C-p> :N<CR>


" (<LEADER> + e + RC_PREFIX) for edit rc
nnoremap <Leader>ev :sp $WRYNVIMRC<CR>
nnoremap <Leader>sv :source $MYVIMRC<CR>
nnoremap <Leader>eb :sp $BASHRC<CR>
nnoremap <Leader>ez :sp $ZSHRC<CR>
