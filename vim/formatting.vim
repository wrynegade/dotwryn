" --- custom format settings ------------------------------------------
" {{{
function FormatFileType(indent, expandtab, foldmethod, foldlevel, spell)
	let &l:tabstop = a:indent
	let &l:softtabstop = a:indent
	let &l:shiftwidth = a:indent

	let &l:expandtab = a:expandtab

	let &l:foldmethod = a:foldmethod
	let &l:foldlevel = a:foldlevel

	let &l:spell = a:spell
endfunction

augroup forced_filetype_recognition
	autocmd!
	autocmd BufRead,BufNewFile *.tmux          setfiletype tmux
	autocmd BufRead,BufNewFile *.clisp         setfiletype lisp
	autocmd BufRead,BufNewFile *.lsp           setfiletype lisp
	autocmd BufRead,BufNewFile Dockerfile*     setfiletype dockerfile
	autocmd BufRead,BufNewFile *i3.conf        setfiletype i3config
	autocmd BufRead,BufNewFile *.template.yaml set filetype=yaml.cloudformation
	autocmd BufRead,BufNewFile git.conf        setfiletype gitconfig

	let g:tex_flavor = "latex"
augroup end

augroup filetype_specific_formatting
	autocmd!
	autocmd FileType python     call FormatFileType(4, v:true,  'indent', 99, v:false)
	autocmd FileType java       call FormatFileType(4, v:true,  'indent', 99, v:false)
	autocmd FileType cpp        call FormatFileType(4, v:true,  'indent', 99, v:false)
	autocmd FileType cmake      call FormatFileType(4, v:true,  'indent', 99, v:false)
	autocmd FileType cs         call FormatFileType(4, v:true,  'indent', 99, v:false)
	autocmd FileType css        call FormatFileType(2, v:true,  'indent', 99, v:false)
	autocmd FileType sass       call FormatFileType(2, v:true,  'indent', 99, v:false)
	autocmd FileType html       call FormatFileType(2, v:true,  'indent', 99, v:false)
	autocmd FileType javascript call FormatFileType(2, v:true,  'indent', 99, v:false)
	autocmd FileType typescript call FormatFileType(2, v:true,  'indent', 99, v:false)
	autocmd FileType vim        call FormatFileType(4, v:false, 'marker', 99, v:false)
	autocmd FileType sh         call FormatFileType(4, v:false, 'indent', 99, v:false)
	autocmd FileType zsh        call FormatFileType(4, v:false, 'indent', 99, v:false)
	autocmd FileType lisp       call FormatFileType(2, v:true,  'indent', 99, v:false)
	autocmd FileType markdown   call FormatFileType(2, v:false, 'indent', 99, v:true )
	autocmd FileType tex        call FormatFileType(8, v:false, 'indent', 99, v:true )
	autocmd FileType postscr    call FormatFileType(2, v:true,  'indent', 99, v:false)
	autocmd FileType haskell    call FormatFileType(2, v:true,  'indent', 99, v:false)
	autocmd FileType perl       call FormatFileType(4, v:true,  'indent', 99, v:false)
	autocmd FileType kotlin     call FormatFileType(2, v:true,  'indent', 99, v:false)
	autocmd FileType dockerfile call FormatFileType(4, v:true,  'indent', 99, v:false)
	autocmd FileType vue        call FormatFileType(2, v:true,  'indent', 99, v:false)
	autocmd FileType go         call FormatFileType(4, v:false, 'manual', 99, v:false)
	autocmd FileType json       call FormatFileType(2, v:false, 'indent', 99, v:false)
augroup end

let g:markdown_fenced_languages = ['javascript', 'json', 'python', 'bash', 'yaml', 'shell=zsh']
" }}}


" --- (e)xe(c)ute -----------------------------------------------------
"          (i)nteractive
"          (b)uild
"     auto-(f)ormat
"          (t)ests
" {{{
augroup file_specific_command_overrides
	autocmd!
	nnoremap <Leader>ec :call ExecuteCommand('%:p', 'split-pane-horizontal')<CR>
	nnoremap <Leader>ei :echohl ErrorMsg <bar> echom 'ERROR: no interactive execute defined' <bar> echohl None<CR>
	nnoremap <Leader>eb :echohl ErrorMsg <bar> echom 'ERROR: no build steps defined'         <bar> echohl None<CR>
	nnoremap <Leader>ef :echohl ErrorMsg <bar> echom 'ERROR: no auto-format steps defined'   <bar> echohl None<CR>
	nnoremap <Leader>et :echohl ErrorMsg <bar> echom 'ERROR: no test steps defined'          <bar> echohl None<CR>

	autocmd FileType tex  nnoremap <Leader>ec :! scwrypts -n latex/open-pdf  -- %:p<CR>
	autocmd FileType tex  nnoremap <Leader>eb :! scwrypts -n latex/build-pdf -- %:p<CR>
	autocmd FileType tex  nnoremap <Leader>ef :! scwrypts -n latex/cleanup   -- %:p<CR>

	autocmd FileType markdown  nnoremap <Leader>ec :!xdg-open %:p<CR>

	autocmd FileType go  nnoremap          <Leader>ec :!clear<CR><CR>q:?GoRun<CR><CR>
	autocmd FileType go  nnoremap <silent> <Leader>ef <Plug>(go-imports)
	autocmd FileType go  nnoremap <silent> gd <Plug>(go-def-tab)

	autocmd FileType python  nnoremap <Leader>ec :call ExecuteCommand('bpython %:p', 'split-pane-vertical')<CR>
	autocmd FileType python  nnoremap <Leader>ei :call ExecuteCommand('bpython -qi %:p', 'split-pane-vertical')<CR>
augroup end
" }}}


" --- organization overrides ------------------------------------------
" {{{

source $WRYNVIMPATH/override/rentdynamics.vim
source $WRYNVIMPATH/override/directus.vim

" }}}


syntax on
