#!/bin/bash

# Get the directory of the current script
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
LOG_FILE="$SCRIPT_DIR/applied_patches.log"

# Check if the log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "No applied patches found. Please apply patches first."
    exit 1
fi

# Revert each applied patch
while IFS= read -r patch; do
    if [ -f "$patch" ]; then
        echo "Reverting patch: $patch"
        git apply --reverse "$patch"
        if [ $? -eq 0 ]; then
            echo "Successfully reverted $patch"
        else
            echo "Failed to revert $patch"
        fi
    else
        echo "Patch file not found: $patch"
    fi
done < "$LOG_FILE"

# Clear the log file after reverting
> "$LOG_FILE"

echo "All specified patches processed."
