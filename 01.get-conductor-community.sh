#!/bin/sh

CONDUCTOR_VERSION=main

# Display commands and exit on error
set -ex 

# Remove the conductor folder so we start fresh
rm -rf conductor/
rm -rf conductor-community/

# Get Conductor
git clone -c advice.detachedHead=false -c core.autocrlf=false --depth 1 -b ${CONDUCTOR_VERSION} https://github.com/Netflix/conductor.git ./conductor

# Get Conductor Community
git clone -c advice.detachedHead=false -c core.autocrlf=false --depth 1 -b ${CONDUCTOR_VERSION} https://github.com/Netflix/conductor-community.git ./conductor-community

cd conductor-community

# Delete dependencies.lock files
rm -f **/dependencies.lock
rm -f ./dependencies.lock

mkdir -p docker
cp  ../conductor/docker/server/Dockerfile ./docker/
# overwrite the non community files that are shared across the projects
cp -rf ../docker/* ./docker/

# Apply patches
# Update to es7 (postgres is built in community)
git apply ../${CONDUCTOR_VERSION}-update-to-es7.patch
git commit -a -m "Applied patches"
