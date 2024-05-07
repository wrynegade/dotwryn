
function Sudowrite()
	execute 'w !sudo tee "%"'
endfunction

nnoremap <Leader><Leader>w  :call Sudowrite()<CR>

function MakeFileExecutable(sudo = 0)
	if a:sudo
		execute '! sudo chmod +x "%"'
	else
		execute '! chmod +x "%"'
	endif
endfunction

nnoremap <Leader><Leader>x  :call MakeFileExecutable(0)<CR>
nnoremap <Leader><Leader>xx :call MakeFileExecutable(1)<CR>
