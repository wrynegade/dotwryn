"
" escape-to-shell execution wrapper with great functionality
" and an OK-to-bad API (EXTREMELY helpful)
"

let escapeTmuxSession = "vim-exec"
let escapeTmuxPaneID = g:escapeTmuxSession . ":0.0"

let escapeCommandOutputs = ['tmux', 'split-pane-vertical', 'split-pane-horizontal']

function ExecuteCommand(args = '', output = '', flavor = 'shell', syntax = 'bash')
	let output = a:output
	if output == ''
		let output = GetPrefferredCommandOutput()
	endif

	let command = GetCommandString(a:args, a:flavor, output)

	if output == 'tmux'
		silent call EnsureTmuxSession()
		call system("tmux send-keys -t ".g:escapeTmuxPaneID." '".command."' Enter")
		silent call system("tmux display-popup -E 'tmux a -t ".g:escapeTmuxSession."' &")
	elseif output == 'split-pane-horizontal'
		execute "botright terminal " . command 
		let &l:syntax=a:syntax
	elseif output == 'split-pane-vertical'
		execute "botright vertical terminal " . command
		let &l:syntax=a:syntax
	elseif output == 'insert'
		execute "read! " . command
	else
		execute "!" . command
	endif
endfunction

function GetCommandString(args, flavor, output)
	let command = ''
	let gitRoot = FindGitRoot()

	if a:flavor == 'shell'
		let command = a:args

	elseif a:flavor == 'npm'
		let command = 'npm test ' . a:args
		if gitRoot != ''
			let command = 'cd ' . gitRoot . '; ' . command
		endif

	elseif a:flavor == 'django'
		let command = './manage.py test --keepdb ' . a:args
		if gitRoot != ''
			let command = 'cd ' . gitRoot . '; ' . command
		endif
	endif

	if stridx(a:output, 'tmux') != -1
		let command = command.";"
					\ . " echo \"-----------------------------\" | lolcat;"
					\ . " echo \"(ENTER to close, C^c to stay)\";"
					\ . " read </dev/tty;"
					\ . " tmux detach-client" " omit final ';'
		echom command
	endif

	if a:output == ''
		let command = "clear; ".command
	endif

	return command
endfunction

function GetPrefferredCommandOutput()
	for output in g:escapeCommandOutputs
		if stridx(output, 'tmux') != -1 && executable('tmux')
			return output
		elseif stridx(output, 'split-pane') != -1 && v:version >= 800
			return output
		endif
	endfor

	return 'shell-escape'
endfunction
