#!/bin/bash

# https://www.influxdata.com/blog/running-the-tick-stack-on-a-raspberry-pi/

curl -sL https://repos.influxdata.com/influxdb.key | apt-key add -
echo "deb https://repos.influxdata.com/debian stretch stable" > /etc/apt/sources.list.d/influxdb.list
apt-get update && apt-get -y install telegraf
cat << EOF > /etc/telegraf/telegraf.conf
[global_tags]
[agent]
  interval = "30s"
  round_interval = true
  metric_batch_size = 1000
  metric_buffer_limit = 10000
  collection_jitter = "0s"
  flush_interval = "10s"
  flush_jitter = "0s"
  precision = ""
  debug = false
  quiet = false
  logfile = ""
  hostname = ""
  omit_hostname = false
[[outputs.prometheus_client]]
listen = ":9273"
[[inputs.cpu]]
  percpu = true
  totalcpu = true
  collect_cpu_time = false
  report_active = false
[[inputs.disk]]
  ignore_fs = ["tmpfs", "devtmpfs", "devfs"]
[[inputs.diskio]]
[[inputs.kernel]]
[[inputs.mem]]
[[inputs.processes]]
[[inputs.swap]]
[[inputs.system]]
[[inputs.net]]
[[inputs.exec]]
  commands = ["sudo rpi-measurement.sh temp"]
  name_override = "rpi_temp"
  data_format = "value"
  data_type = "float"
[[inputs.exec]]
  commands = ["sudo rpi-measurement.sh freq"]
  name_override = "rpi_freq"
  data_format = "value"
  data_type = "integer"
[[inputs.exec]]
  commands = ["sudo rpi-measurement.sh voltage"]
  name_override = "rpi_voltage"
  data_format = "value"
  data_type = "float"
[[inputs.exec]]
  commands = ["sudo rpi-measurement.sh throttling"]
  name_override = "rpi_throttled"
  data_format = "value"
  data_type = "integer"
EOF
echo "telegraf ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/telegraf
service telegraf restart