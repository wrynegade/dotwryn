"
" quickly open a REPL with <Leader>r
"
" tries to guess based on configuration + filetype what repl to use,
" otherwise asks the user to provide the required REPL command
" for the current buffer
"
" always uses the last used REPL type unless specified otherwise
" in the :call arguments
"

let g:quickrepl_commands_by_filetype = {
			\ 'python': 'bpython',
			\ 'zsh': 'zsh',
			\ 'bash': 'bash',
			\ 'typescript': 'node',
			\ 'javascript': 'node',
			\}

let g:quickrepl_output_format_default = 'split-pane-horizontal'
let g:quickrepl_output_format_overrides_by_repl_command = {
			\ 'bpython': 'split-pane-vertical',
			\ 'node': 'split-pane-vertical',
			\ 'zsh': 'split-pane-vertical',
			\}

let g:quickrepl_repl_command_args_by_repl_command= {
			\ 'zsh': '-l',
			\}

function QuickREPL(repl = '')
	let l:repl = a:repl

	if ( l:repl == '' )
		let l:repl = get(b:, 'quick_repl', '')
	endif

	if ( l:repl == '' )
		let l:repl = get(g:quickrepl_commands_by_filetype, &filetype, '')
	endif

	if ( l:repl == '' )
		let l:repl = input('input a repl command : ') | redraw
	endif

	if ( l:repl == '' )
		echohl DiffDelete | echo "no command supplied; canceled REPL execution" | echohl None
		return
	endif

	let b:quick_repl = l:repl

	let l:output = get(g:quickrepl_output_format_overrides_by_repl_command, l:repl, g:quickrepl_output_format_default)
	let l:repl_args = get(g:quickrepl_repl_command_args_by_repl_command, l:repl, '')

	call ExecuteCommand(l:repl . ' ' . l:repl_args, l:output)
endfunction

nnoremap <Leader>r	:call QuickREPL()<CR>
