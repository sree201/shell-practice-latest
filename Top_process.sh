#!/bin/bash

# Configuration
CPU_THRESHOLD=80        # CPU usage threshold in percent
EMAIL_SUBJECT="Alert: High CPU Usage"
FOLDER="/tmp/cpu_usage_alert_body.txt"
MESSAGE=""

# Function to send email
    echo -e "MESSAGE: $MESSAGE"
    echo "$MESSAGE" | mail -s  "Available ram usage alert" koyisrinath@gmail.com

# Get the top 5 CPU-consuming processes
TOP_PROCESSES=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6)

# Check if the top processes exceed the CPU threshold
ALERT_FLAG=0
# echo "$TOP_PROCESSES" 
while IFS= read -r line
do
    if [[ "$line" =~ ^[0-9] ]] 
    then
        CPU_USAGE=$(echo "$line" | awk '{print $NR}')

        if [[ "$(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc)" -eq 1 ]]
            then
                echo "Process $CPU_THRESHOLD is consuming $CPU_USAGE% CPU, which exceeds the threshold."
                ALERT_FLAG=1
        fi
    fi
done <<< $CPU_THRESHOLD

# Send email if any process exceeds the threshold
if [ "$ALERT_FLAG" -eq 1 ]
then
    echo "Creating alert email content."

    # Create email body content
    echo "Subject: $EMAIL_SUBJECT" > "$EMAIL_BODY"
    echo "" >> "$EMAIL_BODY"
    echo "Warning: The following processes are consuming more CPU than the threshold of $CPU_THRESHOLD%:" >> "$EMAIL_BODY"
    echo "" >> "$EMAIL_BODY"
    echo "$TOP_PROCESSES" >> "$EMAIL_BODY"
    echo "" >> "$EMAIL_BODY"
    echo "Please check the processes and take appropriate action." >> "$EMAIL_BODY"
    
    # Send the email
    send_email
else
    echo "No processes exceeded the CPU usage threshold."
fi
