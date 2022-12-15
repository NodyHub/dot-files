#!/bin/bash

git clone https://github.com/NodyHub/dot-files.git /tmp/dot-files
cd /tmp/dot-files
./deploy.sh
cd -
rm -rf /tmp/dot-files

if [[ "$SHELL" != *"zsh" ]]
then
  sudo chsh -s $(which zsh) $(whoami)
fi

exit 0
