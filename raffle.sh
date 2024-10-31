#!/bin/bash

# Read the number of winners
read -p "Enter the number of winners: " numWinners

# Check if the script is running interactively
if [[ -t 0 ]]; then
    echo "Enter the list of entries (one per line)."
    echo "Press Enter after each entry."
    echo "When finished, press Ctrl+D on a new line to end input."
fi

# Read the list of entrants into an array
mapfile -t entrants

# Get the total number of entrants
totalEntrants=${#entrants[@]}

# Check if we have enough entrants
if [ "$numWinners" -gt "$totalEntrants" ]; then
    echo "Error: Not enough entrants to select $numWinners winners." >&2
    exit 1
fi

# Look for entrants with multiple entries and expand the list, remove spaces from each entry
declare -a entries=()
for entrant in "${entrants[@]}"; do
    if [[ $entrant =~ ^(.*)\ ([0-9]+)$ ]]; then
        text=${BASH_REMATCH[1]// /}

        count=${BASH_REMATCH[2]}
        for ((i = 0; i < count; i++)); do
            entries+=("$text")
        done
    else
        entries+=("${entrant// /}")
    fi
done

# Print the number of entrants and entries as a sanity check
echo -e "\nPicking $numWinners winners from $totalEntrants entrants and ${#entries[@]} total entries."

# Use shuf command with /dev/urandom as the random source, keep the entire list so we can remove duplicates
winners=$(printf '%s\n' "${entries[@]}" | shuf --random-source=/dev/urandom)

# write winners to a temp file, sha256sum the file, and print the hash
temp_file=$(mktemp /tmp/raffle.XXXXXXXXXX.txt)
echo "$winners" > "$temp_file"
hash=$(sha256sum "$temp_file")
echo -e "\nWinners file hash:\n\t$hash"

# Iterate through the winners list collecting winners, skipping duplicates, until we've gotten numWinners
declare -a finalWinners=()
for winner in $winners; do
    if [[ ! " ${finalWinners[@]} " =~ " ${winner} " ]]; then
        finalWinners+=("$winner")
    fi
    if [ ${#finalWinners[@]} -eq $numWinners ]; then
        break
    fi
done

# Print the winners
echo -e "\nThe winners are:"
printf '\t%s\n' "${finalWinners[@]}"