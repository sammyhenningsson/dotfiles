# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A set of bash scripts for managing dotfiles via symlinks. Files in `files/` are the canonical source of truth; installing a dotfile creates a symlink from `~/.<name>` → `files/<name>`, so edits via either path update the repo file directly.

## Commands

```sh
dotfiles install [target_dir] [file[:targetname] ...]   # Link files into target_dir (default: $HOME)
dotfiles uninstall [target_dir] [file[:targetname] ...]  # Remove links and restore plain copies
dotfiles reset [target_dir] [file1|file2|..]             # Discard local changes (interactive)
dotfiles update                                           # git pull (symlinks survive pulls automatically)
dotfiles status                                           # Show which files are linked vs unlinked
```

The `file:targetname` syntax lets you install a file under a non-default name, e.g. `dotfiles install gitconfig:.gitconfig_work`.

`bin/dotfiles` must be on `$PATH` (or called directly) to use these commands.

## Architecture

```
files/                   # Canonical dotfile content (committed, symlinked from $HOME)
config                   # Install log: "<sourcename> <target_path>" per line (gitignored, machine-local)
lib/                     # One bash function file per subcommand (install, uninstall, reset, update, status)
lib/common.sh            # Shared: FILES_DIR, CONFIG_FILE, usage(), get_script(), process_args(),
                         #         check_migration(), target_name(), config_add(), config_remove(), config_targets()
bin/dotfiles             # Entry point: sources common.sh, dispatches to lib/<command>
bin/migrate-to-symlinks  # One-time migration from hard links to symlinks
```

**Symlink mechanics:** `install` creates a symlink at the target pointing to `files/<name>`. `uninstall` removes the symlink and leaves a plain copy at the target. `update` just runs `git pull` — symlinks survive pulls since they track paths, not inodes. `reset` runs `git checkout` — symlinks auto-reflect the reset file.

**Migration:** Repos previously using hard links must run `migrate-to-symlinks` once before using any `dotfiles` command. The main entry point checks for residual hard links and errors with a clear message if migration is needed.

**Config file:** `config` records every installed path as `<sourcename> <target_path>`. It is machine-local (gitignored) and is read by `uninstall` and `status` to find where files are linked. One source file can have multiple lines (linked into multiple directories).

## Adding a new dotfile

1. Add the file to `files/` (named without the leading dot).
2. Run `dotfiles install` to link it.
3. Commit `files/<name>`.
