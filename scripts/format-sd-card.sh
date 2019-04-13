#!/bin/bash

# Just to write to somewere how to prepare flash card for Raspberry Pi using OSX.

DISK=${1}
IMAGE=~/pi/2018-11-13-raspbian-stretch-lite.img

if [ -z ${1} ]
then
  echo "Please specify the disk. 'diskUtil list' command helps you."
  exit 1
fi

diskutil unmountDisk ${DISK}
sudo dd if=${IMAGE} of=${DISK} bs=2m
sleep 1
touch /Volumes/boot/ssh
cat << EOF >> /Volumes/boot/config.txt

# Overclocking
# https://www.raspberrypi.org/documentation/configuration/config-txt/overclocking.md

arm_freq=1400
arm_freq_min=1200
over_voltage=4
over_voltage_min=2

# gpu_freq=
# core_freq=200
# core_freq_min=150
# h264_freq=150
# h264_freq_min=100
# isp_freq=150
# isp_freq_min=100
# v3d_freq=150
# v3d_freq_min=100

# sdram_freq=450
# force_turbo=0
initial_turbo=60
# temp_limit=85
EOF
diskutil eject ${DISK}