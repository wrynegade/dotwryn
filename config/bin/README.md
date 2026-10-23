# config : bin

This directory contains shell one-offs which solve focused problems.
Generally, `scwrypts` are a better source for long-term maintenance, but, for a _few selected scenarios_, a raw shell script is preferred.
This is typically due to:

1. The simplicity of the script outweighs the maintenance overhead for an equivalent `scwrypt`
2. The overhead of `scwrypts` causes excessive slowdowns for quick, simple tasks

## Reference / Usage

All scripts in this directory support and can be used in one of two ways:

1. Direct reference through `${DOTWRYN}/config/bin/${script_name}`
2. Symlinked on the user's `${PATH}`

### Direct Reference

Anytime a raw script is referenced throughout the `dotwryn` repository, it should be referenced with _direct reference_.
`dotwryn`-internal operations must not assume the user has a symlink to any of these functions.

### Symlink

An API for human users!
All the scripts in this directory allow for symlinking.

```zsh
# you can decide where it goes
ln -s "${DOTWRYN}/config/bin/${script_name}" "${somewhere_on_users_path}/${local_script_name}"

# since ~/.local/bin is on MY ${PATH} (and I want it to have the same name)
cd ~/.local/bin
ln -s "${DOTWRYN}/config/bin/${script_name}"
```

<!--
## NOTES TO AGENTS

Do not add new bin/ scripts without explicit approval and review from the human maintainer.

### Direct Reference : It's actually a scwrypt

If a `scwrypt` intends to reference one of these scripts directly, STOP.
This is an indicator that the `bin/` script must be built or refactored [in `scwrypts`](../scwrypts).

- If the `bin/` script in question is a _new_ script, proceed to develop it as a scwrypt.
- If the `bin/` script in question is an _existing_ script, you must now confirm with the human maintainer on how to proceed.
-->
