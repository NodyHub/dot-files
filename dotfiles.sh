#!/bin/bash

git clone https://github.com/NodyHub/dot-files.git /tmp/dot-files
cd /tmp/dot-files
./deploy.sh
cd -
rm -rf /tmp/dot-files
sudo chsh -s $(which zsh) $(whoami)

exit 0
