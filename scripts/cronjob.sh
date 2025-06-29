#!/bin/bash

# Calling 3 scripts so we can add this script in crontab
echo -e "\e[30m\nRunning cron jobs...\e[0m"
bash $(dirname "$0")/check_website_uptime.sh

echo -e "\e[34m===========================================\e[0m"

echo -e "\e[30mRunning log rotation...\e[0m"
bash $(dirname "$0")/log_rotate.sh

echo -e "\e[34m===========================================\e[0m"

echo -e "\e[30mRunning heartbeat script...\e[0m"
bash $(dirname "$0")/heartbeat.sh