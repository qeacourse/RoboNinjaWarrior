FROM qeacourse/robodocker:simulated
MAINTAINER Paul Ruvolo Paul.Ruvolo@olin.edu

CMD /bin/bash -c "((Xvfb -shmem -screen 0 1280x1024x24) & (x11vnc -create -forever -autoport 5901 -geometry 1024x768) & (sleep 2 && source ~/catkin_ws/devel/setup.bash && roslaunch neato_gazebo neato_flatland_world.launch gui:=false load_camera:=$LOAD_CAMERA))"
