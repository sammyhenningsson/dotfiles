FILES_DIR="$ROOT_DIR/files"
LOG_DIR="$ROOT_DIR/installs"

usage() {
  echo "dotfiles [install|uninstall|update|reset]"
}

get_script() {
  cmd=$1
  if [ -f "$LIB_DIR/$cmd" ]; then
    . "$LIB_DIR/$cmd"
    if type $cmd >/dev/null; then
      return 0
    else
      echo "File $LIB_DIR/$cmd must declare function: $cmd"
      exit 2
    fi
  else
    >&2 echo -e "Command not found: $cmd\n"
    return 5
  fi
}

process_args() {
  if [ $# -gt 0 -a -d "$1" ]; then
    TARGET_DIR=$1
    shift
    # Strip off any trailing slashes
    TARGET_DIR=${TARGET_DIR%%+(/)}
  else
    TARGET_DIR=$HOME
  fi

  if [ $# -gt 0 ]; then
    for file in $@; do
      f="${FILES_DIR}/${file##*/}"
      if [ ! -f $f ]; then
        >&2 echo "Source file '$f' does not exist"
        exit 1
      fi
      FILES+=" $f"
    done
  else
    FILES=$(find $FILES_DIR -maxdepth 1 -type f)
  fi

  if [ ! -d "$TARGET_DIR" ]; then
    >&2 echo "Target directory '$TARGET_DIR' does not exist"
    exit 1
  fi

  if [ ! -d $LOG_DIR ]; then
    mkdir $LOG_DIR
  fi
}
