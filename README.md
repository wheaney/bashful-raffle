# bashful-raffle

Bash script for performing a fair raffle.

## Usage

Check out the git repo, or `wget https://raw.githubusercontent.com/wheaney/bashful-raffle/refs/heads/main/raffle.sh && chmod +x raffle.sh`

### Interactive

Just run with `raffle.sh` and follow the prompts.

### One-liner

First value is the number of winners, all remaining values are entrants. An entrant followed by a number (separated by a space) 
will have that number of entries.

## Example

This will choose 3 winners, where Jane has 2 entries in the contest, and all other entrants have a single entry.

```bash
raffle.sh << EOF
3
Dick
Jane 2
Bob
Spot
EOF
```
