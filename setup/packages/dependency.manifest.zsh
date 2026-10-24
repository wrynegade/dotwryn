#####################################################################

# current profiles:
#   --extended (default) -> installs all my favorite tools
#   --min                -> only installs essentials (deemed by ME)

INSTALLED_BY__all=(--installed-by 'default,min,extended-macos-cask')
INSTALLED_BY__extended=(--installed-by 'default,extended-macos-cask')
INSTALLED_BY__extended_macos_cask=(--installed-by 'extended-macos-cask')

#####################################################################

# base cross-platform tools
dependency_args=("${INSTALLED_BY__all[@]}")

dependency --no-executable binutils
dependency --no-executable coreutils
dependency --no-executable findutils
dependency --no-executable libtool

dependency autoconf   --yay base-devel
dependency automake   --yay base-devel
dependency awk        --yay base-devel    --dnf gawk  --apt-get gawk                                    --brew gawk
dependency aws        --yay aws-cli-v2    --dnf awscli2         --apt-get awscli          --brew awscli
dependency bat --no-executable
dependency bison      --yay base-devel
dependency cmake
dependency cowsay
dependency figlet
dependency file
dependency flex       --yay base-devel
dependency fzf
dependency gcc        --yay base-devel    --dnf gcc,gcc-c++     --apt-get build-essential
dependency gpg        --yay gnupg         --dnf gnupg2          --apt-get gnupg           --brew gnupg
dependency grep
dependency htop
dependency ip         --yay iproute2      --dnf iproute         --apt-get iproute2        --brew iproute2mac
dependency jo
dependency jq
dependency lolcat
dependency ncurses                                              --apt-get libncurses-dev --no-executable
dependency ssh        --yay openssh       --dnf openssh-clients --apt-get openssh-client  --brew openssh
dependency patch                                                                          --brew gpatch
dependency pkg-config --yay base-devel
dependency pylint     --yay python-pylint
dependency python3    --yay python        --dnf python3-devel   --apt-get python3-dev     --brew python-setuptools
dependency rg         --yay ripgrep       --dnf ripgrep         --apt-get ripgrep         --brew ripgrep
dependency sed                                                                            --brew gsed
dependency tmux
dependency vim                            --dnf vim-enhanced
dependency xauth      --yay xorg-xauth    --dnf xorg-x11-xauth  --apt-get xauth
dependency yamllint
dependency yq         --yay go-yq --not-on apt-get
dependency zip
dependency zsh

# not packaged for fedora/debian
dependency --only-on yay,brew rage            --yay rage-encryption
dependency --only-on yay,brew zsh-completions --no-executable

#####################################################################

# extended cross-platform tools
dependency_args=("${INSTALLED_BY__extended[@]}")

dependency alacritty                                                                                                   --brew cask:alacritty
dependency docker                             --dnf docker-ce,docker-ce-cli,containerd.io                              --brew colima
dependency go                                                                             --apt-get golang
dependency java       --yay jdk-openjdk       --dnf java-latest-openjdk                   --apt-get default-jdk        --brew openjdk
dependency javac      --yay jdk-openjdk       --dnf java-latest-openjdk                   --apt-get default-jdk        --brew openjdk
dependency mono                               --dnf mono-complete                         --apt-get mono-devel
dependency redis-cli  --yay redis             --dnf valkey,valkey-compat-redis
dependency rustc      --yay rustup            --dnf rust                                  --apt-get rustc              --brew rust
dependency virtualenv --yay python-virtualenv --dnf python3-virtualenv                    --apt-get python3-virtualenv

# fedora & debian need official repositories added to dnf / apt (not yet supported)
dependency --only-on yay,brew 1password                     --brew cask:1password
dependency --only-on yay,brew op        --yay 1password-cli --brew cask:1password-cli

#####################################################################

# linux
dependency_args=("${INSTALLED_BY__all[@]}" --only-on yay,dnf,apt-get)

dependency noto-fonts-emoji --dnf google-noto-emoji-fonts --apt-get fonts-noto-color-emoji --no-executable

dependency feh
dependency fprintd --no-executable
dependency ntp                      --dnf chrony      --apt-get chrony --no-executable
dependency pip     --yay python-pip --dnf python3-pip --apt-get python3-pip
dependency sudo
dependency uuidgen --yay util-linux --dnf util-linux  --apt-get uuid-runtime
dependency which
dependency xclip
dependency xdotool

#######################

# linux extended
dependency_args=("${INSTALLED_BY__extended[@]}" --only-on yay,dnf,apt-get)

dependency brave           --yay brave-bin
dependency flameshot
dependency google-chrome   --yay google-chrome-stable
dependency i3              --yay i3-wm                             --apt-get i3-wm
dependency lxappearance
dependency node            --yay nodejs               --dnf nodejs --apt-get nodejs
dependency npm
dependency obs-studio
dependency picom
dependency playerctl
dependency polybar
dependency rofi

dependency --no-executable otf-monaspace
dependency --no-executable ttf-nerd-fonts-symbols

#######################

# arch linux extended
dependency_args=("${INSTALLED_BY__extended[@]}" --only-on yay)

# hyprland stack (not available through default dnf/apt-get repositories at the moment)
dependency grim
dependency hyprlock
dependency hyprpaper
dependency qs              --yay quickshell
dependency start-hyprland  --yay hyprland
dependency wl-copy         --yay wl-clipboard
dependency xdg-desktop-portal-hyprland --no-executable

##########################################

# arch linux
dependency_args=("${INSTALLED_BY__all[@]}" --only-on yay)

dependency arch-install-scripts --no-executable
dependency python-rtmidi --no-executable

dependency scwrypts
dependency unipicker

##########################################

# debian linux
dependency_args=("${INSTALLED_BY__all[@]}" --only-on apt-get)

dependency bsdextrautils --no-executable

#####################################################################

# macos
dependency_args=("${INSTALLED_BY__all[@]}" --only-on brew)

#######################

# macos extended cask
dependency_args=("${INSTALLED_BY__extended_macos_cask[@]}" --only-on brew)

dependency brave         --brew cask:brave-browser
dependency google-chrome --brew cask:google-chrome
dependency obs-studio    --brew cask:obs
dependency xquartz       --brew cask:xquartz

#####################################################################
unset \
	dependency_args \
	INSTALLED_BY__all INSTALLED_BY__extended INSTALLED_BY__extended_macos_cask \
	;
