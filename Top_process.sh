#!/bin/bash

# Configuration
CPU_THRESHOLD=80        # CPU usage threshold in percent
EMAIL_TO="koyisrinath@gmail.com"
EMAIL_SUBJECT="Alert: High CPU Usage"
EMAIL_BODY="/tmp/cpu_usage_alert_body.txt"

# Function to send email
send_email() {
    echo "Sending alert email to $EMAIL_TO"
    mail -s "$EMAIL_SUBJECT" "$EMAIL_TO" < "$EMAIL_BODY"
}

# Get the top 5 CPU-consuming processes
TOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6)

# Check if the top processes exceed the CPU threshold
ALERT_FLAG=0
echo "$TOP_PROCESSES" 
while IFS= read -r line
do
    if [[ "$line" =~ ^[0-9] ]] 
    then
        PID=$(echo "$line" | awk '{print $1}')
        COMMAND=$(echo "$line" | awk '{print $2}')
        CPU_USAGE=$(echo "$line" | awk '{print $3}')

        if [[ "$(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc)" -eq 1 ]]
            then
                echo "Process $COMMAND (PID $PID) is consuming $CPU_USAGE% CPU, which exceeds the threshold."
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
