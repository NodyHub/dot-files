#!/bin/bash

echo ">> Install kubectl"
wget -q -O /tmp/stable.txt https://dl.k8s.io/release/stable.txt
wget -q -O /tmp/kubectl "https://dl.k8s.io/release/$(cat /tmp/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl
rm /tmp/kubectl
rm /tmp/stable.txt

exit 0
