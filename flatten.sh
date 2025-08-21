#!/bin/bash

SOURCE="$1"
TARGET="$2"

rm -rf $TARGET
mkdir -p $TARGET

SOURCE="${SOURCE%/}"
TARGET="${TARGET%/}"

for dir in "$SOURCE"/*/; do
  [ -d "$dir" ] || continue
  dirname=$(basename "$dir")
  nested="$SOURCE/$dirname/$dirname"
  if [ -d "$nested" ]; then
    count=$(find "$dir" -mindepth 1 -maxdepth 1 | wc -l)

    if [ "$count" -eq 1 ]; then
      rsync -a "$nested" "$TARGET/"
    else
      mkdir "$TARGET$dirname"
      rsync -a "$SOURCE/$dirname/" "$TARGET/$dirname/" --exclude "$nested"
      rsync -a "$nested/" "$TARGET/$dirname/"
    fi
  else
    rsync -a "$SOURCE/$dirname/" "$TARGET/$dirname/"
  fi
done
