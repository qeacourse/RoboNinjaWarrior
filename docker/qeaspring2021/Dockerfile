FROM qeacourse/robodocker:qeasimnogpu
MAINTAINER Paul Ruvolo Paul.Ruvolo@olin.edu

COPY matlab /root/matlab
COPY startup.m /
COPY run.sh /run.sh

CMD ["bash", "/run.sh"]
