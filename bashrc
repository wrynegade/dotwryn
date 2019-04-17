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
