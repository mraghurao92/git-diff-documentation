##!/bin/bash
# Output file for documenting changes
documentation_file="changes_documentation.md"

# Function to generate documentation for merged changes
generate_documentation() {
    echo "### Changes Merged into Main Branch" >> "$documentation_file"
    echo "" >> "$documentation_file"
    git log --merges --format="* %s%nAuthor: %an <%ae>%nDate: %aD%n%nChanges:%n" main..HEAD | while read -r line; do
        echo "$line" >> "$documentation_file"
        if [[ $line == "Changes:" ]]; then
            commit_hash=$(git log -1 --format="%H" --grep="$previous_message")
            git show --stat --oneline -p "$commit_hash" | tail -n +6 >> "$documentation_file"
            check_for_value_annotations "$commit_hash"
        fi
        previous_message="$line"
    done
}

# Function to check for @Value annotations in Java files
check_for_value_annotations() {
    commit_hash="$1"
    java_files=$(git diff --name-only "$commit_hash" $(git merge-base HEAD main) | grep "\.java$")
    for file in $java_files; do
        if grep -q "@Value" "$file"; then
            echo "Found @Value annotation in file: $file" >> "$documentation_file"
        fi
    done
}

# Generate documentation for merged changes
generate_documentation
