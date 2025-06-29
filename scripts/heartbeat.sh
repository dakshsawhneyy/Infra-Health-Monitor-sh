#!/bin/bash

source "$(dirname "$0")/../config/webhook.env"

message="Heartbeat: All cron jobs are running fine at $(date +"%d-%m-%Y %H:%M:%S")."

payload="{
    \"text\": \"$message\"
}"

curl -s -X POST -H 'Content-type: application/json' \
    --data "$payload" "$SLACK_WEBHOOK_URL" &> /dev/null