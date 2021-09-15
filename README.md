# The `.wryn` Library

A compilation of utilities which I use across my machines **this repo is principally for personal utility**.
Although I try to build utilities to be dependency aware, the library is considered to be in a good state when it works on my machine.

Feel free to use or adapt anything you find useful :)

## File Structure Breakdown
### [setup](./setup)
The pride and joy of this project.
Running the script will set up the appropriate links and RC entries to enable the entire library.

Relatively robust, but always works best the OS I'm currently using (arch).

### [config](./config)
Configuration files / utilities.
The setup script handles all the headache of symlinking each one to the right place.

### [env](./env)
Default configuration used by the rest of the library.
You can override the environment by editing `~/.config/wryn/env` files after running setup.

### [resume](./resume)
My working resume in `.tex` format.

### [latex](./latex)
A compilation of LaTeX templates, used by the [`.wryn/zsh/latex`](./zsh/latex) utility.

Each template is composed of four files: `template.tex`, `body.tex`, `imports.sty`, and `formatting.sty`.
The `template.tex` file is the parent of the document, and thus the target of the latex compiler.
This can be renamed to match the document title, but typically does not contain the document body.
Every template will use the same parent `template.tex` file, so this is found at the `~/.wryn/latex` directory root.

### [vim](./vim)
Contains keybindings, dictionary binary, and custom plugins for `vim`.

### [zsh](./zsh)
Contains (a mess of) `zsh` aliases and functions used directly by a terminal user.
The [`.wryn/zsh/rc`](./zsh/rc), which loads the custom `zsh` modules is sourced directly from the user RC.
Any OS specific utilities are nested in appropriately named directories.
...this will be hacked to pieces very soon

### [freeze](./freeze)
A historical list of packages used on personal machines.
Also contains machine-specific `systemd` daemons for managing hardware-specific issues.
...this will likely move to a cloud storage soon.
