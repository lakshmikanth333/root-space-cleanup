#!/bin/bash

# Validate input argument (server name required)
if [ $# -ne 1 ]; then
   echo "Usage: $0 <server_name>"
   exit 1
fi

SERVER=$1
THRESHOLD=90

# Show current disk utilization (remote)
echo "Current disk utilization is"
echo "--------------------------------"
etcmd -s kmssh root@$SERVER "df -hT /"

# Get current usage value (remove % using sed)
USAGE=$(etcmd -s kmssh root@$SERVER "df -hT / | awk 'NR==2 {print \$5}' | sed 's/%//g'") || exit 2

# If usage above threshold → run cleanup
if [ "$USAGE" -ge "$THRESHOLD" ]; then
    echo "Usage above threshold. Running cleanup..."
    etcmd -s kmssh root@$SERVER "sudo yum clean all" || exit 1

fi

exit 0