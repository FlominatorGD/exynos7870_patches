#!/bin/bash

# Get the directory of the current script
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
LOG_FILE="$SCRIPT_DIR/test_patch_results.log"
DIRTY_DIR="$SCRIPT_DIR/dirty"

# Ensure the log file exists and clear previous results
> "$LOG_FILE"

# Create the dirty directory if it doesn't exist
mkdir -p "$DIRTY_DIR"

# Test each patch in the patches directory and its subdirectories
find "$SCRIPT_DIR" -type f -name "*.patch" | while read -r patch; do
    echo "Testing patch: $patch"
    
    # Check if the patch can be applied without errors
    if git apply --check "$patch" &> /dev/null; then
        echo "Patch $patch can be applied cleanly." | tee -a "$LOG_FILE"
    else
        echo "Patch $patch cannot be applied cleanly." | tee -a "$LOG_FILE"
        
        # Create the destination path in the dirty directory
        relative_path="${patch#$SCRIPT_DIR/}"  # Get the relative path
        destination="$DIRTY_DIR/$relative_path"  # Build the destination path
        
        # Create the necessary subdirectories in the dirty directory
        mkdir -p "$(dirname "$destination")"
        
        # Copy the patch to the dirty directory
        cp "$patch" "$destination"
    fi
done

echo "Patch testing complete. Results saved to $LOG_FILE."
