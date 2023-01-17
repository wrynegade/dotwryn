source $HOME/.config/wryn/env.vim

if isdirectory(expand("$HOME/.vim/bundle/Vundle.vim"))
	source $WRYNVIMPATH/vundle.vim
endif

source $WRYNVIMPATH/options.vim
source $WRYNVIMPATH/execute.vim
source $WRYNVIMPATH/formatting.vim
source $WRYNVIMPATH/navigation.vim
source $WRYNVIMPATH/color.vim
source $WRYNVIMPATH/utility.vim

" ---------------------------------------------------------------------
" {{{

" <SPACE> to execute macro on q
nnoremap <Space> @q

" \q for `q:`
nnoremap <Leader>q q:

" \s previous selection command
nnoremap <Leader>s :'<,'>

" (e)dit / (s)ource vimrc
nnoremap <Leader>ev :tabedit $WRYNVIMRC<CR>
nnoremap <Leader>sv :source $MYVIMRC<CR>

" Q to replace current line/selection with bash execution
vnoremap Q !$SHELL<CR>
nnoremap Q !!$SHELL<CR>

" move the current line down/up one
nnoremap - :move +1 <CR>
nnoremap _ :move -2 <CR>

" \j like J, but append current line to the line below
nnoremap <Leader>j ddpkJ

" \d insert formatted date below
nnoremap <Leader>d  :let @d = system("date '+%A, %B %-d, %Y'")<CR>o<C-r>d<BS> <esc>

" \g git fugitive shortcuts
nnoremap <Leader>gb :Git blame<CR>

" \r = open last REPL (p)ython (n)odejs (c)lisp
nnoremap <Leader>r  q:?^echom 'quickrepl'<CR><CR>
nnoremap <Leader>rp q:oechom 'quickrepl' \| call ExecuteCommand('bpython', 'split-pane-vertical')<CR>
nnoremap <Leader>rn q:oechom 'quickrepl' \| call ExecuteCommand('node', 'split-pane-vertical')<CR>
nnoremap <Leader>rc q:oechom 'quickrepl' \| call ExecuteCommand('clisp', 'split-pane-horizontal')<CR>
nnoremap <Leader>rs q:oechom 'quickrepl' \| call ExecuteCommand('zsh -l', 'split-pane-vertical')<CR>

" \t = run last quicktest
"   t)ype new quicktest
"   e)dit last quicktest
nnoremap <Leader>t  q:?^echom 'quicktest'<CR><CR><CR>
nnoremap <Leader>tt q:oechom 'quicktest' \| call ExecuteCommand('')<ESC>F'i
nnoremap <Leader>te q:?^echom 'quicktest'<CR>

" ./utility.vim
nnoremap <Leader><Leader>w  :call Sudowrite()<CR>
nnoremap <Leader><Leader>x  :call MakeFileExecutable(0)<CR>
nnoremap <Leader><Leader>xx :call MakeFileExecutable(1)<CR>

" (c)opy / (p)aste from xclip
" TODO: learn how to compile vim with x11 compatibility and delete
vnoremap <Leader>c :w !xclip<CR><CR>
nnoremap <Leader>v o<esc>!!xclip -o<CR>
nnoremap <Leader>sc :'<,'>w !xclip<CR><CR>

" enable/disable true color
nnoremap <f12> :set invtermguicolors<CR>

" --- available / rarely used bindings (personal reference) ---

" nnoremap <BS>
" nnoremap <C-t>
" nnoremap <C-b>
" nnoremap z
" nnoremap ^

" }}}
" ---------------------------------------------------------------------
