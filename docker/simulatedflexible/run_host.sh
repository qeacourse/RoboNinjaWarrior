#!/bin/bash


if [ "$#" -ne 1 ]; then
    echo "./run_host.sh instance-id"
    exit 1
fi
let "ROS_PORT=11311 + $1"
let "GAZEBO_PORT=11345 + $1"
let "GZWEB_PORT=8900 + $1"

# this is an example of running with specific port mappings for VNC and gzweb using host networking mode
docker run --rm --net=host -e GZWEB_PORT=$GZWEB_PORT -e ROS_HOSTNAME=deepthought.olin.edu -e ROS_PORT=$ROS_PORT -e GAZEBO_PORT=$GAZEBO_PORT -e NEATO_WORLD=empty_no_spawn -it qeacourse/robodocker:simulatedflexible
