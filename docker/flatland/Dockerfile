FROM qeacourse/robodocker:simulated
MAINTAINER Paul Ruvolo Paul.Ruvolo@olin.edu

CMD /bin/bash -c "((x11vnc -forever -create -autoport 5901) & (source ~/catkin_ws/devel/setup.bash && roslaunch neato_gazebo neato_flatland_world.launch gui:=false))"
