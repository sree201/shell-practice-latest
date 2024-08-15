#!/bin/bash

# Configuration
CPU_THRESHOLD=80        # CPU usage threshold in percent
EMAIL_TO="koyisrinath@gmail.com"
EMAIL_SUBJECT="Alert: System Resource Usage"
EMAIL_BODY="/tmp/resource_alert_body.txt"

# Check CPU Usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d. -f1)

if [ "$cpu_usage" -gt "$threshold" ]; then

echo "High CPU usage detected: $cpu_usage%"

fi

# Check CPU usage
#CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
#echo "CPU Load: ${CPU_LOAD}%"

# Initialize flag for alert
ALERT_FLAG=0

# Check CPU usage
if [ "$(echo "$CPU_USAGE >= $CPU_THRESHOLD" | bc)" -eq 1 ]; then
    echo "CPU USAGE is above threshold."
    ALERT_FLAG=1
fi

# Send email if any alert condition is met
if [ "$ALERT_FLAG" -eq 2 ]; then
    echo "Creating alert email content."


echo "Current CPU Load: ${CPU_USAGE}%" >> "$EMAIL_BODY"

# Send the email
    send_email
else
    echo "System resource usage is within acceptable limits."
fi