#!/bin/bash

website_file_path="$(dirname "$0")/../config"
website_file="$website_file_path/services.txt"

log_file_path="$(dirname "$0")/../logs"
log_file="$log_file_path/website-health.log"

mkdir -p "$log_file_path"

echo -e "\e[30m\nChecking website uptime...\e[0m"

echo -e "\e[34m===========================================\e[0m"

while IFS= read -r line; do     # using IFS to read because for loop will break word into pieces
    website=$(echo "$line" | cut -d'=' -f2 | sed 's/"//g' | tr -d '\r') 
    if [ -n "$website" ]; then
        status_code=$(curl -Is --max-time 5 "https://$website" | head -n 1 | awk '{print $2}')
        if [[ $status_code -eq 200 ]]; then
            echo -e "\e[32m$website is UP (HTTP $status_code)\e[0m"
        else
            echo -e "\e[31m$website is DOWN (HTTP ${status_code:-404})\e[0m"
            echo -e "\nTriggering alert for $website with status code ${status_code:-404}\n"
            # :- means send status code and if it is not present send 404 as status code
            bash "$(dirname "$0")/alert.sh" "CRITICAL" "Website is DOWN: $website returned HTTP ${status_code:-404}"
        fi
        # Sending Text to Log File
        {
            echo "$(date +"%d-%m-%Y_%H:%M:%S") ---- $website returned HTTP ${status_code:-404}"
        } >> "$log_file"
    fi
    
done < "$website_file"
echo -e "\n\e[35mWebsite check completed. Logs saved to: $log_file\e[0m"
echo "===========================================" >> "$log_file"
echo -e "\e[34m===========================================\e[0m\n"
# echo "$website_file"  # Uncomment for debugging: prints the path to the services.txt file