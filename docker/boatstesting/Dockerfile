# This Docker file is used to encapsulate the Neato setup used in various
FROM qeacourse/robodocker:simulatedgzweb
MAINTAINER Paul Ruvolo Paul.Ruvolo@olin.edu

ENV BOAT_WORLD=water

CMD /bin/bash -c "((sleep 10; cd ~/gzweb && npm start) & (sleep 5; roslaunch rosbridge_server rosbridge_websocket.launch) & (source ~/catkin_ws/devel/setup.bash && roslaunch usv_gazebo_plugins $BOAT_WORLD.launch gui:=false))"
