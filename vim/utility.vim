function Sudowrite()
	execute 'w !sudo tee "%"'
endfunction

nnoremap <Leader><Leader>w :call Sudowrite()<CR><CR>L

function MakeFileExecutable()
	execute '! chmod +x "%"'
endfunction

nnoremap <Leader><Leader>x :call MakeFileExecutable()<CR><CR>L

" (<LEADER> + e + RC_PREFIX) for edit rc
nnoremap <Leader>ev :tabedit $WRYNVIMRC<CR>:NERDTreeToggle<CR>
nnoremap <Leader>sv :source $MYVIMRC<CR>
nnoremap <Leader>ez :tabedit $ZSHRC<CR>
