#!/bin/bash

#################################
# Global settings

#################################

#############
# Functions #
#############
updatePackages_installPrereqs() {
  yum -q -y install \
    yum-utils
}
#updatePackages_setConfigManager() {
#  # yum-config-manager is contained in the package "yum-utils"
#  yum-config-manager -q --save --setopt=ies.skip_if_unavailable=true > /dev/null
#}
updatePackages_yumUpdate() {
  yum -q makecache fast
  yum -q -y update
}
updatePackages_enableSoftwareCollectionsRepos() {
  yum -q -y install \
    centos-release-scl \
    scl-utils-build
}
updatePackages_installUtils() {
  yum -q -y install \
    man \
    openssh-clients \
    git \
    subversion \
    vim \
    unzip \
    bzip2 \
    curl \
    wget \
    net-tools \
    nmap \
    ntp \
    telnet \
    gcc \
    dos2unix
}
updatePackages() {
  echo "-----"
  echo "Updating packages"

  updatePackages_installPrereqs

  #updatePackages_setConfigManager

  echo " > executing yum update"
  updatePackages_yumUpdate

  echo " > enabling Software Collections Repository"
  updatePackages_enableSoftwareCollectionsRepos

  echo " > installing utilities"
  updatePackages_installUtils
  
  if [ $? -eq 0 ] ; then
    echo "-----"
    echo "Packages update completed"
  else
    echo "-----"
    echo "Error: packages update failed"
  fi;
}

########
# Main #
########

# perform a silent upgrade of the system
updatePackages

echo "-----"
