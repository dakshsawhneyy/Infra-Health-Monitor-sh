#!/bin/bash

json_file="$(dirname "$0")/../logs/json_logs/logs.json"

if [ ! -f "$json_file" ]; then
    echo "Create JSON File First"
    exit 1
fi

last_checked=$(jq -r '.last_checked' "$json_file")
echo -e "\nLast Checked: $last_checked\n"
echo -e "\e[36m--- Services Dashboard ---\e[0m\n"

# Storing JSON Objects Items as variables
jq -c '.services[]' "$json_file" | while read -r line; do
    name=$(echo "$line" | jq -r '.Name')
    status=$(echo "$line" | jq -r '.Status')
    http_status=$(echo "$line" | jq -r '.HTTP_Status')
    latency=$(echo "$line" | jq -r '.Latency')

case "$status" in
    "UP")
        color="\e[32m"  # Green for UP
        ;;
    "DOWN")
        color="\e[31m"  # Red for DOWN
        ;;
    *)
        color="\e[33m"  # Yellow for unknown status
        ;;
esac

echo -e "\e[35mName: $name\e[0m\n${color}Status: $status\e[0m\nHTTP Status: $http_status\nLatency: $latency seconds\n---------------------\n"
done