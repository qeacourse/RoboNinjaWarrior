FROM qeacourse/robodocker:simulated
MAINTAINER Paul Ruvolo Paul.Ruvolo@olin.edu

CMD /bin/bash -c "((sleep 10; xpra start --start=gzclient --bind-tcp=0.0.0.0:14500) & (source ~/catkin_ws/devel/setup.bash && roslaunch neato_gazebo neato_flatland_world.launch))"

