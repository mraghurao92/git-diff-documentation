#!/bin/bash

# Change to your Git repository directory
cd /Users/raghavendermuppavaram/Downloads/spring-custom-value-injector

# Output file for the changelog
changelog="changelog.md"

# Get the list of commits
commits=$(git log --format=%H)

# Clear the changelog file
echo "" > $changelog

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
    git diff-tree --no-commit-id --name-status -r $commit | while read status file; do
        echo "- File changed: $file ($status)" >> $changelog
        case $status in
            A) echo "  Added:" >> $changelog; cat $file >> $changelog ;;
            M) echo "  Modified:" >> $changelog; git diff --unified=3 $commit^..$commit -- $file >> $changelog ;;
            D) echo "  Removed: (Content removed)" >> $changelog ;;
        esac
        echo "" >> $changelog
    done
    echo "" >> $changelog
done
