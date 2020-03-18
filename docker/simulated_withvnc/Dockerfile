FROM qeacourse/robodocker:simulated
MAINTAINER Paul Ruvolo Paul.Ruvolo@olin.edu

COPY config /usr/share/fvwm/default-config

CMD /bin/bash -c "((x11vnc -forever -create -autoport 5901) & (source ~/catkin_ws/devel/setup.bash && roslaunch neato_gazebo neato_empty_world.launch))"

