#!/bin/bash

# Deletes repos from a CSV input list

# Need to run this to get the repo delete scope: gh auth refresh -h github.com -s delete_repo

# Usage: 
# Step 1: Run ./generate-repositories-list.sh <org> > repos.csv 
#   - Or create a list of repos in a csv file, 1 per line, with a trailing empty line at the end of the file
#   - DO NOT REMOVE TRAILING NEW LINE IN THE INPUT CSV FILE
# Step 2: ./delete-repositories-from-list.sh repos.csv

if [ $# -lt "2" ]; then
    echo "Usage: $0 <reposfilename> <visibility: public|internal|private>"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "File $1 does not exist"
    exit 1
fi

filename="$1"
visibility=$2

while read -r repofull ; 
do
    IFS='/' read -ra data <<< "$repofull"

    org=${data[0]}
    repo=${data[1]}

    echo $"Changing visibility of $org/$repo to $visibility..."
    gh repo edit $org/$repo --visibility $visibility --accept-visibility-change-consequences

done < "$filename"
