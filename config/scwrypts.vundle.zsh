#
# Scwrypts Build Definitions
#


VUNDLE_BUILD__ale() {}
VUNDLE_BUILD__nerdtree() {}
VUNDLE_BUILD__vim-fugitive() {}
VUNDLE_BUILD__vim-go() {}
VUNDLE_BUILD__vim-surround() {}

VUNDLE_BUILD__vim-hexokinase() { make hexokinase; }
VUNDLE_BUILD__youcompleteme()  { ./install.py --all; }
