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
$DOTWRYN/bin/i3-utils                         i3/utils
$DOTWRYN/colorschemes/kitty.main              kitty/theme.conf
$DOTWRYN/config/bat.conf                      bat/config
$DOTWRYN/config/code-activator.conf           code-activator-zsh/settings.zsh
$DOTWRYN/config/compton.conf                  compton/compton.conf
$DOTWRYN/config/git.conf                      git/config
$DOTWRYN/config/htop.conf                     htop/htoprc
$DOTWRYN/config/i3.conf                       i3/config
$DOTWRYN/config/i3status.conf                 i3status/config
$DOTWRYN/config/kitty.conf                    kitty/kitty.conf
$DOTWRYN/config/mssqlcli.conf                 mssqlci/config
$DOTWRYN/config/pgcli.conf                    pgcli/config
$DOTWRYN/config/pylint.conf                   pylintrc
$DOTWRYN/config/ripgrep.conf                  ripgrep/config
$DOTWRYN/config/scwrypts/config               scwrypts/config
$DOTWRYN/config/scwrypts/dotfiles.zsh         scwrypts/dotfiles.zsh
$DOTWRYN/config/scwrypts/env/local            scwrypts/env/local
$DOTWRYN/config/scwrypts/env/local.altaria    scwrypts/env/local.altaria
$DOTWRYN/config/scwrypts/env/local.butterfree scwrypts/env/local.butterfree
$DOTWRYN/config/scwrypts/env/local.umbreon    scwrypts/env/local.umbreon
$DOTWRYN/config/scwrypts/vundle.zsh           scwrypts/vundle.zsh
$DOTWRYN/config/tmux.conf                     tmux/tmux.conf
$DOTWRYN/config/xcompose.conf                 X11/xcompose
$DOTWRYN/config/xconfig.conf                  X11/xconfig
$DOTWRYN/config/xinitrc                       X11/xinitrc
$DOTWRYN/bin/scwrypts                         ../.local/bin/scwrypts
$DOTWRYN/bin/vim                              ../.local/bin/vim
$DOTWRYN/bin/$(hostnamectl --static)          ../.$(hostnamectl --static)
"
