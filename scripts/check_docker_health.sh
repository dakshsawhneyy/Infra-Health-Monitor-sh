#!/bin/bash

# docker inspect --format='{{.Name}} -> Health_Status: {{.State.Health.Status}}' my-nginx
# docker ps --format='{{.Names}} -> {{.Status}}\tID: {{.ID}}'

echo "Checking All Containers Health......"

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