#!/bin/bash

# fetching Slack Webhook URL from ../config/webhook.env
source "$(dirname "$0")/../config/webhook.env"

# We gonna pass this aler.sh script in webhook so passing things through arg
severity="$1"   # Expected values: "critical", "warning", "info"
message="$2"    # message we wanted to send to slack

# payload accepts json format #! \" means " is treated as " not simple text
payload="{
    \"text\": \"[$severity] $message\"      
}"

# Check if SLACK_WEBHOOK_URL is set and not empty
if [ -z "$SLACK_WEBHOOK_URL" ]; then
    echo "Error: SLACK_WEBHOOK_URL is not set. Please check ../config/webhook.env."
    exit 1
fi

# Sending payload to slack via curl
# -s=silent -X=HTTP_Method_Specify -H=Content_type
curl -s -X POST -H 'Content-type: application/json' \
    --data "$payload" "$SLACK_WEBHOOK_URL" &> /dev/null