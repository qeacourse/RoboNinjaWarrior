# This Docker file is used to encapsulate the Neato setup used in various
# Olin College courses
FROM osrf/ros:melodic-desktop-full-bionic
MAINTAINER Paul Ruvolo Paul.Ruvolo@olin.edu

ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_HOSTNAME=10.0.75.2


#generic xforwarding instructions (can embed in dockerfile probably)
#docker run -ti --rm \
#       -e DISPLAY=$DISPLAY \
#       -v /tmp/.X11-unix:/tmp/.X11-unix \
#       firefox
#RUN useradd -ms /bin/bash ros
#USER ros

# install ros packages
RUN apt-get update && apt-get install -y \
    software-properties-common \
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

# setup files required for x11vnc
# To start the x11vnc server use: docker exec container_name x11vnc -forever -usepw -create
RUN /bin/bash -c "mkdir ~/.vnc && \
		  mkdir ~/.rviz && \
		  x11vnc -storepasswd 1234 ~/.vnc/passwd && \
		  chmod u+x ~/.xsession"

COPY default.rviz ~ros/.rviz

CMD /bin/bash -c "(sleep 10; xpra start --start=gzclient --bind-tcp=0.0.0.0:14500) & (source ~/catkin_ws/devel/setup.bash && roslaunch neato_simulator neato_playground.launch)"
