#!/bin/bash

echo ">> Install Minikube"
wget -O /tmp/minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install /tmp/minikube /usr/local/bin/minikube
rm /tmp/minikube

exit 0
