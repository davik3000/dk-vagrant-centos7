#!/bin/bash

JENKINS_REPO_URL="https://pkg.jenkins.io/redhat/jenkins.repo"
JENKINS_REPO_PATH="/etc/yum.repos.d/jenkins.repo"
JENKINS_KEY_URL="https://pkg.jenkins.io/redhat/jenkins.io.key"

#############
# Functions #
#############
install_jenkins() {
  echo "Installing Jenkins"
  echo "> yum: install epel-release"
  sudo yum install -y -q epel-release
  
  echo "> wget: add Jenkins repository to yum"
  sudo wget -O "${JENKINS_REPO_PATH}" "${JENKINS_REPO_URL}"
  
  echo "> yum: import Jenkins GPG key"
  sudo rpm --import "${JENKINS_KEY_URL}"

  echo "> yum: install Jenkins"
  sudo yum install jenkins
}

########
# Main #
########
install_jenkins

echo "-----"
