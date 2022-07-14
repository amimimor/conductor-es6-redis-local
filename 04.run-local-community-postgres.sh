#!/bin/sh

cd docker/

docker-compose -f docker-compose-community.yaml -f docker-compose-postgres.yaml up
