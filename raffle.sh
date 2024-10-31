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

# Look for entrants with multiple entries and expand the list
declare -a entries=()
for entry in "${entrants[@]}"; do
    if [[ $entry =~ ^(.*)\ ([0-9]+)$ ]]; then
        text=${BASH_REMATCH[1]}
        count=${BASH_REMATCH[2]}
        for ((i = 0; i < count; i++)); do
            entries+=("$text")
        done
    else
        entries+=("$entry")
    fi
done

# Print the number of entrants and entries as a sanity check
echo -e "\nPicking $numWinners winners from $totalEntrants entrants and ${#entries[@]} total entries."

# Use shuf command with /dev/urandom as the random source, keep the entire list so we can remove duplicates
winners=$(printf '%s\n' "${entries[@]}" | shuf --random-source=/dev/urandom)

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