#!/bin/bash

json_file="$(dirname "$0")/../logs/json_logs/logs.json"

if [ ! -f "$json_file" ]; then
    echo "Create JSON File First"
    exit 1
fi

last_checked=$(jq -r '.last_checked' "$json_file")
echo -e "\nLast Checked: $last_checked\n"
echo "--- Services Dashboard --\n"

# Storing JSON Objects Items as variables
jq -c '.services[]' "$json_file" | while read -r line; do
    name=$(echo "$line" | jq -r '.Name')
    status=$(echo "$line" | jq -r '.Status')
    http_status=$(echo "$line" | jq -r '.HTTP_Status')
    latency=$(echo "$line" | jq -r '.Latency')

echo -e "Name: $name\nStatus: $status\nHTTP Status: $http_status\nLatency: $latency seconds\n---------------------\n"
done