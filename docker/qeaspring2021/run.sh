#!/bin/bash

/opt/TurboVNC/bin/vncserver -SecurityTypes None
DISPLAY_NUM=`/opt/TurboVNC/bin/vncserver -list | grep -m 1 "^:" | sed 's/^:\([0-9]*\).*/\1/'`
export DISPLAY=:$DISPLAY_NUM
xsetroot -solid grey
/usr/bin/lxsession -s Lubuntu &

let "VNC_PORT=5900 + $DISPLAY_NUM"

# start Gazebo if needed
if [ -z "$ROS_PKG" ]
then
    echo "not launching a world"
else
    # start MATLAB
    cd /root
    matlab &
    source ~/catkin_ws/devel/setup.bash
    (sleep 10; roslaunch rosbridge_server rosbridge_websocket.launch) &
    roslaunch $ROS_PKG $LAUNCH_FILE &
fi

# 3. start noVNC
/noVNC-1.1.0/utils/launch.sh --vnc localhost:$VNC_PORT --listen 8081 --cert /root/self.pem
