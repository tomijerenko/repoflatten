#!/bin/bash

# Define default values
output_file="repoflatten.txt"
include_hidden=0
ignore_patterns=() # Array to hold patterns of files/directories to ignore
run_flatten=0 # Flag to control script execution

# Display help message
function display_help() {
    echo "Usage: $0 --flatten [options]"
    echo ""
    echo "Options:"
    echo "  --flatten              Run the script to combine file contents."
    echo "  --include-hidden       Include hidden files in the operation."
    echo "  -i, --ignore <pattern> Ignore files/directories matching the pattern. Can be used multiple times."
    echo "  --help                 Display this help message and exit."
    echo ""
    echo "This script combines all files' contents in the current directory and its subdirectories into a single text file, excluding itself and optionally hidden files and user-specified patterns."
}

# Parse command-line options
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --flatten) run_flatten=1 ;;
        --include-hidden) include_hidden=1 ;;
        -i|--ignore) ignore_patterns+=("$2"); shift ;;
        --help) display_help; exit 0 ;;
        *) echo "Unknown option: $1"; display_help; exit 1 ;;
    esac
    shift
done

# Exit and show help if not running the flatten operation
if [[ "$run_flatten" -eq 0 ]]; then
    display_help
    exit 0
fi

# Proceed with script execution if --flatten is specified
if [[ "$run_flatten" -eq 1 ]]; then
    # Function to construct find command with ignore patterns
    function construct_find_command() {
        local find_command="find . -type f ! -name '$output_file' ! -name '$(basename "$0")'"
        if [[ "$include_hidden" -eq 0 ]]; then
            find_command+=" ! -path '*/.*'"
        fi
        for pattern in "${ignore_patterns[@]}"; do
            find_command+=" ! -path '$pattern'"
        done
        echo "$find_command -print0"
    }

    # Check if the output file already exists and remove it to start fresh
    if [ -f "$output_file" ]; then
        rm "$output_file"
    fi

    # Construct and evaluate the find command
    find_command=$(construct_find_command)
    eval $find_command | while IFS= read -r -d $'\0' file; do
        printf "==================== FILE START: $file ====================\n" >> "$output_file"
        cat "$file" >> "$output_file"
        printf "==================== FILE END ====================\n\n\n" >> "$output_file"
    done

    echo "All files have been combined into $output_file."
fi

