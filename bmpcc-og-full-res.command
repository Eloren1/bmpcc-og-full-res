#!/bin/bash
set -eu

# Check if exiftool is installed
if ! command -v exiftool &> /dev/null; then
    echo "Error: exiftool is not installed. Please install it and try again."
    exit 1
fi

# Switch to the directory where the script is installed
cd -- "$(dirname "$0")"

startTime=$(date +"%H:%M:%S")
echo "[$startTime] Starting script..."
folderCount=0

for dir in "."/*/; do
    if [ -d "$dir" ]; then
        echo "Processing directory: $dir"
        if [[ -f "$dir/done.txt" ]]; then
            echo "$dir: Skipped"
            continue
        fi

        # Check if the directory contains .dng files
        if ! find "$dir" -maxdepth 1 -name "*.dng" | grep -q .; then
            echo "$dir: No .dng files found, skipping."
            continue
        fi

        # Remove any existing exiftool temporary files if they exist
        if ls "$dir"/*.dng_exiftool_tmp 1> /dev/null 2>&1; then
            rm -f "$dir"/*.dng_exiftool_tmp
        fi

        echo "$dir: Setting resolution to 1952x1112px"
        exiftool -IFD0:DefaultCropSize="1952 1112" -IFD0:DefaultCropOrigin="0 0" -overwrite_original "$dir"/*.dng

        touch "$dir"/done.txt

        ((folderCount++))
    fi
done

endTime=$(date +"%H:%M:%S")
echo "[$endTime] Finished processing $folderCount folders"
