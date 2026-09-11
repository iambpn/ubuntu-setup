# ubuntu-setup

My personal Ubuntu setup. Meant to be run once on a fresh Ubuntu LTS 26
install to put on the software and settings I use daily. Most of it is
adapted from [omabuntu](../omabuntu).

## Layout

- `install.sh` — runs every script in `install/` in order.
- `install/` — one script per tool. Each is safe to re-run and skips work
  that is already done. You can run any of them on their own.
- `uninstall.sh` / `uninstall/` — the reverse, one script per tool.
- `config/` — the actual config files (Alacritty, Zellij, Starship, the
  bash rc snippet, git config, proto's `.prototools`, GNOME extensions and
  shortcuts). The install scripts symlink or apply these.

## Usage

Clone this repo into `$HOME/.ubuntu-setup`:

```sh
git clone <repo-url> "$HOME/.ubuntu-setup"
cd "$HOME/.ubuntu-setup"
```

Then run:

```sh
sudo -v && ./install.sh
```

Run it as your normal user, **not** with `sudo ./install.sh`. Each step
that needs root calls `sudo` itself; running the whole script as root puts
files in the wrong home and breaks the GNOME settings steps.

`sudo -v` just caches your password up front so the run doesn't stop at the
first prompt. You may still be asked again during a long run once the cache
expires.

It takes a while. Log out and back in afterwards so the Docker group, GNOME
extension changes, and shell profile edits take effect.

To remove things again:

```sh
./uninstall.sh
```
