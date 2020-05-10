FROM qeacourse/robodocker:simulatedgzweb
MAINTAINER Paul Ruvolo Paul.Ruvolo@olin.edu

# patch world files in to avoid rebuilding whole docker container
RUN cd /tmp && \
    git clone -b qea https://github.com/comprobo18/comprobo18.git && \
    cp /tmp/comprobo18/neato_gazebo/worlds/*.world /root/catkin_ws/src/comprobo18/neato_gazebo/worlds && \
    rm -rf /tmp/comprobo18

CMD /bin/bash -c "((sleep 10; cd ~/gzweb && npm start)  & (sleep 5; roslaunch rosbridge_server rosbridge_websocket.launch) & (source ~/catkin_ws/devel/setup.bash && roslaunch neato_gazebo neato_no_spawn.launch gui:=false load_camera:=false neato_world:=$NEATO_WORLD))"
