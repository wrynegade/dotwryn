"
" quickly run a custom command with <Leader>t
"
" this is a safer version of what used to be my 'quicktest'
" bindings; sometimes I don't have the time to create a proper
" language/technology-specific testing utility, and would
" rather run a quick SHELL command at the touch of a button
"
" this safer, upgrade to the previous bindings (listed below)
" requires buffer-level specificity and does not allow quick
" commands to bleed between vim sessions and buffers; this
" has saved me from some accidental push-to-main-with-admin-power
" situations which arose from the previous bindings
"
" previously:
"
" " \t = run last quicktest
" "   t)ype new quicktest
" "   e)dit last quicktest
" nnoremap <Leader>t  q:?^echom 'quicktest'<CR><CR><CR>
" nnoremap <Leader>tt q:oechom 'quicktest' \| call ExecuteCommand('')<ESC>F'i
" nnoremap <Leader>te q:?^echom 'quicktest'<CR>
"

let g:quick_command_output_format = 'split-pane-horizontal'

function QuickCommand()
	let l:quick_command = get(b:, 'quick_command', '')
	if ( l:quick_command == '' )
		let l:quick_command = input('input quick command : ') | redraw
	endif

	if ( l:quick_command == '' )
		echohl DiffDelete | echo "no command supplied; canceled execution" | echohl None
		return
	endif

	let b:quick_command = l:quick_command

	call ExecuteCommand(l:quick_command, g:quick_command_output_format)
endfunction

nnoremap <Leader>t	:call QuickCommand()<CR>
