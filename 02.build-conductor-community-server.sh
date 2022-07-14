#!/bin/sh

# Display commands and exit on error
set -ex 

# Copy config and startup files
cd conductor-community

# Build Conductor Server
docker build -t conductor-community:server -f docker/Dockerfile .
