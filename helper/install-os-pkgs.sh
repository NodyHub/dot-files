!/bin/bash

DEBIAN_FRONTEND=noninteractive apt-get install -y \
   apt-transport-https \
   ca-certificates \
   zsh \
   git \
   tmux \
   htop \
   nload
DEBIAN_FRONTEND=noninteractive apt autoremove

exit 0
