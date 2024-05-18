#
# scwrypts dot-files config
#

TERMINFO_PATH="$DOTWRYN/config/terminfo"
SAFE_SYMLINKS=0

# lines which begin with '#' are ignored
SYMLINKS="
# --------------------------------------------------------------------------
# fully qualified path                       ~/.config/THE-REST
# --------------------------------------------------------------------------
$DOTWRYN/bin/i3-utils                             i3/utils
$DOTWRYN/colorschemes/active/kitty.conf           kitty/theme.conf
$DOTWRYN/colorschemes/active/alacritty.toml       alacritty/theme.toml
$DOTWRYN/colorschemes/active/alacritty.yaml       alacritty/theme.yml
$DOTWRYN/config/alacritty.toml                    alacritty/alacritty.toml
$DOTWRYN/config/alacritty.default.toml            alacritty/default.toml
$DOTWRYN/config/alacritty.yaml                    alacritty/alacritty.yml
$DOTWRYN/config/bat.conf                          bat/config
$DOTWRYN/config/code-activator.conf               code-activator-zsh/settings.zsh
$DOTWRYN/config/compton.conf                      compton/compton.conf
$DOTWRYN/config/git.conf                          git/config
$DOTWRYN/config/htop.conf                         htop/htoprc
$DOTWRYN/config/i3status.conf                     i3status/config
$DOTWRYN/config/kitty.conf                        kitty/kitty.conf
$DOTWRYN/config/mssqlcli.conf                     mssqlci/config
$DOTWRYN/config/pgcli.conf                        pgcli/config
$DOTWRYN/config/polybar.ini                       polybar/config.ini
$DOTWRYN/config/pylint.conf                       pylintrc
$DOTWRYN/config/ripgrep.conf                      ripgrep/config
$DOTWRYN/config/scwrypts/config.zsh               scwrypts/config.zsh
$DOTWRYN/config/scwrypts/dotfiles.zsh             scwrypts/dotfiles.zsh
$DOTWRYN/config/scwrypts/vundle.zsh               scwrypts/vundle.zsh
$DOTWRYN/config/tmux.conf                         tmux/tmux.conf
$DOTWRYN/config/xcompose.conf                     X11/xcompose
$DOTWRYN/config/xconfig.conf                      X11/xconfig
$DOTWRYN/config/xinitrc.i3                        ../.xinitrc
$DOTWRYN/config/xinitrc.i3                        X11/xinitrc
$DOTWRYN/bin/vim                                  ../.local/bin/vim
$DOTWRYN/bin/$(hostnamectl --static)              ../.$(hostnamectl --static)

$( () {
	local SOURCE_CONTROLLED_GROUPS=(dotwryn remote scwrypts)
	local GROUP_MATCH_STRING="\\($(printf '\|%s' ${SOURCE_CONTROLLED_GROUPS[@]} | sed 's/^\\|//')\\)"

	local _LOCAL='scwrypts/environments'
	local _DOTWRYN="$DOTWRYN/config/scwrypts/environments"

	find "$HOME/.config/$_LOCAL" -mindepth 1 -maxdepth 1 -name \*.env.yaml \
		| sed -n "s^.*/\(local\(\.[^.]\+\)\{0,\}\.$GROUP_MATCH_STRING.env.yaml\)$$_DOTWRYN/\1^$_LOCAL/\1p" \
		| grep -v '\.secret\.' \
		| sort --unique \
		| column -ts '^' \
		;
} )
"
