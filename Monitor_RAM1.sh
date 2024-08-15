#!/bin/bash

THRESHOLD=90
EMAIL_TO="koyisrinath@gmail.com"
EMAIL_SUBJECT="Alert: Low RAM Memory"
EMAIL_BODY="/tmp/ram_alert_body.txt"

# CPU Usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d. -f1)

if [ "$cpu_usage" -gt "$threshold" ]; then

echo "High CPU usage detected: $cpu_usage%"

fi

# Function to send email
send_email() {
    echo "Sending alret email to $EMAIL_TO"
    mail -s "$EMAIL_SUBJECT" "$EMAIL_TO" < "$EMAIL_BODY"
}

# Check RAM Usage
AVAILABLE_RAM=$(free -m | awk '/^Mem:/{print $7}')
echo AVAILABLE RAM: "${AVAILABLE_RAM}MB"

# Compare available RAM with the threshold
if [ "$AVAILABLE_RAM" -lt "$THRESHOLD" ]; then
    echo "Available RAM is below threshold. Sending alert email."

    # Create email body content
    echo "Subject: $EMAIL_SUBJECT" > "$EMAIL_BODY"
    echo "" >> "$EMAIL_BODY"
    echo "Warning: Your system's available RAM has fallen below the threshold of $THRESHOLD MB." >> "$EMAIL_BODY"
    echo "" >> "$EMAIL_BODY"
    echo "Current available RAM: ${AVAILABLE_RAM}MB" >> "$EMAIL_BODY"
    echo "Please take appropriate action to free up memory or increase system resources." >> "$EMAIL_BODY"
    
    # Send the email
    send_email
else
    echo "Available RAM is sufficient."
fi
