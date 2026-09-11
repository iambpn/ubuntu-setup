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

## What to expect

After a clean run, on top of the base Ubuntu install you'll have:

- **Terminal**: Alacritty + Zellij, Tokyo Night theme, CaskaydiaMono Nerd
  Font (JetBrainsMono Nerd Font also installed), Starship prompt (path +
  git only, no user@host).
- **Shell**: a `config/shell/rc.bash` snippet sourced from `~/.bashrc`,
  which also sets the terminal title so Zellij pane names stay useful.
- **Git**: your global `~/.gitconfig` in place, with `delta` as the diff
  pager.
- **Dev tools**: VS Code, Docker Engine + Buildx + Compose (your user added
  to the `docker` group), `proto` (moonrepo's toolchain manager), and
  `lazydocker`.
- **Apps**: Google Chrome, LocalSend, and Flatpak apps from Flathub (Zen
  Browser, Flatseal, PortProton).
- **TUI tools**: `btop` and `lazygit`, each with an app-grid launcher that
  opens them in a terminal window.
- **GNOME tweaks**: Hide Top Bar and TopHat extensions, Flameshot
  (Super+Shift+S) and Pufferfish clipboard history (Super+V) with their
  keyboard shortcuts wired up, Zen Browser pinned to the dash, and the top
  bar clock set to show weekday and date (e.g. "Fri Sep 11 11:04 PM").

Nothing here is destructive to unrelated system state — each script only
touches the files and settings it owns, and backs up any real config file
it would otherwise overwrite. Log out and back in once it's done so the
Docker group, GNOME extension, and shell profile changes take effect.
