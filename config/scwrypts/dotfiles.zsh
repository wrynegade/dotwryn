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
$DOTWRYN/colorschemes/active.main                 kitty/theme.conf
$DOTWRYN/colorschemes/active.main.alacritty       alacritty/theme.toml
$DOTWRYN/colorschemes/active.main.alacritty.yml   alacritty/theme.yml
$DOTWRYN/colorschemes/active.main.getty           wryn/tty-colorscheme
$DOTWRYN/config/alacritty.toml                    alacritty/alacritty.toml
$DOTWRYN/config/alacritty.yaml                    alacritty/alacritty.yml
$DOTWRYN/config/bat.conf                          bat/config
$DOTWRYN/config/code-activator.conf               code-activator-zsh/settings.zsh
$DOTWRYN/config/compton.conf                      compton/compton.conf
$DOTWRYN/config/git.conf                          git/config
$DOTWRYN/config/htop.conf                         htop/htoprc
$DOTWRYN/config/i3.conf                           i3/config
$DOTWRYN/config/i3status.conf                     i3status/config
$DOTWRYN/config/kitty.conf                        kitty/kitty.conf
$DOTWRYN/config/mssqlcli.conf                     mssqlci/config
$DOTWRYN/config/pgcli.conf                        pgcli/config
$DOTWRYN/config/pylint.conf                       pylintrc
$DOTWRYN/config/ripgrep.conf                      ripgrep/config
$DOTWRYN/config/scwrypts/config.zsh               scwrypts/config.zsh
$DOTWRYN/config/scwrypts/dotfiles.zsh             scwrypts/dotfiles.zsh
$DOTWRYN/config/scwrypts/vundle.zsh               scwrypts/vundle.zsh
$DOTWRYN/config/tmux.conf                         tmux/tmux.conf
$DOTWRYN/config/xcompose.conf                     X11/xcompose
$DOTWRYN/config/xconfig.conf                      X11/xconfig
$DOTWRYN/config/xinitrc.i3                        X11/xinitrc
$DOTWRYN/config/xinitrc.i3                        ../.xinitrc
$DOTWRYN/bin/scwrypts                             ../.local/bin/scwrypts
$DOTWRYN/bin/vim                                  ../.local/bin/vim
$DOTWRYN/bin/$(hostnamectl --static)              ../.$(hostnamectl --static)

$DOTWRYN/config/scwrypts/environments/scwrypts/local            scwrypts/environments/scwrypts/local
$DOTWRYN/config/scwrypts/environments/scwrypts/local.altaria    scwrypts/environments/scwrypts/local.altaria
$DOTWRYN/config/scwrypts/environments/scwrypts/local.blaziken   scwrypts/environments/scwrypts/local.blaziken
$DOTWRYN/config/scwrypts/environments/scwrypts/local.butterfree scwrypts/environments/scwrypts/local.butterfree
$DOTWRYN/config/scwrypts/environments/scwrypts/local.gardevoir  scwrypts/environments/scwrypts/local.gardevoir
$DOTWRYN/config/scwrypts/environments/scwrypts/local.umbreon    scwrypts/environments/scwrypts/local.umbreon
$DOTWRYN/config/scwrypts/environments/dotwryn/local             scwrypts/environments/dotwryn/local
$DOTWRYN/config/scwrypts/environments/dotwryn/local.altaria     scwrypts/environments/dotwryn/local.altaria
$DOTWRYN/config/scwrypts/environments/dotwryn/local.blaziken    scwrypts/environments/dotwryn/local.blaziken
$DOTWRYN/config/scwrypts/environments/dotwryn/local.butterfree  scwrypts/environments/dotwryn/local.butterfree
$DOTWRYN/config/scwrypts/environments/dotwryn/local.gardevoir   scwrypts/environments/dotwryn/local.gardevoir
$DOTWRYN/config/scwrypts/environments/dotwryn/local.umbreon     scwrypts/environments/dotwryn/local.umbreon
$DOTWRYN/config/scwrypts/environments/remote/local			    scwrypts/environments/remote/local
$DOTWRYN/config/scwrypts/environments/remote/local.altaria      scwrypts/environments/remote/local.altaria
$DOTWRYN/config/scwrypts/environments/remote/local.blaziken     scwrypts/environments/remote/local.blaziken
$DOTWRYN/config/scwrypts/environments/remote/local.butterfree   scwrypts/environments/remote/local.butterfree
$DOTWRYN/config/scwrypts/environments/remote/local.gardevoir    scwrypts/environments/remote/local.gardevoir
$DOTWRYN/config/scwrypts/environments/remote/local.umbreon      scwrypts/environments/remote/local.umbreon
"
