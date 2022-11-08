#!/bin/bash

K8S_VERSION=1.23.13-00

echo ">> Prepare Docker"
mkdir /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
systemctl restart docker.service

echo ">> Install system packages"
apt-get install -y apt-transport-https ca-certificates curl

echo ">> Get keyring"
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo ">> Add repo"
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list


echo ">> Install kubelet and kubeadm"
apt-get update
apt-get install -yq kubelet=$K8S_VERSION kubeadm=$K8S_VERSION

echo ">> Adjust bridge configuration"
cat > /etc/sysctl.d/20-bridge-nf.conf <<EOF
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system


exit 0
