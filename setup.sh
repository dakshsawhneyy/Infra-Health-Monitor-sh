#!/bin/bash

docker run -d \
    --name my-nginx \
    --health-cmd='curl -f http://localhost:80/ || exit 1' \
    --health-interval=30s \
    --health-timeout=5s \
    --health-retries=3 \
    --health-start-period=10s \
    nginx

docker run -d\
    --name my-sql \
    -e MYSQL_ROOT_PASSWORD=root \
    --health-cmd='mysqladmin ping -h localhost' \
    --health-interval=30s \
    --health-timeout=5s \
    --health-retries=3 \
    --health-start-period=10s \
    mysql:latest