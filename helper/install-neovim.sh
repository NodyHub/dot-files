#!/bin/bash

DEBIAN_FRONTEND=noninteractive sudo add-apt-repository ppa:neovim-ppa/stable -y
DEBIAN_FRONTEND=noninteractive sudo apt-get update
DEBIAN_FRONTEND=noninteractive sudo apt-get install neovim

exit 0
