#!/bin/bash

if [ ! -e $HOME/.transitive/.installation_complete ]; then
  cp -r /transitive-preinstalled/. $HOME/.transitive
  rm -rf /transitive-preinstalled
fi;

cd $HOME/.transitive

# Optionall you can set a custom device name:
# export TR_INSTALL_HASH=my_bot_name

if [[ ! -z $1 ]]; then
  sed -i "s/TR_USERID=.*/TR_USERID=$1/" .env;
fi;

if [[ ! -z $2 ]]; then
  echo "TR_ROBOT_TOKEN=$2" > .token;
fi;

. /opt/ros/noetic/setup.bash
roscore &

bash start_agent.sh
