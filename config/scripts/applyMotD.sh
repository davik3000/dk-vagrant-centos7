#!/bin/bash

# Provide a message on login

echo "
#####################
# dk-vagrant-centos #
#####################
Host: ${HOSTNAME}
" > /etc/motd

# Enable MotD, if disabled
sed -i -e 's/^PrintMotd no/PrintMotd yes/' /etc/ssh/sshd_config

# DART disabled, nice to have
# it's too complex for its simple purpose: load a banner on ssh login
#echo " > reloading sshd"
#systemctl -q reload sshd
#
#systemctl -q show sshd
#if [ $? -ne 0 ] ; then
#  echo " > cannot reload, restarting sshd"
#  systemctl -q restart sshd
#fi
