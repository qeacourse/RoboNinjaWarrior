#!/bin/bash

docker stop neato;
docker rm --force neato;
# this is an example of running with specific port mappings for VNC and gzweb
docker run --rm --name=neato --mac-address 00:25:90:8c:2e:38 --mount type=bind,source=/usr/local/MATLAB/,target=/usr/local/MATLAB,readonly -p 9000:8080 -p 5900:5900 -e NEATO_WORLD=bod_volcano -it qeacourse/robodocker:simulatedvnc

