#!/bin/bash

# Read the number of winners
read -p "Enter the number of winners: " numWinners

# Check if the script is running interactively
if [[ -t 0 ]]; then
    echo "Enter the list of entries (one per line)."
    echo "Press Enter after each entry."
    echo "When finished, press Ctrl+D on a new line to end input."
fi

# Read the list of entries into an array
mapfile -t entries

# Get the total number of entries
totalEntries=${#entries[@]}

# Check if we have enough entries
if [ "$numWinners" -gt "$totalEntries" ]; then
    echo "Error: Not enough entries to select $numWinners winners." >&2
    exit 1
fi

# Use shuf command with /dev/urandom as the random source
winners=$(printf '%s\n' "${entries[@]}" | shuf -n "$numWinners" --random-source=/dev/urandom)

# Print the winners
echo -e "\n\nThe winners are:"
echo "$winners"
