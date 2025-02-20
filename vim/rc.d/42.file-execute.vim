nnoremap <Leader>ec :execute b:executeDefault<CR>
nnoremap <Leader>ei :execute b:executeInteractive<CR>
nnoremap <Leader>eb :execute b:executeBuild<CR>
nnoremap <Leader>ef :execute b:executeFormat<CR>
nnoremap <Leader>et :execute b:executeTest<CR>

nnoremap <Leader>i  :execute b:executeImport<CR>
nnoremap <Leader>n  :execute b:executeNew<CR>

" --- (e)xe(c)ute -----------------------------------------------------
"          (i)nteractive
"          (b)uild
"     auto-(f)ormat
"          (t)ests
" {{{
augroup file_specific_commands
	autocmd!

	autocmd FileType * let b:executeDefault     = "call ExecuteCommand('%:p', 'split-pane-horizontal')"
	autocmd FileType * let b:executeInteractive = "call ExecuteCommand('%:p ' . input(expand('%').' -- '), 'split-pane-horizontal')"
	autocmd FileType * let b:executeBuild       = "echohl ErrorMsg | echom 'ERROR: no build steps defined' | echohl None"
	autocmd FileType * let b:executeFormat      = "%s/\\s\\+$//"
	autocmd FileType * let b:executeTest        = "echohl ErrorMsg | echom 'ERROR: no test steps defined' | echohl None"
	autocmd FileType * let b:executeImport      = "echohl ErrorMsg | echom 'ERROR: no import steps defined' | echohl None"
	autocmd FileType * let b:executeNew         = "echohl ErrorMsg | echom 'ERROR: no new steps defined' | echohl None"

	autocmd FileType go let b:executeDefault     = "!clear<CR><CR>q:?GoRun<CR><CR>"
	autocmd FileType go let b:executeFormat      = "<Plug>(go-imports)"
	autocmd FileType go nnoremap <silent> gd <Plug>(go-def-tab)

	autocmd FileType markdown let b:executeDefault = '!google-chrome-stable %:p'

	autocmd FileType python let b:executeDefault     = "call ExecuteCommand('python %:p', 'split-pane-vertical')"
	autocmd FileType python let b:executeInteractive = "call ExecuteCommand('bpython -qi %:p ' . input(expand('%').' -- '), 'split-pane-vertical')"

	autocmd FileType tex let b:executeDefault     = 'call ExecuteScwrypt("latex/open-pdf", "%:p")'
	autocmd FileType tex let b:executeBuild       = 'call ExecuteScwrypt("latex/build-pdf", "%:p")'
	autocmd FileType tex let b:executeFormat      = 'call ExecuteScwrypt("latex/cleanup", "%:p")'

	autocmd FileType yaml let b:scwryptDefault = "--group scwrypts --type zsh --name helm/get-template "
	autocmd FileType yaml let b:scwryptBuild   = "--group scwrypts --type zsh --name helm/update-dependencies "
	autocmd FileType yaml let b:scwryptArgs    = "--template-filename %:p "
	autocmd FileType yaml let b:executeDefault     = 'call ExecuteScwrypt(b:scwryptDefault, b:scwryptArgs . "--raw ", "split-pane-vertical", "yaml")'
	autocmd FileType yaml let b:executeInteractive = 'call ExecuteScwryptInteractive(b:scwryptDefault, b:scwryptArgs, "split-pane-vertical", "yaml")'
	autocmd FileType yaml let b:executeBuild       = 'call ExecuteScwrypt(b:scwryptBuild, b:scwryptArgs, "split-pane-vertical", "yaml")'
	autocmd FileType yaml let b:executeTest        = 'call ExecuteScwrypt(b:scwryptDefault, b:scwryptArgs . "--debug --update ", "split-pane-vertical", "yaml")'

	autocmd FileType rust let b:executeDefault                       = "call ExecuteCommand('zsh -c \"cd %:p:h; cargo run --quiet\"', 'split-pane-horizontal')"
	autocmd BufRead,BufNewFile */Cargo.toml let b:executeDefault     = "call ExecuteCommand('zsh -c \"cd %:p:h; cargo run --quiet\"', 'split-pane-horizontal')"

	autocmd FileType rust let b:executeInteractive                   = "call ExecuteCommand('zsh -c \"cd %:p:h; cargo run --quiet -- ' . input('cargo run -- ') . '\"', 'split-pane-horizontal')"
	autocmd BufRead,BufNewFile */Cargo.toml let b:executeInteractive = "call ExecuteCommand('zsh -c \"cd %:p:h; cargo run --quiet -- ' . input('cargo run -- ') . '\"', 'split-pane-horizontal')"

	autocmd FileType rust let b:executeBuild                         = "call ExecuteCommand('zsh -c \"cd %:p:h; cargo build\"', 'split-pane-horizontal')"
	autocmd BufRead,BufNewFile */Cargo.toml let b:executeBuild       = "call ExecuteCommand('zsh -c \"cd %:p:h; cargo build\"', 'split-pane-horizontal')"

	autocmd FileType rust let b:executeTest                          = "call ExecuteCommand('zsh -c \"cd %:p:h; cargo test\"', 'split-pane-horizontal')"
	autocmd BufRead,BufNewFile */Cargo.toml let b:executeTest        = "call ExecuteCommand('zsh -c \"cd %:p:h; cargo test\"', 'split-pane-horizontal')"

	" --- OVERRIDES ---------------------------- "

	autocmd FileType          *.scwrypts let b:scwryptsType = ""
	autocmd FileType        zsh.scwrypts let b:scwryptsType = "zsh"
	autocmd FileType     python.scwrypts let b:scwryptsType = "py"
	autocmd FileType javascript.scwrypts let b:scwryptsType = "zx"
	autocmd FileType typescript.scwrypts let b:scwryptsType = "zx"

	autocmd FileType *.scwrypts let b:scwryptsSubPath = substitute(substitute(expand("%:p"), ".*\.scwrypts/", "", ""), "^".b:scwryptsType."/", "", "")
	autocmd FileType *.scwrypts let b:scwryptsAutoName = b:scwryptsType . " " . substitute(substitute(b:scwryptsSubPath, ".[a-z]\\+$", "", ""), "/", " ", "g") . " "
	autocmd FileType *.scwrypts let b:scwryptsPrevArgs = ' '

	let g:scwryptsEnvs       = split(system('scwrypts --list-envs'), '\n')
	let g:scwryptsEnvChoices = split(system('echo SCWRYPTS_ENV=; scwrypts --list-envs | awk "{print \"\"NR\". \"\$0}"'), '\n')

	autocmd FileType *.scwrypts let b:executeDefault     = "call ExecuteScwrypt(b:scwryptsAutoName, ' ', 'split-pane-horizontal', 'bash', '4')"
	autocmd FileType *.scwrypts let b:executeInteractive = "call ExecuteScwryptInteractive(b:scwryptsAutoName, ' ', 'split-pane-horizontal')"
	autocmd FileType *.scwrypts let b:executeBuild       = "let $SCWRYPTS_ENV=g:scwryptsEnvs[inputlist(g:scwryptsEnvChoices) - 1]"
	autocmd FileType *.scwrypts let b:executeTest        = "call ExecuteScwrypt(b:scwryptsAutoName, b:scwryptsPrevArgs, 'split-pane-horizontal', 'bash', '4')"

	autocmd BufRead,BufNewFile */*.module.zsh let b:executeNew = "call ExecuteScwrypt('create module template', '--mode stdout', 'insert', '0')"
augroup end
" }}}
