#!/bin/bash

#################################
# Global settings
SCRIPTS_DIR=
#################################

#############
# Functions #
#############
function sourceFile()
{
  FILEPATH=$1
  echo "-----"
  echo "Executing: ${FILEPATH}"

  if [ -e ${FILEPATH} ] ; then
    source ${FILEPATH} "${SCRIPTS_DIR}"
  else
    echo "Error: cannot find ${FILEPATH}. Skipping..."
  fi;
}

function configureNetwork()
{
  local FILEPATH="${SCRIPTS_DIR}/configureNetwork.sh"
  sourceFile ${FILEPATH}
}
function updatePackages()
{
  local FILEPATH="${SCRIPTS_DIR}/updateYumPackages.sh"
  sourceFile ${FILEPATH}
}
function fixSlowSSH()
{
  local FILEPATH="${SCRIPTS_DIR}/fixSlowSSH.sh"
  sourceFile ${FILEPATH}
}
function speedupGrub2Boot()
{
  local FILEPATH="${SCRIPTS_DIR}/speedupGrub2Boot.sh"
  sourceFile ${FILEPATH}
}
function applyMotD()
{
  local FILEPATH="${SCRIPTS_DIR}/applyMotD.sh"
  sourceFile ${FILEPATH}
}
function installXfce()
{
  local FILEPATH="${SCRIPTS_DIR}/installXfce.sh"
  sourceFile ${FILEPATH}
}

function executeProvision()
{
  if [ -d ${SCRIPTS_DIR} ] ; then
    configureNetwork

    # perform a silent upgrade of the system
    updatePackages

    fixSlowSSH
    
    speedupGrub2Boot

    applyMotD

    installXfce
  else
    echo "-----"
    echo "Error: folder ${SCRIPTS_DIR} doesn't not exist!"
    exit 1
  fi;
}

########
# Main #
########

# use argument for scripts folder path
if [ -n $1 ] ; then
  SCRIPTS_DIR=$1
fi;

executeProvision

<<<<<<< HEAD
exit $?
=======
exit $?
>>>>>>> d3ce079... Fixed previous commit
