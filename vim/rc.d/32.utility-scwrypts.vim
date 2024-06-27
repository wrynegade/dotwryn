"
" 31.utility-execute.vim wrapper for scwrypts-specific execution
"

function ExecuteScwrypt(scwrypt = '', args = '', output = '', syntax = 'bash', loglevel = '0')
	let b:scwryptsPrevArgs = a:args
	call ExecuteCommand('scwrypts --log-level ' . a:loglevel . ' ' . a:scwrypt . ' -- ' . a:args, a:output, 'shell', a:syntax)
	echom 'scwrypts -n ' . a:scwrypt . '--' . a:args
endfunction

function ExecuteScwryptInteractive(scwrypt = '', args = '', output = '', syntax = 'bash', loglevel = '4')
	call ExecuteScwrypt(a:scwrypt, a:args . input('scwrypts ' . a:scwrypt . '--' . a:args), a:output, a:syntax, a:loglevel)
endfunction
