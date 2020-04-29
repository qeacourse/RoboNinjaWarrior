#!/bin/bash

let "NO_VNC_PORT=40001 + $1"

docker run --init -it --rm --mount type=bind,source=/usr/local/MATLAB,target=/usr/local/MATLAB,readonly -p $NO_VNC_PORT:40001 qeacourse/robodocker:selfcontained
