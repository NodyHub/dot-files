#!/bin/bash

echo ">> Install Minikube"
wget -q -O /tmp/minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
install /tmp/minikube /usr/local/bin/minikube
rm /tmp/minikube

exit 0
