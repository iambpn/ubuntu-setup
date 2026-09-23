# Git configuration

`install/git.sh` links this configuration to `~/.gitconfig` and the `hooks/`
directory to `~/.config/git/hooks`.

`hooks/post-checkout` handles the worktree creation check. It runs
`hooks/post-checkout.d/copy-env.sh` for every new worktree.

## Worktree `.env` hook

The `hooks/post-checkout` hook copies `.env` into a newly created worktree.
It uses the all-zero previous commit passed by `git worktree add` to distinguish
worktree creation from a normal branch or file checkout.

The hook follows these steps:

1. Ignore normal checkouts and branch switches.
2. Stop if the new worktree already has an `.env` file or symlink.
3. For a bare repository, first look for `.env` in the bare repository itself.
4. Search the other registered worktrees in order and use the first `.env`
   found. In a non-bare repository, the main worktree is normally first.
5. Copy the selected `.env` into the new worktree.

If no `.env` is found, the hook does nothing. It uses Git's null-delimited
worktree output so paths containing spaces or special characters are handled
correctly.

### Non-bare repository

```text
project/
├── .git/
├── .env                 source
└── source files

project-feature/
└── .env                 copied by the hook
```

### Bare repository

The bare repository is the preferred source:

```text
project.git/
├── HEAD
├── objects/
└── .env                 preferred source

project-feature/
└── .env                 copied by the hook
```

If `project.git/.env` does not exist, the hook uses the first registered
worktree containing `.env`:

```text
project.git/

project-main/
└── .env                 fallback source

project-feature/
└── .env                 copied by the hook
```
