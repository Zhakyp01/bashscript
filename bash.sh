#!/bin/bash

# Set up inotifywait to monitor the /etc directory for events
inotifywait -m /etc -e create,delete,modify -o /tmp/etc_changes.log

# Send an email notification when the log file is modified
while true; do
  if [[ -f /tmp/etc_changes.log ]]; then
    if [[ $(stat -c %Y /tmp/etc_changes.log) -gt $(last_check) ]]; then
      # Send an email notification about the changes
      mail -s "Changes detected in /etc" your_email_address < /tmp/etc_changes.log

      # Update the last check timestamp
      last_check=$(stat -c %Y /tmp/etc_changes.log)
    fi
  fi

  # Sleep for a second to avoid excessive CPU usage
  sleep 1
done
