FROM qeacourse/robodocker:qeasimnogpu
MAINTAINER Paul Ruvolo Paul.Ruvolo@olin.edu

RUN pip install future

COPY matlab /root/matlab
COPY startup.m /root
COPY run.sh /run.sh

CMD ["bash", "/run.sh"]
