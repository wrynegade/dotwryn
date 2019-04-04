exec artii "Welcome, beautiful" | lolcat; echo; cowsay -p -f small "damn u sexy" | lolcat; 

export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig"
export PYCURL_SSL_LIBRARY=openssl

# --------- Utility Alias ------- 
alias datereadable='date +"%A %B %d, %Y"'
alias refresh_rd_db='psql postgres -c "DROP DATABASE rentdynamics;"; psql postgres -c "CREATE DATABASE rentdynamics with owner rd;"; psql postgres -c "DROP DATABASE rdrentplus;"; psql postgres -c "CREATE DATABASE rdrentplus with owner rd;"'

# vmail
alias rdvmail='VMAIL_HOME=~/.vmail/business1 vmail'

## TEMP (for cs3450)
WINDOR="$HOME/Documents/School/cs3450-softeng/teamProject";
alias windornpm='source $WINDOR/WindorApp/windor-node-env/bin/activate';
alias windordj='source $HOME/Documents/School/cs3450-softeng/windorenv/bin/activate';
##

alias rnt='cd ~/Documents/RentDynamics';

alias school='cd ~/Documents/School'
alias classes='echo \* \(cs2810\) comparch; echo \* \(cs3100\) opsys; echo \* \(cs3450\) softeng; echo \* \(cs5050\) advalgos; echo \* hackusu; echo \* gamenight; echo'
alias comparch='school; cd cs2810-comparch;'
alias cs2810='comparch'
alias opsys='school; cd cs3100-opsys'
alias cs3100='opsys'
alias softeng='school; cd cs3450-softeng'
alias cs3450='softeng'
alias advalgos='school; cd cs5050-advalgos'
alias cs5050='advalgos'

alias mydocs='cd ~/Documents/Personal;'

alias restart='clear; source ~/.bashrc; echo'

alias rdapi='source ~/Documents/RentDynamics/env/rd-api/bin/activate; cd ~/Documents/RentDynamics/code/rd-api'
alias leadmgmt='cd ~/Documents/RentDynamics/code/lead-mgmt; source ~/Documents/RentDynamics/env/lead-mgmt-env/bin/activate; clear; ls;'
alias lanyard='source ~/Documents/RentDynamics/env/lanyard/bin/activate'


# ------------ funsies ----------------
alias cheerup="clear; echo; fortune | cowsay -f stegosaurus | lolcat; echo;"

function pika {
	DIRECTORY="$HOME/Pictures/pika";

	# count the pikas
	IMAGE_COUNT=$(ls -l $DIRECTORY | wc -l);
	let "IMAGE_COUNT=IMAGE_COUNT-1";

	# pick a random gif from the pikachu directory
	IMAGE="$DIRECTORY/$((RANDOM % $IMAGE_COUNT)).gif";

	echo;
	imgcat $IMAGE
	echo;
}

function timer {
	# Directory containing gifs and wavs for loading :)
	# Dependent on imgcat and artii
	DIRECTORY="$HOME/Documents/Personal/timer";

	# Default timer to zero
	TIMER=0
	if [ -z "$1" ]
	then
		:
	else
		echo $1;
		let TIMER=$1
	fi
	# count the number of gifs/wavs
	IMAGE_COUNT=$(ls -l $DIRECTORY/gifs | wc -l);
	SOUND_COUNT=$(ls -l $DIRECTORY/wavs | wc -l);
	let "IMAGE_COUNT=IMAGE_COUNT-1";
	let "SOUND_COUNT=SOUND_COUNT-1";

	# select a random gif/wav
	IMAGE="$DIRECTORY/gifs/$((RANDOM % $IMAGE_COUNT)).gif";
	SOUND="$DIRECTORY/wavs/$((RANDOM % $SOUND_COUNT)).wav";
	clear;

	# view start of timer
	echo "$TIMER second timer:"; 
	artii "== START ==";

	# display gif
	imgcat $IMAGE;

	# timer
	sleep $TIMER;

	# play stop sound and message
	$(afplay $SOUND &);
	artii "== STOP! ==";
	echo;
}
# ------------ Color settings ---------

f_notabs=0
export LSCOLORS="ExxxxxDxBxxxxxxxxxxxxx"

# Colors are organized into (Foreground)(Background) bits as seen below:
# ========
# 1 - Directory 
# 2 - Symbolic link
# 3 - Socket
# 4 - Pipe
# 5 - Executable
# 6 - Block special
# 7 - Character special
# 8 - Executable with setgid bit set
# 9 - Executable with setgid bit set
# 10- Directory writable to others, with sticky bit
# 11- Directory writable to others, without sticky bit
# ========
# a	black
# b	red
# c	green
# d	brown
# e	blue
# f	magenta
# g	cyan
# h	light grey
# CAPITAL	(BOLD)
# x	default

