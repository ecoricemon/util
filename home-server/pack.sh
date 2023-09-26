#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <keys_file> <subs_file>"
    exit 1
fi

# Define the list of target files and directories
targets=(
    "$0"
    cloud
    docker.sh
    git/docker-compose.yaml
    network
    proxy/certs/cert.ext
    proxy/docker-compose.yaml
    proxy/gen.sh
    proxy/volume/envoy/cds
    proxy/volume/envoy/envoy.yaml
    proxy/volume/envoy/lds
    videocvt
)

# Read keys and subs from the provided argument files
keys_file="$1"
subs_file="$2"

# Function to perform substitutions in a file
substitute_keys() {
    local file="$1"
    local i

    # Check if the file exists
    if [ -f "$file" ]; then
        # Perform substitutions for each key and sub
        for ((i = 0; i < ${#keys[@]}; i++)); do
            sed -i "s|${keys[i]}|${subs[i]}|g" "$file"
        done
        echo "Substitutions complete for: $file"
    else
        echo "File not found: $file"
    fi
}

# Function to perform substitutions in a target
substitute() {
    for target in "${targets[@]}"; do
        # Check if the target is a directory
        if [ -d "$target" ]; then
            # If it's a directory, find and process all files within it
            find "$target" -type f | while read file; do
                substitute_keys "$file"
            done
        elif [ -f "$target" ]; then
            # If it's a file, perform substitutions directly
            substitute_keys "$target"
        else
            echo "Target not found: $target"
        fi
    done
}

# Substitute keys into subs in target files recursively
if [ -f "$keys_file" ] && [ -f "$subs_file" ]; then
    # Read keys and subs into arrays
    mapfile -t keys < "$keys_file"
    mapfile -t subs < "$subs_file"

    # Substitute keys into subs
    echo "======== Substitution secrets ========"
    substitute

    # Create a tar archive of the targets
    echo "======== Archive Genertion ========"
    name="targets.tar"
    tar -cf $name "${targets[@]}"
    echo "Generated $name"

    # Recover
    echo "======== Recover secrets ========"
    mapfile -t keys < "$subs_file"
    mapfile -t subs < "$keys_file"
    substitute
else
    echo "Keys file or subs file not found."
    exit 1
fi

