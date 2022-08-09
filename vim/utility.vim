function Sudowrite()
	execute 'w !sudo tee "%"'
endfunction

function MakeFileExecutable(sudo = 0)
	if a:sudo
		execute '! sudo chmod +x "%"'
	else
		execute '! chmod +x "%"'
	endif
endfunction
