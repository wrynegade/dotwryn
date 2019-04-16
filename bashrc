# terminal colors
source ./bashcolors
source ./fun

# --- Welcome message -----------------------------------------
exec artii "Welcome, beautiful" | lolcat; echo; cowsay -p -f small "damn u sexy" | lolcat; 

# --- Utility Alias -------------------------------------------
alias restart='clear; source ~/.bashrc; echo'
alias datereadable='date +"%A %B %d, %Y"'
