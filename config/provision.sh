#!/bin/bash

#################################
# Global settings
SCRIPT_DIR=
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
    source ${FILEPATH} "${SCRIPT_DIR}"
  else
    echo "Error: cannot find ${FILEPATH}. Skipping..."
  fi;
}

function configureProxy()
{
  local FILEPATH="${SCRIPT_DIR}/applyProxySettings.sh"
  sourceFile ${FILEPATH}
}
function updatePackages()
{
  local FILEPATH="${SCRIPT_DIR}/updateYumPackages.sh"
  sourceFile ${FILEPATH}
}
function fixSlowSSH()
{
  local FILEPATH="${SCRIPT_DIR}/fixSlowSSH.sh"
  sourceFile ${FILEPATH}
}
function speedupGrub2Boot()
{
  local FILEPATH="${SCRIPT_DIR}/speedupGrub2Boot.sh"
  sourceFile ${FILEPATH}
}
function installXfce()
{
  local FILEPATH="${SCRIPT_DIR}/installXfce.sh"
  sourceFile ${FILEPATH}
}

function executeProvision()
{
  if [ -d ${SCRIPT_DIR} ] ; then
    configureProxy

    # perform a silent upgrade of the system
    updatePackages

    fixSlowSSH
    
    speedupGrub2Boot

    installXfce
  else
    echo "-----"
    echo "Error: folder ${SCRIPT_DIR} doesn't not exist!"
    exit 1
  fi;
}

########
# Main #
########

# use argument for scripts folder path
if [ -n $1 ] ; then
  SCRIPT_DIR=$1
fi;

executeProvision

<<<<<<< HEAD
exit $?
=======
exit $?
>>>>>>> d3ce079... Fixed previous commit
