#!/bin/bash

# Provide a message on login

echo "
#####################
# dk-vagrant-centos #
#####################
Host: ${HOSTNAME}

" > /etc/motd

# Enable MotD
sed -i -e 's/^PrintMotd no/PrintMotd yes/' /etc/ssh/sshd_config
systemctl reload sshd
