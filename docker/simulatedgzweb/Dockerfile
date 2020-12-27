# This Docker file is used to encapsulate the Neato setup used in various
# Olin College courses
FROM osrf/ros:melodic-desktop-full-bionic
MAINTAINER Paul Ruvolo Paul.Ruvolo@olin.edu

ENV NEATO_WORLD=empty_no_spawn
ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_HOSTNAME=0.0.0.0

# Install Node.js 10.x repository
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

# install ROS and other packages
RUN apt-get update && apt-get install -y \
    software-properties-common \
    ros-melodic-pointcloud-to-laserscan \
    ros-melodic-geographic-msgs \
    nodejs \
    libjansson-dev \
    imagemagick \
    wget \
    unzip \ 
    hping3 \
    x11vnc \
    xvfb \
    fvwm \
    tcpdump \
    net-tools \
    iputils-ping \
    python-pip \
    vim \
    xpra && \
    setcap cap_net_raw+ep /usr/sbin/hping3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install rosbridge
RUN apt-get update && apt-get install -y \
    ros-melodic-rosbridge-suite && \
    pip install tornado pymongo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setup catkin workspace and ROS environment.
RUN /bin/bash -c "source /opt/ros/melodic/setup.bash && \
                  mkdir -p ~/catkin_ws/src && \
                  cd ~/catkin_ws/src && \
		  git clone -b qea https://github.com/comprobo18/comprobo18.git && \
		  git clone https://github.com/qeacourse/vrx && \
                  catkin_init_workspace"

RUN /bin/bash -c "source /opt/ros/melodic/setup.bash && \
                  cd ~/catkin_ws/ && \
		  catkin_make && \
                  echo 'source ~/catkin_ws/devel/setup.bash' >> ~/.bashrc"

COPY xsession /root/.xsession
COPY config /usr/share/fvwm/default-config

RUN /bin/bash -c "mkdir ~/.vnc && \
		  mkdir ~/.rviz && \
		  x11vnc -storepasswd 1234 ~/.vnc/passwd && \
		  chmod u+x ~/.xsession"

COPY default.rviz ~ros/.rviz

RUN /bin/bash -c "mkdir -p ~/.gazebo/models; cp -r ~/catkin_ws/src/comprobo18/neato_gazebo/model/* ~/.gazebo/models; mkdir -p ~/.gazebo/models/bod/meshes; cp ~/catkin_ws/src/vrx/usv_gazebo_plugins/meshes/*.stl ~/.gazebo/models/bod/meshes"

# get the rest of the Gazebo models
COPY dl_models.sh /tmp
RUN /bin/bash -c "/tmp/dl_models.sh"

ENV GAZEBO_MODEL_PATH=/root/.gazebo/models

RUN /bin/bash -c "mkdir ~/.gazebo/models/mobile_base && \
		  source ~/catkin_ws/devel/setup.bash && \
		  cp ~/catkin_ws/src/comprobo18/neato_robot/neato_description/sdf/neato.sdf ~/.gazebo/models/mobile_base/model.sdf && \
		  cp ~/catkin_ws/src/comprobo18/neato_robot/neato_description/model.config ~/.gazebo/models/mobile_base && \
		  cp -r ~/catkin_ws/src/comprobo18/neato_robot/neato_description/meshes ~/.gazebo/models/mobile_base"

RUN /bin/bash -c "cd ~ && \
		  git clone https://github.com/qeacourse/gzweb && \
		  cd gzweb && \
		  git checkout gzweb_1.4.0 && \
		  source /usr/share/gazebo/setup.sh && \
		  xvfb-run -s \"-screen 0 1280x1024x24\" npm run deploy --- -m local -t && \
		  cp -r /usr/share/gazebo-9/media/* ~/gzweb/http/client/assets"

CMD /bin/bash -c "((sleep 10; cd ~/gzweb && npm start) & (sleep 5; roslaunch rosbridge_server rosbridge_websocket.launch) & (source ~/catkin_ws/devel/setup.bash && roslaunch neato_gazebo neato_no_spawn.launch gui:=false load_camera:=false neato_world:=$NEATO_WORLD))"
