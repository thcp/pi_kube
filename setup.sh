#!/bin/bash

set -e 
source config.ini

#
# Network Config
#
sudo hostnamectl --transient set-hostname $HOSTNAME
sudo hostnamectl --static set-hostname $HOSTNAME
sudo hostnamectl --pretty set-hostname $HOSTNAME
sudo sed -i s/raspberrypi/$HOSTNAME/g /etc/hosts    
sudo cat <<EOT > /etc/dhcpcd.conf
interface eth0
static ip_address=$IPADDR/24
static routers=$ROUTER
static domain_name_servers=$DNS
EOT

#
# Disable swap
#
sudo dphys-swapfile swapoff
sudo dphys-swapfile uninstall
sudo update-rc.d dphys-swapfile remove

#
# Install Docker / Docker Compose
#
export VERSION=18.06
curl -sSL get.docker.com | sh && sudo usermod pi -aG docker
sudo apt-get install -qqy docker-compose

#
# Install Kubernetes
#
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -qqy 
sudo apt-get install -qqy kubeadm

#
# Init and deploy weave network for master
#
if [ "$NODE_TYPE" == 'master' ]; then
    sudo kubeadm init
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    #Setup weave network
    kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
fi
echo "Done"
sudo shutdown -r now
