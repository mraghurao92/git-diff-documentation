#!/bin/bash

# Change to your Git repository directory
#cd /path/to/your/git/repository

# Output file for the changelog
changelog="changelog.md"

# Clear the changelog file
echo "" > $changelog

# Get the list of commits
commits=$(git log --format=%H)

# Function to parse file changes
parse_changes() {
    local commit=$1
    local file=$2
    local status=$3
    echo "Debug: Parsing changes for commit $commit, file $file, status $status"
    echo "- File changed: $file ($status)" >> $changelog
    echo "  Changes:" >> $changelog
    # Check if file exists before trying to diff
    if [ -f "$file" ]; then
        echo "Debug: File $file exists, performing diff"
        git diff --unified=0 $commit^..$commit -- $file | tail -n +5 >> $changelog
    else
        echo "Debug: File $file does not exist in this commit"
        echo "    File does not exist in this commit" >> $changelog
    fi
    echo "" >> $changelog
}

# Iterate over each commit and generate changelog
for commit in $commits; do
    echo "Commit: $commit" >> $changelog
    echo "----" >> $changelog
    git show --no-patch --format=%ci $commit >> $changelog
    echo "" >> $changelog
    echo "Message:" >> $changelog
    git show --no-patch --format=%B $commit >> $changelog
    echo "" >> $changelog
    echo "Changes:" >> $changelog
    # Get the list of modified files for the commit
    files=$(git diff-tree --no-commit-id --name-status -r $commit)
    echo "Debug: List of modified files: $files"
    while read -r line; do
        status=$(echo "$line" | awk '{print $1}')
        file=$(echo "$line" | awk '{print $2}')
        parse_changes $commit "$file" $status
    done <<< "$files"
    echo "" >> $changelog
done
