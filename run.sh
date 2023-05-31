#!/bin/bash

# example usage:
# ./run.sh ros:noetic

set -e

BUILDARGS=""
TAGNAME=robot
if [[ $# > 0 ]]; then
  TAGNAME+=_${1/:/-}
  BUILDARGS+="--build-arg BASE_IMAGE=$1"
fi;

# generate a random four-digit number
NUMBER=$(tr -dc 0-9 < /dev/urandom | fold -w 4 | head -n 1)

. .env
BUILDARGS+=" --build-arg USERID=$USERID"
BUILDARGS+=" --build-arg TOKEN=$TOKEN"

docker build $BUILDARGS -t $TAGNAME .

DIR=/tmp/transitive_$NUMBER
mkdir -p $DIR
echo "TR_LABELS=docker" > $DIR/.env_user

docker run -it --rm \
--privileged \
--hostname robot_$TAGNAME_$NUMBER \
-v $DIR:/root/.transitive \
-v /run/udev:/run/udev \
--name robot \
$TAGNAME $2

# --device=/dev/video0 \
# -v /sys:/sys \
# -v /dev:/dev \
# -e UDEV=1 \