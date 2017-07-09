ROOT_DIR=$(git rev-parse --show-toplevel)
FILES_DIR="$ROOT_DIR/files"

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
    f="${FILES_DIR}/$(basename $file)"
    if [ ! -f $f ]; then
      >&2 echo "Source file '$f' does not exist"
      exit 1
    fi
    FILES+=" $f"
  done
else
  FILES=$(find $FILES_DIR -maxdepth 1 -type f)
fi

if [ -d "$TARGET_DIR" ]; then
  echo "Install directory: '$TARGET_DIR'"
else
  >&2 echo "Target directory '$TARGET_DIR' does not exist"
  exit 1
fi
