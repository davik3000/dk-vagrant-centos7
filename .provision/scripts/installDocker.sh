#!/bin/bash

#set -x

#################################
# Global settings
CONFIG_DIR=

WHOAMI=$(whoami)
SUDOCMD=""
if [ "${WHOAMI}" != "root" ] ; then
  SUDOCMD="sudo -E"
fi

QUIET="-q"
#################################

#################################
# Docker related settings
# Available Docker versions obtained with: yum --showduplicates list docker-engine
DOCKER_VERSION="1.13.0"
# See https://github.com/docker/compose/releases for latest version of Docker Compose
DOCKER_COMPOSE_VERSION="1.10.0"
OS_NAME=$(uname -s)
HW_ARCH=$(uname -m)

DOCKER_REPO_SRC_URL="https://download.docker.com/linux/centos/docker-ce.repo"
DOCKER_REPO_DST_PATH="/etc/yum.repos.d/docker.repo"

DOCKER_SELINUX_DST_DIR="/var/lib/docker"

DOCKER_SRV_DST_DIR="/etc/systemd/system/docker.service.d"

DOCKER_COMPOSE_SRC_URL="https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-${OS_NAME}-${HW_ARCH}"
DOCKER_COMPOSE_DST_PATH="/usr/local/bin/docker-compose"
#################################

#############
# Functions #
#############
installDockerPackage_setDockerRepo() {
  #sudo -E cp ${CONFIG_DIR}/docker/docker.repo ${DST_DOCKER_REPO_PATH}
  #sudo -E chown root:root ${DST_DOCKER_REPO_PATH}
  echo "-----"
  echo "Adding docker repository"
  echo "> yum: install epel-release"
  ${SUDOCMD} yum install -y ${QUIET} epel-release
  echo "> yum: install yum-utils"
  ${SUDOCMD} yum install -y ${QUIET} yum-utils
  echo "> yum: install docker.repo with yum-config-manager"
  ${SUDOCMD} yum-config-manager -y ${QUIET} --add-repo ${DOCKER_REPO_SRC_URL}
}

installDockerPackage_applyFixForIssue25741() {
  # DART fixing Docker issue #25741:
  # selinux spec: warning on installing docker-engine-selinux
  # DART this folder should exist prior to install docker
  [ -d "${DOCKER_SELINUX_DST_DIR}" ] || ${SUDOCMD} mkdir -p ${DOCKER_SELINUX_DST_DIR}
  ${SUDOCMD} chown root:root ${DOCKER_SELINUX_DST_DIR}
}

installDockerPackage_setProxyConfig() {
  # DART fixing proxy conf missing in docker daemon, as found here
  # DART https://docs.docker.com/engine/admin/systemd/#http-proxy

  local DOCKER_PROXY_CONF_SRC_PATH="${CONFIG_DIR}/docker-http-proxy.conf"
  local DOCKER_PROXY_CONF_DST_PATH="${DST_DOCKER_SRV_DIR}/http-proxy.conf"

  echo "-----"
  echo "Configuring docker proxy settings"

  [ -d "${DOCKER_SRV_DST_DIR}" ] || ${SUDOCMD} mkdir -p ${DOCKER_SRV_DST_DIR}

  if [ -f "${DOCKER_PROXY_CONF_SRC_PATH}" ] && [ ! -f "${DOCKER_PROXY_CONF_DST_PATH}" ] ; then
    echo " > apply proxy configuration from local file"
    ${SUDOCMD} cp ${DOCKER_PROXY_CONF_SRC_PATH} ${DOCKER_PROXY_CONF_DST_PATH}
    ${SUDOCMD} chown root:root ${DOCKER_PROXY_CONF_DST_PATH}
  else
    echo " > no changes applied"
  fi;
}

installDockerPackage_installDockerCE() {
  ${SUDOCMD} yum install -y ${QUIET} docker-ce
}

installDockerPackage_installDockerEngine() {
  echo "-----"
  echo "Installing docker engine"

  # DART execute this fix prior to install
  # see function for more details
  installDockerPackage_applyFixForIssue25741
  
  # install engine
  #${SUDOCMD} yum -q -y install docker-engine-${DOCKER_VERSION}
  installDockerPackage_installDockerCE
}

installDockerPackage_installDockerCompose() {
  echo "-----"
  echo "Installing docker compose v. ${DOCKER_COMPOSE_VERSION}"
  #curl -L ${DOCKER_COMPOSE_SRC_URL} -o ${DOCKER_COMPOSE_DST_PATH}
  ${SUDOCMD} wget ${QUIET} -O ${DOCKER_COMPOSE_DST_PATH} ${DOCKER_COMPOSE_SRC_URL}
  ${SUDOCMD} chown root:root ${DOCKER_COMPOSE_DST_PATH}
  ${SUDOCMD} chmod +x ${DOCKER_COMPOSE_DST_PATH}
}

installDockerPackage_configureService() {
  echo "-----"
  echo "Configuring docker service"

  echo " > check the service and start the daemon"
  # enable the service
  dockerEnabled=$(${SUDOCMD} systemctl is-enabled docker.service)
  if [ ${dockerEnabled} == "disabled" ] ; then
    echo " >> enable docker.service"
    ${SUDOCMD} systemctl enable docker.service
  else
    echo " >> docker.service already enabled"
  fi;

  # start the daemon
  dockerActive=$(${SUDOCMD} systemctl is-active docker)
  if [ ${dockerActive} == "inactive" ] ; then
    echo " >> start the daemon"
    ${SUDOCMD} systemctl start docker
  else
    echo " >> try to restart docker daemon"
    ${SUDOCMD} systemctl daemon-reload
    ${SUDOCMD} systemctl restart docker
  fi;
}

installDockerPackage() {
  # install docker engine and compose

  # applying docker.repo setting
  installDockerPackage_setDockerRepo

  # install engine
  installDockerPackage_installDockerEngine

  # install compose
  installDockerPackage_installDockerCompose

  # configure docker proxy settings
  installDockerPackage_setProxyConfig

  # configure docker service
  installDockerPackage_configureService
}

########
# Main #
########
# use argument for config folder path
if [ -n "${1}" ] ; then
  CONFIG_DIR=$1
fi;

if [ -d "${CONFIG_DIR}" ] ; then
  installDockerPackage
else
  echo "Missing config dir as argument"
fi;

echo "-----"
