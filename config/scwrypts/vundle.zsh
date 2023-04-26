#
# Scwrypts Build Definitions
#

VUNDLE_BUILD__ale() {}
VUNDLE_BUILD__nerdtree() {}
VUNDLE_BUILD__vim-dim() {}
VUNDLE_BUILD__vim-fugitive() {}
VUNDLE_BUILD__vim-go() {}
VUNDLE_BUILD__vim-surround() {}

VUNDLE_BUILD__vim-hexokinase() { make hexokinase; }

VUNDLE_BUILD__youcompleteme()  { ./install.py --all; }

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

VUNDLE__BUILD__vim-hexokinase() {
	# ... build steps from /home/w0ryn/.vim/vim-hexokinase 
}

VUNDLE__BUILD__vim-surround() {
	# ... build steps from /home/w0ryn/.vim/vim-surround 
}

VUNDLE__BUILD__youcompleteme() {
	# ... build steps from /home/w0ryn/.vim/youcompleteme 
}
