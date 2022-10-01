# The `.wryn` Library
My collection of configurations and plugins.

## Builds
[![CircleCI](https://dl.circleci.com/status-badge/img/gh/wrynegade/dotwryn/tree/main.svg?style=shield)](https://dl.circleci.com/status-badge/redirect/gh/wrynegade/dotwryn/tree/main)
<br>
I automatically build my utilities into the [`blaziken734/debugger`](https://hub.docker.com/r/blaziken734/debugger).
This serves as CI/CD for the ZSH library and a convenient, root-privileged container for debugging in containerized environments.

## Setup / Configuration
The setup script is the pride and joy of this project.
Running an [interactive installer](./setup/linux) removes the hassle of setting up a new computer by configuring symlinks, installing applications, and synchronizing media with the cloud.

After running the setup, [default configurations](./env) can be overridden by editing the appropriate local configuration (`~/.config/wryn/env`).

## System Breakdown
`.wryn/MODULE`                  | Description
------------------------------- | --------------------------------------
[setup/](./setup)               | os-specific setup / update utilities
[colorschemes/](./colorschemes) | 16-color terminal colorschemes; see [colors](./zsh/colors) to see how these are loaded
[config/](./config)             | general configuration; appropriate `~/.config` files are symlinked on setup
[resume/](./resume)             | my working resume in `.tex` format
[vim/](./vim)                   | `vim` keybindings, plugins, and dictionary binary; activated by an [entry rc](./vim/rc.vim)
[zsh/](./zsh)                   | `zsh` aliases, functions, and plugins; activated by an [entry rc](./zsh/rc)
[zsh/plugins](./zsh/plugins)    | external `zsh` plugins
