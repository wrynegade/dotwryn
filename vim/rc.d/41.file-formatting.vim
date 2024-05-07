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

	autocmd BufRead,BufNewFile */scwrypts/* execute "set filetype=".&filetype.".scwrypts"

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
	autocmd FileType smarty     call FormatFileType(2, v:true,  'indent', 99, v:false)
augroup end

let g:markdown_fenced_languages = ['javascript', 'json', 'python', 'bash', 'yaml', 'shell=zsh', 'sql']
" }}}

syntax on
