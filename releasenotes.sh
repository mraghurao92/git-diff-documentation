#!/bin/bash

# Change to your Git repository directory
#cd /path/to/your/git/repository

# Output file for the release notes
release_notes="release_notes.md"

# Clear the release notes file
echo "" > "$release_notes"

# Function to generate release notes for a given version
generate_release_notes() {
    local version="$1"
    local date="$2"
    echo "Version $version ($date)" >> "$release_notes"
    echo "=========================" >> "$release_notes"
    echo "" >> "$release_notes"
    git log --format="- %s" "v$version^..v$version" >> "$release_notes"
    echo "" >> "$release_notes"
}

# Read each tagged version from Git and generate release notes
git tag --list | grep -Eo '[0-9]{4}-[0-9]{2}-[0-9]{2}' | while read -r version; do
    date=$(git log -1 --format=%ai "v$version")
    generate_release_notes "$version" "$date"
done

echo "Release notes generated successfully."
