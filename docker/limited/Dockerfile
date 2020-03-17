FROM qeacourse/robodocker:simulated
MAINTAINER Paul Ruvolo Paul.Ruvolo@olin.edu

ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_HOSTNAME=0.0.0.0

CMD /bin/bash -c "echo \"net.ipv4.ip_local_port_range = 32768 33000\" >> /etc/sysctl.conf"

CMD /bin/bash -c "((sleep 10; xpra start --start=gzclient --bind-tcp=0.0.0.0:14500) & (source ~/catkin_ws/devel/setup.bash && roslaunch neato_gazebo neato_flatland_world.launch))"

