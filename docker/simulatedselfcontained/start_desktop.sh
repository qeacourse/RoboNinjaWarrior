#!/bin/bash -x

# start a virtual X-server (could be replaced by a real one if we ever get hardware acceleration working with virtual GL
Xvfb -shmem -screen 0 1280x1024x24 &

# When using a virtual X-server, not sure if any of the rest of this is actually needed
# Start XVnc/X/Lubuntu
chmod -f 777 /tmp/.X11-unix
# From: https://superuser.com/questions/806637/xauth-not-creating-xauthority-file (squashes complaints about .Xauthority)
touch ~/.Xauthority
xauth generate :0 . trusted
/opt/TurboVNC/bin/vncserver -SecurityTypes None $DISPLAY


# Start NoVNC. self.pem is a self-signed cert.
if [ $? -eq 0 ] ; then
    /opt/noVNC/utils/launch.sh --vnc localhost:5901 --cert /home/rnw/self.pem --listen 40001;
fi
