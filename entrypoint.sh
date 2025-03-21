#!/bin/bash

if [ ! -e $HOME/.transitive/.installation_complete ]; then
  cp -r /transitive-preinstalled/. $HOME/.transitive
  rm -rf /transitive-preinstalled
fi;

cd $HOME/.transitive

# Optionally you can set a custom device name:
# export TR_INSTALL_HASH=my_bot_name

if [[ ! -z $2 ]]; then
  sed -i "s/TR_USERID=.*/TR_USERID=$2/" .env;
fi;

if [[ ! -z $3 ]]; then
  echo "TR_ROBOT_TOKEN=$3" > .token;
fi;

if [[ ! -z $4 ]]; then
  # A different install host was provided, mostly used for local dev. Update
  # .env and .npmrc and setup mDNS support. Compare to install.sh.

  # extract TR_HOST from install host
  HOST=$(echo $4 | sed 's/https\{0,1\}:\/\/install.//')

  # Update .env
  sed -i '/^TR_INSTALL_HOST/d' .env;
  sed -i '/^TR_HOST/d' .env;
  echo "TR_INSTALL_HOST=$4" >> .env
  echo "TR_HOST=$HOST" >> .env

  if [[ "$4" == *local ]]; then
    # See https://github.com/transitiverobotics/transitive/blob/main/cloud/tools/mDNS/README.md
    echo "Using a .local install domain: adding mDNS support"
    sed -i "s/mdns4_minimal/mdns4 mdns4_minimal/" /etc/nsswitch.conf
    echo -e ".local.\n.local\n" >> /etc/mdns.allow
  fi

  # update .npmrc from install host (this requires mDNS)
  curl -sf $4/files/.npmrc -o .npmrc

fi;

. /opt/ros/$1/setup.bash
bash start_agent.sh
