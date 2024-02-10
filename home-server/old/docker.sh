#!/bin/bash

# Check arguments
if [ $# -eq 0 ]; then
    echo "No arg"
    exit 1
fi
if [ $1 = 'up' ]; then
    cmd='up -d'
elif [ $1 = 'down' ]; then
    cmd='down'
else
    echo "up or down"
    exit 1
fi

# Make directories for cloud
mkdir -p /mnt/hdd/cloud

# Run
docker compose -f ./network/docker-compose.yaml $cmd 2> /dev/null
docker compose -f ./proxy/docker-compose.yaml $cmd
docker compose -f ./git/docker-compose.yaml $cmd
docker compose -f ./cloud/docker-compose.yaml $cmd

# Clean
docker compose -f ./network/docker-compose.yaml $cmd 2> /dev/null
docker container rm hs-dummy 1> /dev/null 2> /dev/null

