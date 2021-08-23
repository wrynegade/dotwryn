" -- Custom Format Settings ------------------------------ {{{
function FormatFileType(indent, expandtab, foldmethod, foldlevel, spell)
	let &l:tabstop = a:indent
	let &l:softtabstop = a:indent
	let &l:shiftwidth = a:indent

	let &l:expandtab = a:expandtab

	let &l:foldmethod = a:foldmethod
	let &l:foldlevel = a:foldlevel

	let &l:spell = a:spell
endfunction

augroup filetype_specific_formatting
	autocmd!
	autocmd FileType python     call FormatFileType(4, v:true,  'indent', 99, v:false)
	autocmd FileType java       call FormatFileType(4, v:true,  'indent', 99, v:false)
	autocmd FileType cpp        call FormatFileType(4, v:true,  'indent', 99, v:false)
	autocmd FileType cmake      call FormatFileType(4, v:true,  'indent', 99, v:false)
	autocmd FileType cs         call FormatFileType(4, v:true,  'indent', 99, v:false)
	autocmd FileType html       call FormatFileType(2, v:true,  'indent', 99, v:false)
	autocmd FileType javascript call FormatFileType(2, v:true,  'indent', 99, v:false)
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

augroup forced_filetype_recognition
	autocmd BufRead,BufNewFile *.tmux  setfiletype tmux
	autocmd BufRead,BufNewFile *.clisp setfiletype lisp
	autocmd BufRead,BufNewFile *.lsp   setfiletype lisp

	let g:tex_flavor = "latex"
augroup end
" }}}


" -- <Leader>ec to 'ExeCute' a file ---------------------- {{{
augroup execute_file_shortcuts
	autocmd FileType tex		nnoremap <Leader>ec :! pdf=$(grep -rl 'documentclass' ./ <bar> head -n 1 <bar> sed 's/\(.*\)\.tex/\1.pdf/'); $WEBBROWSER $pdf<CR>
	autocmd FileType markdown	nnoremap <Leader>ec :! $WEBBROWSER %:p<CR>
	autocmd FileType go         nnoremap <Leader>ec :!clear<CR><CR>q:?GoRun<CR><CR>
augroup end
" }}}


" -- Miscellaneous File-specific Commands ---------------- {{{
augroup latex_commands

	" overwrite the <leader>t 'test' to (double) recompile the latex document.
	" in case pdflatex gets in a stuck state, it is run through timeout 3
	autocmd FileType tex nnoremap <Leader>t :! clear; texfile=$(grep -rl 'documentclass' ./ <bar> head -n 1); timeout 3 pdflatex $texfile && { clear; pdflatex $texfile <bar> lolcat }<CR>

augroup end

augroup go_commands
	autocmd FileType go nmap <silent> <Leader>ef <Plug>(go-imports)
	autocmd FileType go nmap <silent> gd <Plug>(go-def-tab)
augroup end
" }}}


" -- Format Override Layers ------------------------------ {{{
source $WRYNVIMPATH/rentdynamics.vim
" }}}


syntax on
