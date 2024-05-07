if empty($DOTWRYN)
	let $DOTWRYN=expand("$HOME/.wryn")
endif

let $VIMRC=expand("$DOTWRYN/vim/rc.vim")
for vimrcfile in split(trim(system("find " . expand("$DOTWRYN/vim/rc.d") . " -type f | sort -u")), '\n')
	execute 'source ' . vimrcfile
endfor

" -------------------------------------------------------------------
" --- generic bindings (easy reference) -----------------------------
" -------------------------------------------------------------------

" <SPACE> to execute macro on q
nnoremap <Space> @q

" \q for `q:`
nnoremap <Leader>q q:

" \s previous selection command
nnoremap <Leader>s :'<,'>

" Q to replace current line(s) with shell execution
vnoremap Q !$SHELL<CR>
nnoremap Q !!$SHELL<CR>

" \j like J, but append current line to the line below
nnoremap <Leader>j ddpkJ

" move the current line down/up one
nnoremap - :move +1 <CR>
nnoremap _ :move -2 <CR>

" \d insert formatted date below
nnoremap <Leader>d  :let @d = system("date '+%A, %B %-d, %Y'")<CR>o<C-r>d<BS> <esc>

" \m to set buffer to modifiable
nnoremap <Leader>m :set modifiable<CR>

" (c)opy / (p)aste from xclip
" TODO: learn how to compile vim with x11 compatibility and delete
vnoremap <Leader>c :w !xclip<CR><CR>
nnoremap <Leader>v o<esc>!!xclip -o<CR>
nnoremap <Leader>sc :'<,'>w !xclip<CR><CR>

" enable/disable true color
nnoremap <f12> :set invtermguicolors<CR>

" -------------------------------------------------------------------
" --- available / rarely used bindings (personal reference) ---------
" -------------------------------------------------------------------

" nnoremap <BS>
" nnoremap <C-t>
" nnoremap <C-b>
" nnoremap z
" nnoremap ^
