syntax on " detect syntax

" -- File Formatting ------------------------------------- {{{
augroup filetype_specific_formatting
	autocmd!
	autocmd FileType python     setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab   foldmethod=indent foldlevel=99
	autocmd FileType java       setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab foldmethod=indent foldlevel=99
	autocmd FileType cs         setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab foldmethod=indent foldlevel=99
	autocmd FileType html       setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab foldmethod=indent foldlevel=99
	autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab foldmethod=indent foldlevel=99
	autocmd FileType vim        setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab foldmethod=marker foldlevel=1
	autocmd FileType sh         setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab foldmethod=indent foldlevel=99
	autocmd FileType lisp       setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab   foldmethod=manual foldlevel=99
	autocmd FileType markdown   setlocal tabstop=2 noexpandtab foldmethod=indent foldlevel=99 spell
	autocmd FileType tex		setlocal tabstop=2 noexpandtab foldmethod=indent foldlevel=99 spell
augroup end
" }}}


" <Leader>ec Commands run on a per-extension basis {{{
augroup execute_file_shortcuts
	" tex opens pdf in chrome
	autocmd FileType tex	nnoremap <Leader>ec :! $WEBBROWSER %:r.pdf<CR>
augroup end
" }}}
