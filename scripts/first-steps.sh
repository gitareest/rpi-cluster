#!/bin/bash

# Just to write to somewere the first steps on Raspberry Pi.
# Usage:
# first-steps.sh <NODE_NAME>
# For example:
# first-steps.sh pi-1

# curl -s https://raw.githubusercontent.com/gitareest/raspberry-kubernetes/master/scripts/first-steps.sh pi-1 <your_ssh_key> | bash

NODE_NAME=${1}
SSH_PUB_KEY=${2}

# SSH access.
mkdir /home/pi/.ssh
echo "${SSH_PUB_KEY}" > /home/pi/.ssh/authorized_keys


# Hostname.
echo ${NODE_NAME} > /etc/hostname
sed -i s/raspberrypi/${NODE_NAME}/ /etc/hosts

# Disable SWAP. Needed for SD card and Kubernetes case. Placed here to avoid the second reboot.
systemctl disable dphys-swapfile

# Enable cgroups for Kubernetes case. Placed here to avoid the second reboot.
echo "$(cat /boot/cmdline.txt) cgroup_enable=cpuset cgroup_enable=memory" > /boot/cmdline.txt

# Upgrade the node to the lates stable version.
apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade && apt-get -y install vim && reboot