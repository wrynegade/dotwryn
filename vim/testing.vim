
let tmuxTestSessionName = "test"
let defaultTmuxPaneId = g:tmuxTestSessionName . ":0.0"

function InitializeTmuxTestSession()
	call system("tmux new -ds " . g:tmuxTestSessionName . " -c $HOME >/dev/null 2>&1")
endfunction


" ===================================================================
" === test formats ==================================================
" ===================================================================

function TmuxTest(shellCommand, paneId = g:defaultTmuxPaneId)
	if a:paneId == g:defaultTmuxPaneId
		silent call InitializeTmuxTestSession()
	endif

	call system("tmux send-keys -t " . a:paneId . " 'clear; " . a:shellCommand . "' Enter")
endfunction

function SplitPaneTest(shellCommand, horizontal = v:false)
	if a:horizontal
		execute "botright terminal " . a:shellCommand
	else
		execute "botright vertical terminal " . a:shellCommand
	endif
endfunction

function ShellEscapedTest(shellCommand)
	execute "!" . a:shellCommand
endfunction


" ===================================================================
" === python-django =================================================
" ===================================================================

function DjangoTmuxTest(paneId = g:defaultTmuxPaneId)
	let l:command = "cd " . getcwd() . "; " . GetDjangoTestCommand()
	call TmuxTest(l:command, a:paneId)
endfunction

function DjangoSplitTest(horizontal = v:false)
	let l:command = GetDjangoTestCommand()
	call SplitPaneTest(l:command, a:horizontal)
endfunction

function DjangoTest()
	let l:command = GetDjangoTestCommand()
	call ShellEscapedTest(l:command)
endfunction


function GetDjangoTestCommand()
	return GetDjangoManagePy() . " test --keepdb"
endfunction

function GetDjangoManagePy()
	return substitute(expand(getcwd()), "/code.*", "/code/manage.py", "")
endfunction


" ===================================================================
" === dotnet core ===================================================
" ===================================================================

function DotnetTest(filter = '')
	let l:command =
				\ 'cd ' . GetDotnetProjectLocation()
				\ . ';' . 'dotnet build -clp:ErrorsOnly'
				\ . ';' . 'cd ' . GetDotnetProjectLocation(1)
				\ . ';' . 'dotnet test -clp:ErrorsOnly'
	if a:filter != ''
		let l:command = l:command . ' --filter ' . a:filter
	endif
	call TmuxTest(l:command)
endfunction

function DotnetBuild()
	let l:command =
				\ 'cd ' . GetDotnetProjectLocation()
				\ . ';' . 'dotnet build -clp:ErrorsOnly'

	call TmuxTest(l:command)
endfunction

function GetDotnetProjectLocation(test = v:false)
	let l:projectRoot = substitute(expand(getcwd()), '/code.*', '/code', '')
	let l:projectName = substitute(expand(getcwd()), l:projectRoot . '/\([^/]*\).*', '\1', '')
	if a:test
		let l:testPath = system('ls ' . l:projectRoot . '/**/*.csproj | grep Test | head -1')
	else
		if l:projectName != ''
			let l:testPath = l:projectRoot . '/' . l:projectName
		else
			let l:testPath = system('ls ' . l:projectRoot . '/**/*.csproj | grep -v Test | head -1')
		endif
	endif
	return substitute(l:testPath, '\(.*\)/.*.csproj.*', '\1', '')
endfunction

" ===================================================================
" === npm ===========================================================
" ===================================================================

function NpmTmuxTest(paneId = g:defaultTmuxPaneId)
	let l:command = "cd " . getcwd() . "; " . GetNpmTestCommand()
	call TmuxTest(l:command, a:paneId)
endfunction

function NpmSplitTest(horizontal = v:false)
	let l:command = GetNpmTestCommand()
	call SplitPaneTest(l:command, a:horizontal)
endfunction

function NpmTest()
	let l:command = GetNpmTestCommand()
	call ShellEscapedTest(l:command)
endfunction


function GetNpmTestCommand()
	return "npm test"
endfunction
