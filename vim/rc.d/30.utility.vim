function EnsureTmuxSession()
	call system("tmux new -ds " . g:escapeTmuxSession . " -c $HOME >/dev/null 2>&1")
endfunction

function FindGitRoot()
	return finddir('.git/..', expand('%:p:h').';')
endfunction
