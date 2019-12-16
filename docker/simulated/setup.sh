#!/bin/bash

echo "#!/bin/bash" > ./connect
echo "docker run --net=host -e HOST=\$1 -e ROS_HOSTNAME=\`docker-machine ip\` -it paulruvolo/neato_docker" >> ./connect

docker-machine stop default
/c/Program\ Files/Oracle/VirtualBox/VBoxManage.exe modifyvm default --natpf1 "gstneato,udp,,5000,,5000"
/c/Program\ Files/Oracle/VirtualBox/VBoxManage.exe modifyvm default --cpus 2
docker-machine start default
docker pull paulruvolo/neato_docker
