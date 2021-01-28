FROM qeacourse/robodocker:qeasimnogpu
MAINTAINER Paul Ruvolo Paul.Ruvolo@olin.edu

RUN /bin/bash -c "cd /tmp && \
                  git clone https://github.com/qeacourse/RoboNinjaWarrior && \
                  cp -r /tmp/RoboNinjaWarrior/Sample_code ~ && \
		  cd ~/catkin_ws/src/vrx && \
                  git pull && \
                  cp ~/catkin_ws/src/vrx/usv_gazebo_plugins/matlab_examples/*.m ~/matlab_boats && \
		  cd ~/catkin_ws/src/comprobo18 && \
                  git pull && \
                  cp ~/catkin_ws/src/comprobo18/com_workshop/matlab_examples/*.m ~/matlab_boats && \
                  rm -rf /tmp/RoboNinjaWarrior"

RUN pip install future
RUN echo "/root/matlab" >> /usr/local/MATLAB/R2020a/bin/activate_matlab.sh

COPY matlab /root/matlab
COPY startup.m /root
COPY run.sh /run.sh

CMD ["bash", "/run.sh"]
