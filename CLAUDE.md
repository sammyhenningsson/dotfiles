# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A set of bash scripts for managing dotfiles via hard links. Files in `files/` are the canonical source of truth; installing a dotfile creates a hard link between `files/<name>` and `~/.<name>`, so edits to either end update both.

## Commands

```sh
dotfiles install [target_dir] [file[:targetname] ...]   # Link files into target_dir (default: $HOME)
dotfiles uninstall [target_dir] [file[:targetname] ...]  # Remove links and restore plain copies
dotfiles reset [target_dir] [file1|file2|..]             # Discard local changes (interactive)
dotfiles update                                           # git pull + re-link any files that broke
dotfiles status                                           # Show which files are linked vs unlinked
```

The `file:targetname` syntax lets you install a file under a non-default name, e.g. `dotfiles install gitconfig:.gitconfig_work`.

`bin/dotfiles` must be on `$PATH` (or called directly) to use these commands.

## Architecture

```
files/        # Canonical dotfile content (committed, hard-linked to $HOME)
config        # Install log: "<sourcename> <target_path>" per line (gitignored, machine-local)
lib/          # One bash function file per subcommand (install, uninstall, reset, update, status)
lib/common.sh # Shared: FILES_DIR, CONFIG_FILE, usage(), get_script(), process_args(),
              #         target_name(), config_add(), config_remove(), config_targets()
bin/dotfiles  # Entry point: sources common.sh, dispatches to lib/<command>
```

**Hard link mechanics:** `install` replaces the repo copy with a hard link to the existing target file (or creates one if it doesn't exist). `uninstall` removes the repo copy and does `git checkout` to restore a plain file. `update` does `git pull`, then re-links any file that became unlinked after the pull.

**Config file:** `config` records every installed path as `<sourcename> <target_path>`. It is machine-local (gitignored) and is read by `uninstall`, `update`, and `reset` to find where files are linked. One source file can have multiple lines (linked into multiple directories).

## Adding a new dotfile

1. Add the file to `files/` (named without the leading dot).
2. Run `dotfiles install` to link it.
3. Commit `files/<name>`.
