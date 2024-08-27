#!/bin/bash

# Get the directory of the current script
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
LOG_FILE="$SCRIPT_DIR/applied_patches.log"

# Ensure the log file exists
touch "$LOG_FILE"

# Apply each patch in the patches directory
for patch in "$SCRIPT_DIR"/*.patch; do
    if [ -f "$patch" ]; then
        echo "Found patch: $patch"
        
        while true; do  # Loop for user options
            echo "Options: "
            echo "1) Apply"
            echo "2) Preview"
            echo "3) Edit"
            echo "4) Skip"
            read -p "Choose an option (1/2/3/4): " choice
            
            case "$choice" in
                1) 
                    git apply "$patch"
                    echo "Applied $patch"
                    echo "$patch" >> "$LOG_FILE"  # Log the applied patch
                    break  # Exit the inner loop
                    ;;
                2) 
                    echo "Previewing patch: $patch"
                    cat "$patch"
                    # After preview, do not break the loop, let user choose again
                    ;;
                3) 
                    echo "Editing patch: $patch"
                    nano "$patch"  # You can change 'nano' to your preferred editor
                    echo "Patch edited. Do you want to apply it now? (y/n)"
                    read apply_choice
                    if [[ "$apply_choice" == "y" || "$apply_choice" == "Y" ]]; then
                        git apply "$patch"
                        echo "Applied $patch"
                        echo "$patch" >> "$LOG_FILE"  # Log the applied patch
                    else
                        echo "Skipped applying $patch"
                    fi
                    break  # Exit the inner loop
                    ;;
                4) 
                    echo "Skipped $patch"
                    break  # Exit the inner loop
                    ;;
                * ) 
                    echo "Invalid choice. Please select again."
                    ;;
            esac
        done
    fi
done

echo "All patches processed."
