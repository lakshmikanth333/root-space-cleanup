# Root Space Check Script

This script helps handle recurring /root filesystem space alerts.

## Where it runs
The script runs from the admin node and connects to the target server automatically.

## Environment
Currently intended for Production (Prod).

## What it does
- Checks root filesystem usage
- Runs `yum clean all` if usage is above threshold
- Rechecks usage after cleanup
- Shows top space-consuming directories under /root if usage is still high
- Does not delete any files automatically

## Usage
```bash
./root_space.sh <server>
