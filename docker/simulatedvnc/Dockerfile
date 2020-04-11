# This Docker file is used to encapsulate the Neato setup used in various
# Olin College courses
FROM osrf/ros:melodic-desktop-full-bionic
MAINTAINER Paul Ruvolo Paul.Ruvolo@olin.edu

ENV NEATO_WORLD=empty_no_spawn
ENV DEBIAN_FRONTEND=noninteractive

RUN useradd -ms /bin/bash pruvolo -G sudo -p $(openssl passwd -1 qea)

# Install Node.js 10.x repository
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

# install ROS and other packages
RUN apt-get update && apt-get install -y \
    software-properties-common \
    ros-melodic-pointcloud-to-laserscan \
    nodejs \
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
    vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /tmp && \
    wget http://x11vnc.sourceforge.net/dev/x11vnc-0.9.14-dev.tar.gz && \
    gzip -dc x11vnc-0.9.14-dev.tar.gz | tar -xvf - && \	
    cd x11vnc-0.9.14/ && \
    ./configure --prefix=/usr/ CFLAGS='-g -O2 -fno-stack-protector -Wall' && \
    make && \
    make install

USER pruvolo

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

RUN /bin/bash -c "mkdir -p ~/.gazebo/models; cp -r ~/catkin_ws/src/comprobo18/neato_gazebo/model/* ~/.gazebo/models"

# get the rest of the Gazebo models

COPY dl_models.sh /tmp
RUN /bin/bash -c "/tmp/dl_models.sh"

ENV GAZEBO_MODEL_PATH=/home/pruvolo/.gazebo/models

RUN /bin/bash -c "mkdir ~/.gazebo/models/mobile_base && \
		  source ~/catkin_ws/devel/setup.bash && \
		  cp ~/catkin_ws/src/comprobo18/neato_robot/neato_description/sdf/neato.sdf ~/.gazebo/models/mobile_base/model.sdf && \
		  cp ~/catkin_ws/src/comprobo18/neato_robot/neato_description/model.config ~/.gazebo/models/mobile_base && \
		  cp -r ~/catkin_ws/src/comprobo18/neato_robot/neato_description/meshes ~/.gazebo/models/mobile_base"

RUN /bin/bash -c "cd ~ && \
		  hg clone https://bitbucket.org/osrf/gzweb && \
		  cd gzweb && \
		  hg up gzweb_1.4.0 && \
		  source /usr/share/gazebo/setup.sh && \
		  xvfb-run -s \"-screen 0 1280x1024x24\" npm run deploy --- -m local"

ENV PATH="/usr/local/MATLAB/R2020a/bin/:${PATH}"
 
COPY xsession /home/pruvolo/.xsession

RUN /bin/bash -c "mkdir ~/.vnc && \
                  x11vnc -storepasswd 1234 ~/.vnc/passwd"

USER root
COPY config /usr/share/fvwm/default-config
RUN /bin/bash -c "chown pruvolo:pruvolo /home/pruvolo/.xsession"
RUN /bin/bash -c "chmod u+x /home/pruvolo/.xsession"

USER pruvolo

CMD /bin/bash -c "((x11vnc -create -rfbauth /home/pruvolo/.vnc/passwd -forever -autoport 5900) & (sleep 10; cd ~/gzweb && npm start) & (source ~/catkin_ws/devel/setup.bash && roslaunch neato_gazebo neato_no_spawn.launch gui:=false load_camera:=false neato_world:=$NEATO_WORLD))"
