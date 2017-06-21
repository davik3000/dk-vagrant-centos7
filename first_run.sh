#!/bin/bash

#set -x

# Functions
exec_vagrant_destroy() {
  echo "-----"
  echo "Destroy machines?"
  vagrant destroy $@
  return $?
}
exec_vagrant_halt() {
  echo "-----"
  echo "Halt running machines"
  vagrant halt $@
  return $?
}
disable_vagrant_plugins() {
  export VAGRANT_NO_PLUGINS=1
}
enable_vagrant_plugins() {
  unset VAGRANT_NO_PLUGINS
}
exec_vagrant_woPlugins() {
  echo "-----"
  echo "Create the nodes"

  echo " > disabling Vagrant plugins"
  disable_vagrant_plugins

  echo " > create and boot VMs"
  vagrant up $@
  return $?
}
exec_vagrant_provision() {
  echo "-----"
  echo "Applying provision to nodes"
  vagrant provision $@
  return $?
}
exec_vagrant_wPlugin() {
  echo "-----"
  echo "Reboot the nodes (and apply VirtualBox Guest Addition through plugin)"

  echo " > enabling Vagrant plugins"
  enable_vagrant_plugins

  echo " > reboot the VMs"
  vagrant reload $@
  return $?
}

manage_previous_vm() {
  local destroyed=
  local vagrant_hidden_folder=".vagrant"

  if [ -d "${vagrant_hidden_folder}" ] ; then
    echo "-----"
    echo "Detected .vagrant folder"
    exec_vagrant_destroy $@
    destroyed=1
  fi

  if [ -n "${destroyed}" ] ; then
    exec_vagrant_halt $@
  fi
  return $?
}

exiting() {
  echo "-----"
  echo "Errors occurred during execution. Exiting..."
  exit 1
}

# Main
manage_previous_vm $@

if [ $? -eq 0 ] ; then
  exec_vagrant_woPlugins $@
else
  exiting
fi

#if [ $? -eq 0 ] ; then
#  exec_vagrant_provision
#fi

if [ $? -eq 0 ] ; then
  exec_vagrant_wPlugin $@
else
  exiting
fi

echo "-----"
echo "Ready to go"
