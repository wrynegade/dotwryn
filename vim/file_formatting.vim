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
augroup end

augroup forced_filetype_recognition
	autocmd BufRead,BufNewFile *.tmux setfiletype tmux
augroup end
" }}}


" -- <Leader>ec to 'execute' a file ---------------------- {{{
augroup execute_file_shortcuts
	autocmd FileType tex		nnoremap <Leader>ec :! $WEBBROWSER %:r.pdf<CR>
	autocmd FileType markdown	nnoremap <Leader>ec :! $WEBBROWSER %:p<CR>
augroup end
" }}}


" -- Format Override Layers ------------------------------ {{{
source $VIM_DIR/rd_formatting.vim
" }}}


syntax on
