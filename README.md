# ubuntu-setup

My personal Ubuntu setup. Meant to be run once on a fresh Ubuntu LTS 26
install to put on the software and settings I use daily. Most of it is
adapted from [omabuntu](../omabuntu).

## Layout

- `install.sh` — runs every script in `install/` in order.
- `install/` — one script per tool. Each is safe to re-run and skips work
  that is already done. You can run any of them on their own.
- `uninstall.sh` / `uninstall/` — the reverse, one script per tool.
- `config/` — the actual config files (Alacritty, Zellij, GNOME
  extensions and shortcuts). The install scripts symlink or apply these.

## Usage

```sh
./install.sh
```

It needs `sudo` and takes a while. Log out and back in afterwards so the
Docker group, GNOME extension changes, and shell profile edits take effect.

To remove things again:

```sh
./uninstall.sh
```
