# Dotfiles
Some bash scripts to sync dotfiles.

## Usage
```sh
dotfiles install [target_dir] [file1|file2|..]
```
Install one or multiple files into target_dir. If target_dir is not given then $HOME is used as target.

```sh
dotfiles uninstall [target_dir] [file1|file2|..]
```
Uninstalls one or multiple files from target_dir. If target_dir is not given then $HOME is used as target.

```sh
dotfiles reset [target_dir] [file1|file2|..]
```
Revert local changes of files.

```sh
dotfiles update
```
Update files to latest git commit.


```sh
dotfiles status
```
Print a status about which files are linked/installed.
