#!/bin/bash

# Script to build and push image for both amd64 and arm64

# Assumes you have already created a builder called `mybuilder` using:
# docker buildx create --name mybuilder --bootstrap

# first arg is ros distro
ROS_DISTRO=$1


docker buildx build \
    --builder mybuilder \
    --platform linux/amd64,linux/arm64 \
    --build-arg ROS_DISTRO=$ROS_DISTRO \
    -t transitiverobotics/try \
    --push .
