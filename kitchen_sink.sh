#!/bin/bash

# Simple shell script for trying john the ripper on a bunch of different wordlist files.
# Iterates every wordlist file in a given directory, and their subdirectories, and feeds
# them into JohnTheRipper. Cool.

function show_help {
    cat << EOF

Usage: ./kitchen_sink.sh -d DIRECTORY -f FORMAT -H FILE

Wordlist iterator - runs JohnTheRipper through all the wordlists
in a given directory, and recursively through all its subdirs.

Example: 
./kitchen_sink.sh -d /usr/share/seclists -f raw-md5 -H hash_file.txt

Options:
    -d  Directory containing wordlists
    -f  JtR format
    -H  File containing hash

    -h, --help  Show this help menu
EOF
}

function check_hash_status {
    local john_output
    john_output=$(john --show --format="$format" "$hash_file")
    if [[ "${john_output:0:1}" != "0" ]]; then
        echo -e "\nPASSWORD FOUND!\n"
        echo "$john_output"
        echo ""
        exit 0
    fi
}

function crack {
for wordlist_file in "$subdir"/*; do
    if [ -f "$wordlist_file" ]; then
        check_hash_status
        $(which echo) -e "[WORDLIST]  $wordlist_file"
        john -format="$format" -wordlist="$wordlist_file" "$hash_file" > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo ""
            john -format="$format" -wordlist="$wordlist_file" "$hash_file"
            exit 1
        fi
    fi
done
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

while getopts ":d:H:f:h" opt; do
    case "$opt" in
        d) wordlist_dir="$OPTARG" ;;
        H) hash_file="$OPTARG" ;;
        f) format="$OPTARG" ;;
        h) show_help && exit 0 ;;
        \?) show_help && echo -e "\nInvalid Option: -$OPTARG" && exit 1 ;;
    esac
done

subdirectories=()
while IFS= read -r -d '' subdir; do
    subdirectories+=("$subdir")
done < <(find "$wordlist_dir" -mindepth 0 -type d -print0)

for subdir in "${subdirectories[@]}"; do
    echo -e "\n[DIR]  $subdir"
    printf "=======%-${#subdir}s\n" | tr ' ' '='
    crack "$subdir"
done

exit 0

