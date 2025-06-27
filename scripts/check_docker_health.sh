#!/bin/bash

set -e  # if anything return other than 0 -- exit the script

echo "Checking All Containers Health......"

logs_dir="$(dirname "$0")/../logs"  # we dont want inside scripts we want in root
log_file="$logs_dir/container-health.log"

mkdir -p "$logs_dir"

# Function to fetch name and health check from docker inspect command
fetch_container_status(){
    for id in $(docker ps -q); do
        name=$(docker inspect --format='{{.Name}}' $id | cut -d'/' -f2)
        health=$(docker inspect --format='{{.State.Health.Status}}' $id)
        
        if [ $health == "healthy" ]; then
            echo -e "\e[32m$name is healthy\e[0m"
        elif [ $health == "starting" ]; then
            echo -e "\e[36m$name is starting\e[0m"
        elif [ $health == "unhealthy" ]; then
            echo -e "\e[31m$name is UNHEALTHY\e[0m"
        else
            echo -e "\e[33m$name has no health check defined\e[0m]"
        fi
    done
}


fetch_container_status

# Log output without color codes
log_output=$(fetch_container_status | sed 's/\x1b\[[0-9]*m//g') # x1b is ESC(e)
echo -e "[$(date +"%d-%m-%Y_%H:%M:%S")] Checking Containers Status...\n$log_output\n****************" >> $log_file