#!/bin/bash

# Create patches directory if it doesn't exist
mkdir -p patches

# Get the list of modified files, excluding .git and patches directories
modified_files=$(git diff --name-only remotes/origin/deprecated_android-3.18-2020-08-05_3.18..remotes/origin/lineage-18.1-ASB-2020-07-05_2020-08-05_3.18 | grep -v '^\.git/' | grep -v '^patches/')

# Generate individual patches for each modified file
for file in $modified_files; do
    # Create the directory structure in the patches folder
    patch_dir="patches/$(dirname "$file")"
    
    # Create the directory if it doesn't exist
    mkdir -p "$patch_dir"
    
    # Create patch for the file, using the correct path for the patch file
    git diff remotes/origin/deprecated_android-3.18-2020-08-05_3.18..remotes/origin/lineage-18.1-ASB-2020-07-05_2020-08-05_3.18 -- "$file" > "$patch_dir/$(basename "$file").patch"
done

echo "Patches generated in the 'patches' directory."