#!/bin/bash

# Simple script to build and run a docker container simulating a robot that
# has the Transitive agent installed and connects to the account specified.
#
# Usage:
# ./run.sh userId robotToken

set -e

# --- build
docker build -t transitiverobotics/try .

# --- run

# generate a random four-digit number
NUMBER=$(tr -dc 0-9 < /dev/urandom | fold -w 4 | head -n 1)

DIR=/tmp/transitive_$NUMBER
mkdir -p $DIR
echo "TR_LABELS=docker" > $DIR/.env_user

docker run -it --rm \
--privileged \
--hostname robot_$NUMBER \
-v $DIR:/root/.transitive \
-v /run/udev:/run/udev \
-v /var/run/dbus:/var/run/dbus -v /var/run/avahi-daemon/socket:/var/run/avahi-daemon/socket \
--name robot \
transitiverobotics/try $@
