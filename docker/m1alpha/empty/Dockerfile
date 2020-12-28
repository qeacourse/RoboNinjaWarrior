FROM testm1
MAINTAINER Paul Ruvolo Paul.Ruvolo@olin.edu

CMD /bin/bash -c "((sleep 10; cd ~/gzweb && npm start)  & (sleep 5; roslaunch rosbridge_server rosbridge_websocket.launch) & (source ~/catkin_ws/devel/setup.bash && roslaunch gazebo_ros empty_world.launch gui:=false))"
