#!/bin/bash

# Usage:
# rpi-measurement.sh <OPTION>

if [ "${1}" == "freq" ]
then
  # CPU frequency
  RPI_CPU_FREQ=$(vcgencmd measure_clock arm | awk -F "=" '{print $2/1000}')
  echo ${RPI_CPU_FREQ}
elif [ "${1}" == "voltage" ]
then
  # CPU voltage
  RPI_CPU_VOLTAGE=$(vcgencmd measure_volts core | awk -F "=" '{print $2}' | sed s/V$//)
  echo ${RPI_CPU_VOLTAGE}
elif [ "${1}" == "temp" ]
then
  # CPU temperature
  RPI_CPU_TEMP=$(vcgencmd measure_temp | awk -F "=" '{print $2}' | sed s/\'C$//)
  echo ${RPI_CPU_TEMP}
elif [ "${1}" == "throttling" ]
then
  if [ "$(vcgencmd get_throttled | awk -F "=" '{print $2}')" == "0x0" ]
  then
    THROTTLED=0
  else
    THROTTLED=1
  fi
  echo ${THROTTLED}
else
  echo "Please specify one of the follwoing options:"
  echo "freq, voltage, temp, throttling"
fi