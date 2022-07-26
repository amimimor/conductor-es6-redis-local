#!/bin/sh

# Display commands and exit on error
set -ex 

die () {
    echo >&2 "$@"
    exit 1
}


[ "$#" -eq 1 ] || die "1 argument is required specifying conductor tag in the format of vX.Y.Z, $# provided; for example: ./03.build-conductor-ui.sh v3.10.0"

CONDUCTOR_VERSION=$1
cd conductor-$CONDUCTOR_VERSION/docker

docker build -t conductor-ui:$CONDUCTOR_VERSION -f ui/Dockerfile ../
