#
# Scwrypts Build Definitions
#

VUNDLE__BUILD__ale() {
	# ... build steps from /home/w0ryn/.vim/ale 
}

VUNDLE__BUILD__nerdtree() {
	# ... build steps from /home/w0ryn/.vim/nerdtree 
}

VUNDLE__BUILD__vim-dim() {
	# ... build steps from /home/w0ryn/.vim/vim-dim 
}

VUNDLE__BUILD__vim-fugitive() {
	# ... build steps from /home/w0ryn/.vim/vim-fugitive 
}

VUNDLE__BUILD__vim-go() {
	# ... build steps from /home/w0ryn/.vim/vim-go 
}

VUNDLE__BUILD__vim-surround() {
	# ... build steps from /home/w0ryn/.vim/vim-surround 
}

VUNDLE__BUILD__vim-hexokinase() {
	# ... build steps from /home/w0ryn/.vim/vim-hexokinase 
	make hexokinase
}

VUNDLE__BUILD__youcompleteme() {
	# ... build steps from /home/w0ryn/.vim/youcompleteme 
	./install.py --all
}
