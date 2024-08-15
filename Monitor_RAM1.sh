#!/bin/bash

# # Configuration
# THRESHOLD=1024           # Threshold in MB (e.g., 1024 MB = 1 GB)
# EMAIL_TO="koyisrinath@gmail.com"
# EMAIL_SUBJECT="Alert: Low RAM Memory"
# EMAIL_BODY="/tmp/ram_alert_body.txt"

# # Function to send email
# send_email() {
#     echo "Sending alert email to $EMAIL_TO"
#     mail -s "$EMAIL_SUBJECT" "$EMAIL_TO" < "$EMAIL_BODY"
# }

# # Check RAM Usage
# AVAILABLE_RAM=$(free -m | awk '/^Mem:/{print $7}')
# echo -e "AVAILABLE RAM: ${AVAILABLE_RAM}MB"

# # Compare available RAM with the threshold
# if [ "$AVAILABLE_RAM" -lt "$THRESHOLD" ]; then
#     echo "Available RAM is below threshold. Sending alert email."

#     # Create email body content
#     echo "Subject: $EMAIL_SUBJECT" > "$EMAIL_BODY"
#     echo "" >> "$EMAIL_BODY"
#     echo "Warning: Your system's available RAM has fallen below the threshold of $THRESHOLD MB." >> "$EMAIL_BODY"
#     echo "" >> "$EMAIL_BODY"
#     echo "Current available RAM: ${AVAILABLE_RAM}MB" >> "$EMAIL_BODY"
#     echo "Please take appropriate action to free up memory or increase system resources." >> "$EMAIL_BODY"
    
#     # Send the email
#     send_email
# else
#     echo "Available RAM is sufficient."
# fi


# Configuration
THRESHOLD=1024           # Threshold in MB (e.g., 1024 MB = 1 GB)
AVAILABLE_RAM=$(free -m | awk '/^Mem:/{print $7}')
EMAIL_SUBJECT="Alert: Low RAM Memory"
EMAIL_BODY="/tmp/ram_alert_body.txt"
MESSAGE=""


while IFS= read -r line
do
    USAGE=$(echo $line | awk '/^Mem:/{print $7}')
    if [ $USAGE >= $THRESHOLD ]
    then
        MESSAGE+="$USAGE Usage of RAM is more than $THRESHOLD,  current usage: $AVAILABLE_RAM"

    fi
 
done <<< "$AVAILABLE_RAM"

echo -e "MESSAGE: $MESSAGE"
echo "$MESSAGE" | mail -s "Available ram usage alert" koyisrinath@gmail.com

# Create email body content
echo "Current available RAM: ${AVAILABLE_RAM}MB"
echo "Please take appropriate action to free up memory or increase system resources."

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