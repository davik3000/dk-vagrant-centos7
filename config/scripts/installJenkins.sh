#!/bin/bash

JENKINS_REPO_URL="https://pkg.jenkins.io/redhat/jenkins.repo"
JENKINS_REPO_PATH="/etc/yum.repos.d/jenkins.repo"
JENKINS_KEY_URL="https://pkg.jenkins.io/redhat/jenkins.io.key"

WHOAMI=$(whoami)
SUDOCMD=""
if [ "${WHOAMI}" != "root" ] ; then
  SUDOCMD="sudo -E"
fi

#############
# Functions #
#############
installJenkins() {
  echo "Installing Jenkins"
  echo "> yum: install epel-release"
  ${SUDOCMD} yum install -y -q epel-release
  
  echo "> wget: add Jenkins repository to /etc/yum.repos.d"
  ${SUDOCMD} wget -q -O ${JENKINS_REPO_PATH} ${JENKINS_REPO_URL}
  
  echo "> yum: import Jenkins GPG key"
  ${SUDOCMD} rpm --import ${JENKINS_KEY_URL}

  echo "> yum: install Jenkins"
  ${SUDOCMD} yum install -y -q jenkins
}

########
# Main #
########
installJenkins

echo "-----"
