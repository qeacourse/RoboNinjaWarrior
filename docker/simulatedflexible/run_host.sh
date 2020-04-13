#!/bin/bash

# this is an example of running with specific port mappings for VNC and gzweb using host networking mode
docker run --rm --net=host -e GZWEB_PORT=8092 -e ROS_HOSTNAME=deepthought.olin.edu -e ROS_PORT=11312 -e GAZEBO_PORT=11346 -e NEATO_WORLD=empty_no_spawn -it qeacourse/robodocker:simulatedflexible

