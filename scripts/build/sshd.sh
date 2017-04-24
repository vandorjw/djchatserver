#!/bin/bash

apt-get -y install openssh-server
echo "UseDNS no" >> /etc/ssh/sshd_config
echo "GSSAPIAuthentication no" >> /etc/ssh/sshd_config

if [ $(facter lsbdistcodename) = 'stretch' ] ; then
  systemctl disable ssh.service
  systemctl enable ssh.socket
fi