alias ls='ls -G'


## COLORS FOR TERMINAL
# Regular
txtblk="$(tput setaf 0 2>/dev/null || echo '\e[0;30m')"  # Black
txtred="$(tput setaf 1 2>/dev/null || echo '\e[0;31m')"  # Red
txtgrn="$(tput setaf 2 2>/dev/null || echo '\e[0;32m')"  # Green
txtylw="$(tput setaf 3 2>/dev/null || echo '\e[0;33m')"  # Yellow
txtblu="$(tput setaf 4 2>/dev/null || echo '\e[0;34m')"  # Blue
txtpur="$(tput setaf 5 2>/dev/null || echo '\e[0;35m')"  # Purple
txtcyn="$(tput setaf 6 2>/dev/null || echo '\e[0;36m')"  # Cyan
txtwht="$(tput setaf 7 2>/dev/null || echo '\e[0;37m')"  # White

# Bold
bldblk="$(tput setaf 0 2>/dev/null)$(tput bold 2>/dev/null || echo '\e[1;30m')"  # Black
bldred="$(tput setaf 1 2>/dev/null)$(tput bold 2>/dev/null || echo '\e[1;31m')"  # Red
bldgrn="$(tput setaf 2 2>/dev/null)$(tput bold 2>/dev/null || echo '\e[1;32m')"  # Green
bldylw="$(tput setaf 3 2>/dev/null)$(tput bold 2>/dev/null || echo '\e[1;33m')"  # Yellow
bldblu="$(tput setaf 4 2>/dev/null)$(tput bold 2>/dev/null || echo '\e[1;34m')"  # Blue
bldpur="$(tput setaf 5 2>/dev/null)$(tput bold 2>/dev/null || echo '\e[1;35m')"  # Purple
bldcyn="$(tput setaf 6 2>/dev/null)$(tput bold 2>/dev/null || echo '\e[1;36m')"  # Cyan
bldwht="$(tput setaf 7 2>/dev/null)$(tput bold 2>/dev/null || echo '\e[1;37m')"  # White

# Underline
undblk="$(tput setaf 0 2>/dev/null)$(tput smul 2>/dev/null || echo '\e[4;30m')"  # Black
undred="$(tput setaf 1 2>/dev/null)$(tput smul 2>/dev/null || echo '\e[4;31m')"  # Red
undgrn="$(tput setaf 2 2>/dev/null)$(tput smul 2>/dev/null || echo '\e[4;32m')"  # Green
undylw="$(tput setaf 3 2>/dev/null)$(tput smul 2>/dev/null || echo '\e[4;33m')"  # Yellow
undblu="$(tput setaf 4 2>/dev/null)$(tput smul 2>/dev/null || echo '\e[4;34m')"  # Blue
undpur="$(tput setaf 5 2>/dev/null)$(tput smul 2>/dev/null || echo '\e[4;35m')"  # Purple
undcyn="$(tput setaf 6 2>/dev/null)$(tput smul 2>/dev/null || echo '\e[4;36m')"  # Cyan
undwht="$(tput setaf 7 2>/dev/null)$(tput smul 2>/dev/null || echo '\e[4;37m')"  # White

# Background
bakblk="$(tput setab 0 2>/dev/null || echo '\e[40m')"  # Black
bakred="$(tput setab 1 2>/dev/null || echo '\e[41m')"  # Red
bakgrn="$(tput setab 2 2>/dev/null || echo '\e[42m')"  # Green
bakylw="$(tput setab 3 2>/dev/null || echo '\e[43m')"  # Yellow
bakblu="$(tput setab 4 2>/dev/null || echo '\e[44m')"  # Blue
bakpur="$(tput setab 5 2>/dev/null || echo '\e[45m')"  # Purple
bakcyn="$(tput setab 6 2>/dev/null || echo '\e[46m')"  # Cyan
bakwht="$(tput setab 7 2>/dev/null || echo '\e[47m')"  # White

# Reset
txtrst="$(tput sgr 0 2>/dev/null || echo '\e[0m')" # Text Reset

parse_git_branch(){
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \[\1\]/'
}

PS1="☕ \[$txtblu\]\u\[$txtred\] :: \[$txtgrn\]\[$txtylw\]\w\[$txtgrn\]\$(parse_git_branch)$DEFAULT \n \$ "
