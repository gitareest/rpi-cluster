#!/bin/bash

CEPH_RELEASE=luminous

# Don't use ceph repos, there is no ceph-mon and other packages
# wget -q -O- 'https://download.ceph.com/keys/release.asc' | sudo apt-key add -
# echo deb https://download.ceph.com/debian-${CEPH_RELEASE}/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list
#

echo "deb http://raspbian.raspberrypi.org/raspbian/ testing main" > /etc/apt/sources.list.d/testing.list
cat << EOF > /etc/apt/preferences.d/ceph
Package : *
Pin : release a=stable
Pin-Priority : 900

Package : *
Pin : release a=testing
Pin-Priority : 300
EOF

apt-get update && apt-get -y install ntp
sudo apt-get install -t testing ceph-mon ceph ceph-base ceph-common radosgw rbd-nbd
sudo wget -O /lib/systemd/system/ceph-mgr.target https://raw.githubusercontent.com/ceph/ceph/master/systemd/ceph-mgr.target
sudo systemctl enable ceph-mgr.target
sudo wget -O /lib/systemd/system/ceph-mgr@.service https://raw.githubusercontent.com/ceph/ceph/master/systemd/ceph-mgr%40.service.in
sudo systemctl enable ceph-mgr@pi-1
useradd -s /bin/bash -m ceph-admin
echo "ceph-admin ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ceph
# TODO
# ssh-keygen

# su ceph-admin
mkdir ceph
cd ceph
ceph-deploy new pi-1
ceph-deploy install pi-1 pi-3
ceph-deploy mon create-initial
ceph-deploy admin pi-1 pi-3
ceph-deploy mgr create pi-1
apt-get -y install lvm2
wget -O /lib/systemd/system/ceph-volume@.service https://raw.githubusercontent.com/ceph/ceph/master/systemd/ceph-volume%40.service
ceph-deploy osd create --data /dev/sda pi-3

ceph mgr module enable prometheus

ceph osd pool create --size 1 volumes 100
rbd create --size 3G volumes/prometheus-data
rbd create --size 3G volumes/registry-data

# rbd-nbd list-mapped
rbd-nbd map volumes/registry-data
mkfs.ext4 /dev/nbd0
rbd-nbd unmap /dev/nbd0