FROM qeacourse/robodocker:qeasimnogpu
MAINTAINER Paul Ruvolo Paul.Ruvolo@olin.edu

RUN /bin/bash -c "cd /tmp && \
                  git clone https://github.com/qeacourse/RoboNinjaWarrior && \
                  cp -r /tmp/RoboNinjaWarrior/Sample_code ~ && \
		  cd ~/catkin_ws/src/vrx && \
                  git pull && \
                  cp -r ~/catkin_ws/src/vrx/usv_gazebo_plugins/matlab_examples ~/matlab_boats && \
		  cd ~/catkin_ws/src/comprobo18 && \
                  git pull && \
                  cp ~/catkin_ws/src/comprobo18/com_workshop/matlab_examples/*.m ~/matlab_boats && \
                  rm -rf /tmp/RoboNinjaWarrior"

RUN pip install future

COPY matlab /root/matlab
COPY startup.m /root
COPY run.sh /run.sh

CMD ["bash", "/run.sh"]
