# The `.wryn` Library

A compilation of utilities which I use across my machines.
This library represents my lifelong efforts to create a custom, streamlined IDE based on the terminal and terminal-based editors.

So I suppose here is the disclaimer: **this repo is principally for personal utility**.
Although I try to build utilities to be dependency aware, the library is considered to be in a good state when it works on my machine.
Feel free to use or adapt anything you find useful :)

## File Structure Breakdown
### [bin](./bin)
Program-specific shell utilities used throughout configurations and other `zsh` scripts.
These utilities are not used directly by the user and are **not** sourced to the user RC.

### [config](./config)
Configuration files which are typically symlinked to the `~/.config` directory.

### [env](./env)
Default environment variables used by library utilities.
Overrides can be set on each machine by editing the appropriate local environment in `~/.config/wryn/`.

### [freeze](./freeze)
A historical list of packages used on personal machines.
Also contains machine-specific `systemd` daemons for managing hardware-specific issues.

### [latex](./latex)
A compilation of LaTeX templates, used by the [`.wryn/zsh/latex`](./zsh/latex) utility.

Each template is composed of four files: `template.tex`, `body.tex`, `imports.sty`, and `formatting.sty`.
The `template.tex` file is the parent of the document, and thus the target of the latex compiler.
This can be renamed to match the document title, but typically does not contain the document body.
Every template will use the same parent `template.tex` file, so this is found at the `~/.wryn/latex` directory root.

### [resume](./resume)
My working resume in `.tex` format.

### [vim](./vim)
Contains keybindings, dictionary binary, and custom plugins for `vim`.

The [`setup`](./setup) utility will source the `.wryn/vim/rc.vim` and set up all necessary environment variables.
Local environment overrides are placed in `~/.config/wryn/env/env.vim`.

### [zsh](./zsh)
Contains `zsh` aliases and functions used directly by a terminal user.
The [`.wryn/zsh/rc`](./zsh/rc), which loads the custom `zsh` modules is sourced directly from the user RC.
Any OS specific utilities are nested in appropriately named directories.

The [`setup`](./setup) utility will source the `.wryn/zsh/rc` and set up all necessary environment variables.
Local environment overrides are placed in `~/.config/wryn/env/env`.
