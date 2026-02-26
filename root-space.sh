#!/bin/bash

# Validate input argument (server name required)
if [ $# -ne 1 ]; then
   echo "Usage: $0 <server_name>"
   exit 1
fi

SERVER=$1
THRESHOLD=90

# Show current disk utilization (remote)
printf "\n===== Current Disk Utilization =====\n"
etcmd -s kmssh root@$SERVER "df -hT /"

# Get current usage value (remove % using sed)
USAGE=$(etcmd -s kmssh root@$SERVER "df -hT / | awk 'NR==2 {print \$6}' | sed 's/%//g'") || exit 2

# If usage above threshold → run cleanup
if [ "$USAGE" -ge "$THRESHOLD" ]; then
    echo "Usage above threshold. Running cleanup..."
    etcmd -s kmssh root@$SERVER "sudo yum clean all" || exit 1

    # Check usage again after cleanup
    NEW_USAGE=$(etcmd -s kmssh root@$SERVER "df -hT / | awk 'NR==2 {print \$6}' | sed 's/%//g'")

    printf "\n===== Disk Utilization After Cleanup =====\n"
    echo "--------------------------------"
    etcmd -s kmssh root@$SERVER "df -hT /"

    # If still above threshold → show large directories
    if [ "$NEW_USAGE" -ge "$THRESHOLD" ]; then
        printf "\n===== Large Directories Consuming Space =====\n"
        etcmd -s kmssh root@$SERVER "du -h / 2>/dev/null | grep '[0-9]G' | sort -n"
    fi
fi

exit 0