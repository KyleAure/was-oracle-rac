#!/bin/bash

# This script will extract logs from all containers and put them in the out/ directory

if [ $# -ne 2 ]; then
    echo "Expected exactly two arguments"
    exit 1
else
    WEBSPHERE_IMAGE=$1
    WEBSPHERE_LOG_DIR=$2
fi

for container in $WEBSPHERE_IMAGE oracle; do
    echo $container
    mkdir -p ./out/$container
    docker logs $container 1> ./out/$container/std.out 2> ./out/$container/std.err
done

docker cp $WEBSPHERE_IMAGE:$WEBSPHERE_LOG_DIR ./out/$WEBSPHERE_IMAGE/