#!/bin/bash

# https://blog.hypriot.com/post/setup-kubernetes-raspberry-pi-cluster/

ROLE=${1}

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
apt-get update && apt-get -y install kubeadm

if [ "${ROLE}" == "master" ]
then
  # master
  kubeadm init --pod-network-cidr=10.244.0.0/16
  kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/a70459be0084506e4ec919aa1c114638878db11b/Documentation/kube-flannel.yml
  kubectl taint nodes --all node-role.kubernetes.io/master-
elif [ "${ROLE}" == "slave" ]
then
  # slave TBD
  echo "You need to enter the command from the master node like:"
  echo "kubeadm join <MASTER_IP>:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<CERT_HASH>"
else
  echo "Please specify role. Is it master or slave?"
fi