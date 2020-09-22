" -- Custom Format Settings ------------------------------ {{{
augroup filetype_specific_formatting
	autocmd!
	autocmd FileType python     setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab   foldmethod=indent foldlevel=99
	autocmd FileType java       setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab   foldmethod=indent foldlevel=99
	autocmd FileType cpp        setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab foldmethod=indent foldlevel=99
	autocmd FileType cs         setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab   foldmethod=indent foldlevel=99
	autocmd FileType html       setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab   foldmethod=indent foldlevel=99
	autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab   foldmethod=indent foldlevel=99
	autocmd FileType css        setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab   foldmethod=indent foldlevel=99
	autocmd FileType vim        setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab foldmethod=marker foldlevel=99
	autocmd FileType sh         setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab foldmethod=indent foldlevel=99
	autocmd FileType zsh        setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab foldmethod=indent foldlevel=99
	autocmd FileType lisp       setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab   foldmethod=manual foldlevel=99
	autocmd FileType markdown   setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab foldmethod=indent foldlevel=99 spell
	autocmd FileType tex        setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab foldmethod=indent foldlevel=99 spell
	autocmd FileType postscr    setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab   foldmethod=indent foldlevel=99
augroup end

augroup forced_filetype_recognition
	autocmd BufRead,BufNewFile *.tmux setfiletype tmux
	let g:tex_flavor = "latex"
augroup end
" }}}


" -- <Leader>ec to 'ExeCute' a file ---------------------- {{{
augroup execute_file_shortcuts
	autocmd FileType tex		nnoremap <Leader>ec :! pdf=$(grep -rl 'documentclass' ./ <bar> head -n 1 <bar> sed 's/\(.*\)\.tex/\1.pdf/'); $WEBBROWSER $pdf<CR>
	autocmd FileType markdown	nnoremap <Leader>ec :! $WEBBROWSER %:p<CR>
augroup end
" }}}

" -- Miscelaneous File-specific Commands ----------------- {{{
augroup latex_commands

	" overwrite the <leader>t 'test' to (double) recompile the latex document.
	" in case pdflatex gets in a stuck state, it is run through timeout 5
	autocmd FileType tex nnoremap <Leader>t :! clear; texfile=$(grep -rl 'documentclass' ./ <bar> head -n 1); timeout 5 pdflatex $texfile && { clear; pdflatex $texfile <bar> lolcat }<CR>

augroup end
" }}}


" -- Format Override Layers ------------------------------ {{{
source $VIM_DIR/rd_formatting.vim
" }}}


syntax on
