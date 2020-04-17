#/bin/bash

if [ "$#" -ne 1 ]; then
    echo "./run.sh instance-id"
    exit 1
fi
let "NO_VNC_PORT=40001 + $1"

docker run --init --gpus=all  --rm -it --mount type=bind,source=/usr/local/MATLAB,target=/usr/local/MATLAB,readonly -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0:rw -p $NO_VNC_PORT:40001 testpruvolo2
