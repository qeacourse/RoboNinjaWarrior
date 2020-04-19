# This Docker file is used to encapsulate the Neato setup used in various
# Olin College courses
FROM nvidia/opengl:1.0-glvnd-runtime-ubuntu18.04
MAINTAINER Paul Ruvolo Paul.Ruvolo@olin.edu

ENV NEATO_WORLD=empty_no_spawn
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y lsb-release gnupg2 apt-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list && \
    apt-key adv --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
    apt-get update -y && \
    apt-get install -y ros-melodic-desktop-full && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && apt-get install -y \
    software-properties-common \
    ros-melodic-pointcloud-to-laserscan \
    nodejs \
    mercurial \
    git-core \
    mesa-utils \
    libjansson-dev \
    imagemagick \
    wget \
    unzip \ 
    x11vnc \
    xvfb \
    fvwm \
    tcpdump \
    net-tools \
    iputils-ping \
    python-pip \
    libxtst-dev \
    libssl-dev \
    libjpeg-dev \
    vim \
    terminator \
    lubuntu-desktop && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install some more stuff from sourceforge
ARG SOURCEFORGE=https://sourceforge.net/projects
ARG TURBOVNC_VERSION=2.1.2
ARG VIRTUALGL_VERSION=2.5.2
ARG LIBJPEG_VERSION=1.5.2
ARG WEBSOCKIFY_VERSION=0.8.0
ARG NOVNC_VERSION=1.0.0

RUN cd /tmp && \
    curl -fsSL -O ${SOURCEFORGE}/turbovnc/files/${TURBOVNC_VERSION}/turbovnc_${TURBOVNC_VERSION}_amd64.deb \
        -O ${SOURCEFORGE}/libjpeg-turbo/files/${LIBJPEG_VERSION}/libjpeg-turbo-official_${LIBJPEG_VERSION}_amd64.deb \
        -O ${SOURCEFORGE}/virtualgl/files/${VIRTUALGL_VERSION}/virtualgl_${VIRTUALGL_VERSION}_amd64.deb \
        -O ${SOURCEFORGE}/virtualgl/files/${VIRTUALGL_VERSION}/virtualgl32_${VIRTUALGL_VERSION}_amd64.deb && \
    dpkg -i *.deb && \
    rm -f /tmp/*.deb && \
    sed -i 's/$host:/unix:/g' /opt/TurboVNC/bin/vncserver

RUN curl -fsSL https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz | tar -xzf - -C /opt && \
    curl -fsSL https://github.com/novnc/websockify/archive/v${WEBSOCKIFY_VERSION}.tar.gz | tar -xzf - -C /opt && \
    mv /opt/noVNC-${NOVNC_VERSION} /opt/noVNC && \
    chmod -R a+w /opt/noVNC && \
    mv /opt/websockify-${WEBSOCKIFY_VERSION} /opt/websockify && \
    cd /opt/websockify && make && \
    cd /opt/noVNC/utils && \
    ln -s /opt/websockify

COPY xorg.conf /etc/X11/xorg.conf
COPY index.html /opt/noVNC/index.html

# Defeat screen locking and power management
RUN mv /etc/xdg/autostart/light-locker.desktop /etc/xdg/autostart/light-locker.desktop_bak
RUN mv /etc/xdg/autostart/xfce4-power-manager.desktop /etc/xdg/autostart/xfce4-power-manager.desktop_bak

# fix some other errors that tend to pop up and start a terminal at launch time
RUN rm /etc/xdg/autostart/lxpolkit.desktop && \
    rm /etc/xdg/autostart/update-notifier.desktop && \
    mv /usr/bin/lxpolkit /usr/bin/lxpolkit.ORIG && \
    cp /usr/share/applications/terminator.desktop /etc/xdg/autostart/

# Precede bash on all new terminator shells with vglrun so that 3d graphics apps will use the GPU
RUN perl -pi -e 's/^Exec=terminator$/Exec=terminator -e "vglrun bash"/g' /usr/share/applications/terminator.desktop	

# Setup catkin workspace and ROS environment.
RUN /bin/bash -c "source /opt/ros/melodic/setup.bash && \
                  mkdir -p ~/catkin_ws/src && \
                  cd ~/catkin_ws/src && \
		  git clone -b qea https://github.com/comprobo18/comprobo18.git && \
                  cd .. && \
		  catkin_make && \
                  echo 'source ~/catkin_ws/devel/setup.bash' >> ~/.bashrc"

RUN /bin/bash -c "mkdir -p ~/.gazebo/models; cp -r ~/catkin_ws/src/comprobo18/neato_gazebo/model/* ~/.gazebo/models"

# get the rest of the Gazebo models

COPY dl_models.sh /tmp
RUN /bin/bash -c "/tmp/dl_models.sh"

ENV GAZEBO_MODEL_PATH=/root/.gazebo/models

RUN /bin/bash -c "mkdir ~/.gazebo/models/mobile_base && \
                  mkdir ~/.gazebo/models/mobile_base_with_camera && \
                  source ~/catkin_ws/devel/setup.bash && \
                  cp ~/catkin_ws/src/comprobo18/neato_robot/neato_description/sdf/neato.sdf ~/.gazebo/models/mobile_base/model.sdf && \
                  cp ~/catkin_ws/src/comprobo18/neato_robot/neato_description/sdf/neato_with_camera.sdf ~/.gazebo/models/mobile_base_with_camera/model.sdf && \
                  cp ~/catkin_ws/src/comprobo18/neato_robot/neato_description/model.config ~/.gazebo/models/mobile_base && \
                  cp ~/catkin_ws/src/comprobo18/neato_robot/neato_description/model_with_camera.config ~/.gazebo/models/mobile_base_with_camera/model.config && \
                  cp -r ~/catkin_ws/src/comprobo18/neato_robot/neato_description/meshes ~/.gazebo/models/mobile_base"

ENV PATH /root:${PATH}:/opt/VirtualGL/bin:/opt/TurboVNC/bin:/root:/usr/local/MATLAB/R2020a/bin

ENV DISPLAY :1

RUN /bin/bash -c "mkdir -p /root/Desktop"
COPY ./terminator.desktop /root/Desktop
RUN mkdir -p /root/.config/terminator
COPY terminator_config /root/.config/terminator/config

RUN /bin/bash -c "mkdir -p /root/.vnc"
COPY ./xstartup.turbovnc /root/.vnc/xstartup.turbovnc
RUN chmod a+x /root/.vnc/xstartup.turbovnc
COPY self.pem /root/self.pem
COPY launch /root/
COPY matlab /root/

RUN /bin/bash -c "cd /tmp && \
                  git clone https://github.com/qeacourse/RoboNinjaWarrior && \
                  cp -r /tmp/RoboNinjaWarrior/Sample_code ~ && \
		  rm -rf /tmp/RoboNinjaWarrior"


RUN echo "echo \"type the command \\\"launch neato_world\\\" to launch the simulator\"" >> /root/.bashrc
RUN echo "echo \"for example, the command \\\"launch bod_volcano\\\" will load the world for the Bridge of Doom\"" >> /root/.bashrc

COPY start_desktop.sh /usr/local/bin/start_desktop.sh
CMD /usr/local/bin/start_desktop.sh
