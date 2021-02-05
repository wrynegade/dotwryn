
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

function SplitPaneTest(shellCommand, verticalSplit = 0)
	if a:verticalSplit
		execute "vertical terminal " . a:shellCommand
	else
		execute "terminal " . a:shellCommand
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

function DjangoSplitTest(verticalSplit = 0)
	let l:command = GetDjangoTestCommand()
	call SplitPaneTest(l:command, a:verticalSplit)
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
" === npm ===========================================================
" ===================================================================

function NpmTmuxTest(paneId = g:defaultTmuxPaneId)
	let l:command = "cd " . getcwd() . "; " . GetNpmTestCommand()
	call TmuxTest(l:command, a:paneId)
endfunction

function NpmSplitTest(verticalSplit = 0)
	let l:command = GetNpmTestCommand()
	call SplitPaneTest(l:command, a:verticalSplit)
endfunction

function NpmTest()
	let l:command = GetNpmTestCommand()
	call ShellEscapedTest(l:command)
endfunction


function GetNpmTestCommand()
	return "npm test"
endfunction
