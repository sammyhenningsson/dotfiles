# Dotfiles
Some bash scripts for syncing dotfiles.

## Usage
#### install
```sh
dotfiles install [target_dir] [file1|file2|..]
```
Install one or multiple files into target_dir. If target_dir is not given then $HOME is used as target.

#### uninstall
```sh
dotfiles uninstall [target_dir] [file1|file2|..]
```
Uninstalls one or multiple files from target_dir. If target_dir is not given then $HOME is used as target.

#### reset
```sh
dotfiles reset [target_dir] [file1|file2|..]
```
Revert local changes of files.

#### update
```sh
dotfiles update
```
Update files to latest git commit.


#### status
```sh
dotfiles status
```
Print status about which files are linked/installed.



### TODO
Add support for configuring (or manually specifying) target filenames
