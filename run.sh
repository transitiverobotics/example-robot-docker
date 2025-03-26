#!/bin/bash

# Simple script to build and run a docker container simulating a robot that
# has the Transitive agent installed and connects to the account specified.
#
# Usage:
# ./run.sh rosDistro userId robotToken [installHost]

set -e

# first arg is ros distro
ROS_DISTRO=$1

# --- build
docker build --build-arg ROS_DISTRO=$ROS_DISTRO -t transitiverobotics/try_$ROS_DISTRO .

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
transitiverobotics/try_$ROS_DISTRO $2 $3 $4
