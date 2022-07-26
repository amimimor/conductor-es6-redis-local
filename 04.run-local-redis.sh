#!/bin/sh

set -ex 

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 2 ] || die "2 arguments are required: 1. specifying conductor tag in the format of vX.Y.Z; 2. specify the startup.sh script type [local,redis,postgres], $# provided; for example: ./02.build-conductor-server.sh v3.10.0 redis"

export CONDUCTOR_VERSION=$1
export START_TYPE=$2

cd docker/

docker-compose -f docker-compose.yaml -f docker-compose-redis.yaml up 
