# bashful-raffle
Bash script for performing a fair raffle. 

## Usage

Check out the git repo, or `wget https://raw.githubusercontent.com/wheaney/bashful-raffle/refs/heads/main/raffle.sh && chmod +x raffle.sh`

### Interactive

Just run with `raffle.sh` and follow the prompts.

### One-liner

First value is the number of winners, all remaining values are entrants.

```bash
raffle.sh << EOF
3
Dick
Jane
Bob
EOF
```
