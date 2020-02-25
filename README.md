# The `.wryn` Directory

This is a compilation of utilities which I use across machines.
I expect this to be a lifelong struggle to get everything to work the second that I'm on a new machine, but I have yet to have a flawless transfer from one machine to the next.
Despite my failures (so far) in a *perfect* transfer installation, I have found this project to have sped up my transferring between machines immensely.
When I'm working on multiple machines, a simple `git pull` will keep all of my shell and VI scripts in sync.

So I suppose here is the disclaimer: **this repo is principally for personal utility**.
Sometimes there are local machine dependencies which will cause (particularly setup) utilities to fail.
Feel free to use or adapt anything you find useful, just leave credit where credit is due :)

## File Structure Breakdown

Here's a little breakdown of what each directory may contain (in no particular order).

### [bash](./bash)
It contains `bash` aliases and functions which might be placed in a `~/.bashrc` to be called from the command line.
I have found it personally useful to break these out into topical groupings or modules.

All modules which are found directly within `.wryn/bash` will be loaded across all operating systems, while specific operating systems architectures will each have their own specified modules (e.g. [`~/.wryn/bash/linux`](./bash/linux) or [`~/.wryn/bash/osx`](./bash/osx)).

### [zsh](./zsh)
Just like [`.wryn/bash`](./bash) but for ZSH.
Currently, I'm using ZSH, so these utilities may be more up-to-date than those found in `~/.wryn/bash`

### [config](./config)
These are all the sort of files you would expect to find in your `~/.config` directory.
In fact, the [`~/.wryn/setup`](./setup) script is designed to symlink relevant files to your local `~/.config` directory.

### [latex](./latex)
This directory contains my TeX templates.
There are shell utilities which facilitate their copying for general use.


### [systemd-utils](./systemd-utils)
I started this directory when I installed Arch Linux on a late 2013 macbook pro.
Currently these are daemons designed to help fix hardware issues with that machine.

### [vim](./vim)
This contains all my custom keybindings and vim-scripts.
There is also an installer which pulls down and builds (or rebuilds) the few external plugins which I use with VI.

### [bin](./bin)
I try to keep [`.wryn/bin`](./bin) compatible with SH.
These are my non-sourced shell utilities.

### [env](./env)
[`.wryn/setup`](./setup) will link these environment variables to your local machine's shell and vim environments.
This is so directories in respective shell/vim modules are not hard-coded to any particular machine.
The indicated variables should be modified if they cannot be found in the prescribed directory.

### [new_computer_setup](./new_computer_setup)
Now that I'm writing this, it occurs to me this may be a misnomer.
It is actually a historical log of system and python packages I have installed on previous machines.

### [tmux](./tmux)
Contains tmux configuration files for keybindings, status bar settings, etc.
