#!/bin/bash

# Simple script to build and run a docker container simulating a robot that
# has the Transitive agent installed and connects to the account specified.
#
# Usage:
# ./run.sh userId robotToken [base image]

set -e

TAGNAME=
BUILDARGS=
if [[ $# > 2 ]]; then
  TAGNAME+=_${3/:/-}
  BUILDARGS+="--build-arg BASE_IMAGE=$3"
fi;

echo $BUILDARGS

# --- build
docker build ${BUILDARGS} -t transitiverobotics/try${TAGNAME} .

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
