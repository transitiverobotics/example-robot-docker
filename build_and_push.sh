#!/bin/bash

# Script to build and push image for both amd64 and arm64

docker buildx build --platform linux/amd64,linux/arm64 -t transitiverobotics/try --push .