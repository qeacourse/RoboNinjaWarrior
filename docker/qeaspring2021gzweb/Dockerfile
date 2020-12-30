FROM qeacourse/robodocker:spring2021
MAINTAINER Paul Ruvolo Paul.Ruvolo@olin.edu

# Install Node.js 10.x repository
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get update && apt-get install -y xvfb nodejs libjansson-dev imagemagick && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN /bin/bash -c "cd ~ && \
		  rm -rf gzweb && \
		  git clone https://github.com/qeacourse/gzweb && \
		  cd gzweb && \
		  git checkout gzweb_1.4.0 && \
		  source /usr/share/gazebo/setup.sh && \
		  npm run deploy --- -m local && \
		  cp -r /usr/share/gazebo-9/media/* ~/gzweb/http/client/assets"


COPY  run.sh /run.sh

CMD ["bash", "/run.sh"]
