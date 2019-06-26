RC_DIR="$HOME/.wryn"

# terminal colors
source $RC_DIR/bashcolors
# scripts for fun (see file for dependencies)
source $RC_DIR/fun

# --- Welcome message -----------------------------------------
exec figlet "Welcome, beautiful" | lolcat; echo; cowsay -p "damn u sexy" | lolcat; 

# --- Utility Alias -------------------------------------------
alias restart='clear; source ~/.bashrc; echo'
alias datereadable='date +"%A %B %d, %Y"'

# --- !@#$ Aliases --------------------------------------------
alias clera='clear';

# --- Note-taking facilitated ---------------------------------
NOTE_PATH='/Users/w0ryn/Documents/notes';
NOTE_EXTENSION='.txt';
alias mynotes='cd $NOTE_PATH';
function note() { vim $NOTE_PATH/$1$NOTE_EXTENSION; }
function notes() { NOTE="$NOTE_PATH/$1$NOTE_EXTENSION"; [ -f $NOTE ] && vim $NOTE || vim $NOTE_PATH; }

# --- Homework facilitated ------------------------------------
HW_TEMPLATE="$RC_DIR/latex/homework_template.tex"
function hw() { [ $# -ne 0 ] && cp $HW_TEMPLATE ./$1.tex || echo "Homework filename required"; }
