#!/bin/bash

# Configuration
THRESHOLD=1024           # Threshold in MB (e.g., 1024 MB = 1 GB)
EMAIL_TO="koyisrinath@gmail.com"
EMAIL_SUBJECT="Alert: Low RAM Memory"
EMAIL_BODY="/tmp/ram_alert_body.txt"

# Function to send email
send_email() {
    echo "Sending alert email to $EMAIL_TO"
    mail -s "$EMAIL_SUBJECT" "$EMAIL_TO" < "$EMAIL_BODY"
}

# Check RAM usage
AVAILABLE_RAM=$(free -m | awk '/^Mem:/{print $7}')
echo "Available RAM: ${AVAILABLE_RAM}MB"

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

###########################################################################################

#!/bin/bash 
subject="Memory Alert"
from="admin@thelinuxterminal.com"
to="user1@gmail.com"

free=$(free -mt | grep Total | awk '{print $4}')

if [[ "$free" -le 100  ]]; then
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | awk 'NR<=5'
    | head >/tmp/memeorydata.txt

file=/tmp/memeorydata.txt

echo -e "Warning, server memory is running low!\n\n
    Free memory: $free MB" |

mailx -a "$file" -s "$subject" -r "$from" -c "$to"

fi
exit 0