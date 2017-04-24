#!/bin/bash

# Install additional guests

if [[ $(facter virtual) =~ ^(virtualbox)$ ]] ; then

  mkdir /tmp/vbox
  VER=$(cat /home/vagrant/.vbox_version)
  mount -o loop /home/vagrant/VBoxGuestAdditions_$VER.iso /tmp/vbox 
  yes | sh /tmp/vbox/VBoxLinuxAdditions.run
  umount /tmp/vbox
  rmdir /tmp/vbox
  rm /home/vagrant/*.iso
  ln -s /opt/VBoxGuestAdditions-*/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
  
  # Cleanup
  rm -rf VBoxGuestAdditions_*.iso VBoxGuestAdditions_*.iso.?
  rm -rf /usr/src/virtualbox-ose-guest*
  rm -rf /usr/src/vboxguest*

fi


if [[ $(facter virtual) =~ ^(kvm)$ ]] ; then
  apt-get install qemu-guest-agent -y
fi
