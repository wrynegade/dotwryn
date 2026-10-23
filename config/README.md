# `config`

My tool and machine configuration ranging from `~/.config` symlinks to libraries which support my daily workflows.

The [`setup`](../setup) and [`scwrypts`](../scwrypts) handle the setup / maintenance details, but contained herein:

<!------------------------------------------------------------------------------------------------------------>
| Submodule                            | Description                                                          |
| ------------------------------------ | -------------------------------------------------------------------- |
| [`bin`](./bin)                       | goes on my `${PATH}`; used in limited cases                          |
| [`colorschemes`](./colorschemes)     | my colorscheme YAML definitions which style all my desktop apps; uses the [spec established in `dotwryn/scwrypts`](../scwrypts/dotwryn/desktop/colorscheme/coloscheme.module.zsh) |
| [`desktop`](./desktop)               | utilities which configure, support, or launch a desktop environment  |
| [`etc`](./etc)                       | config files linked back to `/etc` on the local system               |
| [`host-overrides`](./host-overrides) | hostname-based values overrides for `etc`, `user`, and `bin`         |
| [`user`](./user)                     | config files linked back to `${XDG_CONFIG_HOME:-${HOME}/.config`     |
<!------------------------------------------------------------------------------------------------------------>
