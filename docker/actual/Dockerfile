FROM qeacourse/robodocker:simulated
MAINTAINER Paul Ruvolo Paul.Ruvolo@olin.edu

ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_HOSTNAME=10.0.75.2

CMD /bin/bash -c "(sleep 10; xpra start --start=rviz --bind-tcp=0.0.0.0:14500) & (source ~/catkin_ws/devel/setup.bash && roslaunch neato_node bringup_minimal.launch host:=$HOST use_udp:=false)"

