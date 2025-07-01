#!/bin/bash

json_file_path="$(dirname "$0")/../logs/json_logs"
json_file="$json_file_path/logs.json"

mkdir -p "$json_file_path"
if [ ! -f "$json_file" ]; then
    touch "$json_file"
fi

name="$1"
status="$2"
http_status="$3"
latency="$4"

# Creating JSON snippet
service_entry="{
    \"Name\": \"$name\",
    \"Status\": \"$status\",
    \"HTTP_Status\": \"${http_status:-404}\",
    \"Latency\": \"$latency\"
}"

# Check if json_file is not empty - then append and if it is, append {} into mt file
if [ ! -s "$json_file" ]; then
    echo "{
        \"last_checked\": \"$(date +"%d-%m-%Y_%H:%M:%S")\",
        \"services\": [
            $service_entry
        ]
    }" > "$json_file" 
else
    # File is not empty, we need to append new service
    # We read old content (excluding last closing brackets)
    
    # Creating a temp json file for doing operations in it
    temp_file="$json_file_path/temp.json"
    touch "$temp_file"

    #! Remove Last 2 lines from the file and send all to temp to append other
    head -n -2 "$json_file" > "$temp_file"

    # Append New Service
    echo ",$service_entry" >> "$temp_file"
    echo "      ]" >> "$temp_file"
    echo "}" >> "$temp_file"

    # Move the file to $json_file
    mv "$temp_file" "$json_file"
fi

# Changing Or Appending new date using sed into json file
sed -i "s/\"last_checked\":\".*\"/\"last_checked\":\"$(date +"%d-%m-%Y_%H:%M:%S")\"/" "$json_file"
# echo "Date Changed"