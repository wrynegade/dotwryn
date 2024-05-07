"
" 31.utility-execute.vim wrapper for scwrypts-specific execution
"

function ExecuteScwrypt(scwrypt = '', args = '', output = '', syntax = 'bash')
	let b:scwryptsPrevArgs = a:args
	call ExecuteCommand('scwrypts -n ' . a:scwrypt . ' -- ' . a:args, a:output, 'shell', a:syntax)
	echom 'scwrypts -n ' . a:scwrypt . '--' . a:args
endfunction

function ExecuteScwryptInteractive(scwrypt = '', args = '', output = '', syntax = 'bash')
	call ExecuteScwrypt(a:scwrypt, a:args . input('scwrypts ' . a:scwrypt . '--' . a:args), a:output, a:syntax)
endfunction
