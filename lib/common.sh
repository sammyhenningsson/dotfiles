FILES_DIR="$ROOT_DIR/files"
CONFIG_FILE="$ROOT_DIR/config"

declare -A FILE_TARGET_NAMES

usage() {
  echo "dotfiles [install|uninstall|update|reset|status]"
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

check_migration() {
  local hard_linked
  hard_linked=$(find "$FILES_DIR" -maxdepth 1 -type f -links +1 -printf '%f\n' | head -1)
  if [ -n "$hard_linked" ]; then
    >&2 echo "Hard links detected (e.g. '$hard_linked'). Run 'migrate-to-symlinks' first."
    exit 1
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

  TARGET_DIR=$(readlink -f $TARGET_DIR)

  if [ $# -gt 0 ]; then
    for spec in "$@"; do
      if [[ "$spec" == *:* ]]; then
        fname="${spec%%:*}"
        tname="${spec##*:}"
      else
        fname="$spec"
        tname=""
      fi
      file="${FILES_DIR}/${fname##*/}"
      if [ ! -f "$file" ]; then
        >&2 echo "Source file '$file' does not exist"
        exit 1
      fi
      FILES+=" $file"
      FILE_TARGET_NAMES["$file"]="$tname"
    done
  else
    FILES=$(find $FILES_DIR -maxdepth 1 -type f)
  fi

  if [ ! -d "$TARGET_DIR" ]; then
    >&2 echo "Target directory '$TARGET_DIR' does not exist"
    exit 1
  fi
}

target_name() {
  local file="$1"
  local name="${FILE_TARGET_NAMES[$file]}"
  if [ -z "$name" ]; then
    echo ".${file##*/}"
  else
    echo "$name"
  fi
}

config_add() {
  local source_name="${1##*/}"
  local target_path="$2"
  if ! grep -qFx "${source_name} ${target_path}" "$CONFIG_FILE" 2>/dev/null; then
    echo "${source_name} ${target_path}" >> "$CONFIG_FILE"
  fi
}

config_remove() {
  local source_name="${1##*/}"
  local target_path="$2"
  if [ -f "$CONFIG_FILE" ]; then
    grep -vFx "${source_name} ${target_path}" "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" \
      && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
  fi
}

config_targets() {
  local source_name="${1##*/}"
  grep "^${source_name} " "$CONFIG_FILE" 2>/dev/null | awk -v home="$HOME" '{sub(/^~/, home, $2); print $2}'
}
