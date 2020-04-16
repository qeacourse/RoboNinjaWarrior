#/bin/bash

docker run --init --gpus=all  --rm -it  --mount type=bind,source=/usr/local/MATLAB,target=/usr/local/MATLAB,readonly --mac-address 00:25:90:8c:2e:38 -e DISPLAY=:1 -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0:rw -p 40001:40001 testpruvolo
