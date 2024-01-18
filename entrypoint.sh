#!/bin/bash

if [ ! -e $HOME/.transitive/.installation_complete ]; then
  cp -r /transitive-preinstalled/. $HOME/.transitive
  rm -rf /transitive-preinstalled
fi;

cd $HOME/.transitive

# Optionally you can set a custom device name:
# export TR_INSTALL_HASH=my_bot_name

if [[ ! -z $1 ]]; then
  sed -i "s/TR_USERID=.*/TR_USERID=$1/" .env;
fi;

if [[ ! -z $2 ]]; then
  echo "TR_ROBOT_TOKEN=$2" > .token;
fi;

if [[ ! -z $3 ]]; then
  # A different install host was provided, mostly used for local dev.

  # remove existing lines
  sed -i '/^TR_INSTALL_HOST/d' .env;
  sed -i '/^TR_HOST/d' .env;

  # extract TR_HOST from install host
  HOST=$(echo $3 | sed 's/https\{0,1\}:\/\/install.//')
  echo "TR_INSTALL_HOST=$3" >> .env
  echo "TR_HOST=$HOST" >> .env

  # update .npmrc to use local registry
  echo "# Set our registry for our scoped packages" > .npmrc
  echo "@transitive-robotics:registry=https://registry.transitiverobotics.com" >> .npmrc
  echo "@local:registry=http://registry.$HOST" >> .npmrc

  if [[ "$3" == *local ]]; then
    # See https://github.com/transitiverobotics/transitive/blob/main/cloud/tools/mDNS/README.md
    echo "Using a .local install domain: adding mDNS support"
    apt-get update && apt-get install -y avahi-utils
    sed -i "s/mdns4_minimal/mdns4 mdns4_minimal/" /etc/nsswitch.conf
    echo -e ".local.\n.local\n" >> /etc/mdns.allow
  fi
fi;

. /opt/ros/noetic/setup.bash
roscore &

bash start_agent.sh
