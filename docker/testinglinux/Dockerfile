FROM qeacourse/robodocker:spring2020
MAINTAINER Paul Ruvolo Paul.Ruvolo@olin.edu

COPY setup-docker-host-internal.sh /usr/local/bin

CMD /bin/bash -c "(setup-docker-host-internal.sh & (sleep 10; cd ~/gzweb && npm start) & (source ~/catkin_ws/devel/setup.bash && roslaunch neato_gazebo neato_no_spawn.launch gui:=false load_camera:=false neato_world:=$NEATO_WORLD))"

