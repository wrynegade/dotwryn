#!/bin/bash
DOTWRYN="$HOME/.wryn"
RC_DIR="$DOTWRYN/bash"

# source .wryn/bash files
for file in $(find $RC_DIR -maxdepth 1 -type f); do source $file; done;

# osx
if [[ "$OSTYPE" == "darwin"* ]]; then
	for file in $(find $RC_DIR/osx -type f); do source $file; done;
fi

# linux
if [[ "$OSTYPE" == "linux-gnu" ]]; then
	for file in $(find $RC_DIR/linux -type f); do source $file; done;
fi

# --- Welcome message -----------------------------------------
exec figlet "Welcome, beautiful" | lolcat; echo; cowsay -p "damn u sexy" | lolcat; 

# --- Utility Alias -------------------------------------------
alias restart='clear; source ~/.bashrc; echo'

# --- !@#$ Aliases --------------------------------------------
alias clera='clear';
alias sl='sl -alF | lolcat';

# --- Note-taking facilitated ---------------------------------
NOTE_PATH='/Users/w0ryn/Documents/notes';
NOTE_EXTENSION='.txt';
alias mynotes='cd $NOTE_PATH';
function note() { vim $NOTE_PATH/$1$NOTE_EXTENSION; }
function notes() { NOTE="$NOTE_PATH/$1$NOTE_EXTENSION"; [ $1 ] && [ -f $NOTE ] && vim $NOTE || vim $NOTE_PATH; }

# --- ViM as default editor -----------------------------------
export EDITOR='vim'
export VISUAL='vim'
