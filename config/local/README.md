# config : host-overrides

Currently an in-progress migration from the name "local" to "host-overrides."

I recently identified the need for a distinction between "a machine-distinct setting" which should still be tracked and a "one-off hack, or temporary local detail" which is NOT tracked.

The new general configuration hierarchy, from most general to highest precedence, is then:
- The primary application configuration (e.g. `config/user` or `config/etc` in this repository)
- The host-level overrides / additions  (e.g. _this folder_)
- The local overrides

## Migration Notes

Where possible, it's better to use a unique, descriptive name, but in some situations we have a clear hierarchy linked within a specific application's configuration folder.
Old files tend to be called or linked to places with the name "local.{extension}," but new files in this directory should now prefer the terminology `host`.
For example:
```
# OLD NAME                          ->   NEW NAME
pikachu/user/alacritty/local.toml   ->   pikachu/user/alacritty/host.toml
```
