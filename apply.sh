#!/bin/bash

# Apply each patch in the patches directory
for patch in patches/*.patch; do
    if [ -f "$patch" ]; then
        git apply "$patch"
        echo "Applied $patch"
    fi
done

echo "All patches applied."
