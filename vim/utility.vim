function Sudowrite()
	execute 'w !sudo tee "%"'
endfunction

nnoremap <Leader><Leader>w :call Sudowrite()<CR><CR>L
