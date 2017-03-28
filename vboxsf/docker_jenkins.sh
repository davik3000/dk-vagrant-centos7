#!/bin/bash
HOST_PORT=8080
HOST_VOLUME="$PWD/jenkins"

JENKINS_PORT=8080
JENKINS_HOME="/var/jenkins_home"

echo "Jenkins with Docker"

echo "> pull jenkins image"
docker pull jenkins

echo "> run image"
echo " - port ${HOST_PORT}"
echo " - volume ${HOST_VOLUME}"
docker run -d -p ${HOST_PORT}:${JENKINS_PORT} -v ${HOST_VOLUME}:${JENKINS_HOME} -t jenkins
