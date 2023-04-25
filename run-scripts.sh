#!/bin/bash

if (( $# != 1 )); then
    >&2 echo "Usage : run-scripts.sh [ROOT_FOLDER]"
    exit 1
fi

ROOT_FOLDER=$(realpath $1)
ALLOWED_READ_FOLDER=".."
ALLOWED_WRITE_FOLDER=".."
SCRIPT_FOLDER=".scripts"
SCRIPT_NAME="*.[tj]s"
ALLOW_NET="deno.land;esm.sh"

echo "Running scripts in $ROOT_FOLDER"

export NO_COLOR=true

for path in $(find "$ROOT_FOLDER" \( -type d -path "**/$SCRIPT_FOLDER/*" -prune -o -type f -path "**/$SCRIPT_FOLDER/*" -name "$SCRIPT_NAME" \) -type f); do

    DIR=$(dirname $path)
    ALLOW_READ=$(cd $DIR && realpath "$ALLOWED_READ_FOLDER")
    ALLOW_WRITE=$(cd $DIR && realpath "$ALLOWED_WRITE_FOLDER")

    LOGFILE="$path.log"

    echo "execution time  :" $(date --iso-8601=seconds) > "$LOGFILE"

    echo ""
    echo "$path"
    echo "read permission : $ALLOW_READ" | tee -a "$LOGFILE"
    echo "write permission: $ALLOW_WRITE" | tee -a "$LOGFILE"
    echo "net permission  : $ALLOW_NET" | tee -a "$LOGFILE"
    echo "" | tee -a "$LOGFILE"

    cd $DIR && deno run "--allow-net=$ALLOW_NET" "--allow-env" "--allow-read=$ALLOW_READ" "--allow-write=$ALLOW_WRITE" --no-prompt "$path" 2>&1 | tee -a "$LOGFILE"
done;