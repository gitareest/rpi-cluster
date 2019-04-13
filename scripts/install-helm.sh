#!/bin/bash

VERSION=2.12.3

# Tiller
# https://github.com/helm/helm/tree/master/rootfs
wget https://storage.googleapis.com/kubernetes-helm/helm-v${VERSION}-linux-arm.tar.gz
tar zxvf helm-v${VERSION}-linux-arm.tar.gz
curl -s 'https://raw.githubusercontent.com/helm/helm/master/rootfs/Dockerfile' > linux-arm/Dockerfile
docker build -t pi-1:5000/tiller:v${VERSION} -f linux-arm/Dockerfile --no-cache linux-arm/

# Helm
# https://github.com/helm/helm/blob/master/docs/install.md#from-script
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get > get_helm.sh
chmod +x get_helm.sh
./get_helm.sh --version v${VERSION}
kubectl create -f tiller-serviceaccount-clusterrolebinding.yaml
# add "--upgrade" to the end of the following line in case on upgrading
helm init --service-account tiller --tiller-image pi-1:5000/tiller:v${VERSION}
