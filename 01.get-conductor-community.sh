#!/bin/sh

CONDUCTOR_VERSION=v3.10.0

# Display commands and exit on error
set -ex 

# Remove the conductor folder so we start fresh
rm -rf conductor/
rm -rf conductor-community/

# Get Conductor
git clone -c advice.detachedHead=false -c core.autocrlf=false --depth 1 -b ${CONDUCTOR_VERSION} https://github.com/Netflix/conductor.git ./conductor
git apply ./${CONDUCTOR_VERSION}-update-dockerfile.patch
cd conductor
git commit -a -m "Applied patches on conductor"
cd ..
# Get Conductor Community
git clone -c advice.detachedHead=false -c core.autocrlf=false --depth 1 -b ${CONDUCTOR_VERSION} https://github.com/Netflix/conductor-community.git ./conductor-community

cd conductor-community

# Delete dependencies.lock files
# rm -f **/dependencies.lock
# rm -f ./dependencies.lock


mkdir -p docker
cp  ../conductor/docker/server/Dockerfile ./docker/
# overwrite the non community files that are shared across the projects
cp -rf ../docker/bin ./docker/bin
# make sure we are not using the irrelevant startup script
rm ./docker/bin/startup.sh
cp -rf ../docker/config ./docker/config


# Apply patches
# Update to es7 (postgres is built in community)
git apply ../${CONDUCTOR_VERSION}-update-to-es7.patch
git commit -a -m "Applied patches"
