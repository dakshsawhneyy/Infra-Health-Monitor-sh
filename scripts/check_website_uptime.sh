#!/bin/bash

website_file_path="$(dirname "$0")/../config"
website_file="$website_file_path/services.txt"

log_file_path="$(dirname "$0")/../logs"
log_file="$log_file_path/website-health.log"

# This folder will hold tiny files that act as markers telling us "We have already sent alert for this website."
alert_path="$(dirname "$0")/../alert_flags" # Alert Flags Folder Path - which contain flag for down site

mkdir -p "$log_file_path"
touch "$log_file"

echo -e "\e[30m\nChecking website uptime...\e[0m"
echo -e "\e[34m===========================================\e[0m"

while read -r line; do     # using IFS to read because for loop will break word into pieces and by default it is line
    website=$(echo "$line" | cut -d'=' -f2 | sed 's/"//g' | tr -d '\r') 
    if [ -n "$website" ]; then
        status_code=$(curl -Is --max-time 5 "https://$website" | head -n 1 | awk '{print $2}')
        latency=$(curl -o /dev/null -s -w '%{time_total}\n' "https://$website")
        status="UP"

        # flag_file creation using A fixed-length "fingerprint" (32 characters) -- md5sum
        flag_file="$alert_path/$(echo "$website" | md5sum | awk '{print $1}').flag" 

        if [[ $status_code -eq 200 ]]; then
            echo -e "\e[32m$website is UP (HTTP $status_code)\e[0m"

            # if flag is present, remove it because now website is up
            if [ -f "$flag_file" ];then
                # echo "Remove the flag"
                bash "$(dirname "$0")/alert.sh" "UP" "Website is UP: $website returned HTTP ${status_code:-404}"
                rm -rf "$flag_file"
            fi

        else
            echo -e "\e[31m$website is DOWN (HTTP ${status_code:-404})\e[0m"
            status="DOWN"

            # If Flag exists do nothing and if not -- create and send notif to slack
            if [ ! -f "$flag_file" ]; then
                # echo "Send Notification to Slack" echo "Create Flag"
                touch "$flag_file"
                echo -e "\nTriggering alert for $website with status code ${status_code:-404}\n"
                # :- means send status code and if it is not present send 404 as status code
                bash "$(dirname "$0")/alert.sh" "CRITICAL" "Website is DOWN: $website returned HTTP ${status_code:-404}"
            fi 

        fi

        # Calling dashboard script to send data to json file
        bash "$(dirname "$0")/dashboard.sh" "$website" "$status" "$status_code" "$latency"

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