# This Docker file is used to encapsulate the Neato setup used in various
# Olin College courses
FROM osrf/ros:melodic-desktop-full-bionic
MAINTAINER Paul Ruvolo Paul.Ruvolo@olin.edu

ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_HOSTNAME=0.0.0.0

# install ros packages
RUN apt-get update && apt-get install -y \
    software-properties-common \
    ros-melodic-pointcloud-to-laserscan \
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


# Setup catkin workspace and ROS environment.
RUN /bin/bash -c "source /opt/ros/melodic/setup.bash && \
                  mkdir -p ~/catkin_ws/src && \
                  cd ~/catkin_ws/src && \
		  git clone -b qea https://github.com/comprobo18/comprobo18.git && \
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

RUN /bin/bash -c "mkdir -p ~/.gazebo/models; cp -r ~/catkin_ws/src/comprobo18/neato_simulator/model/flatland ~/.gazebo/models"

# get the rest of the Gazebo models
COPY dl_models.sh /tmp
RUN /bin/bash -c "/tmp/dl_models.sh"

ENV DISPLAY=:0
CMD /bin/bash -c "((x11vnc -forever -create -autoport 5901) & (Xvfb -shmem -screen 0 1280x1024x24) & (source ~/catkin_ws/devel/setup.bash && sleep 2 && roslaunch neato_gazebo neato_empty_world.launch))"
