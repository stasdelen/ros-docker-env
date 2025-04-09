#!/bin/bash
set -e

# System packages
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo apt install -y fuse libfuse2 wget unzip

sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt-get install -y python3.8 python3.8-venv

wget https://github.com/neovim/neovim-releases/releases/download/v0.11.0/nvim-linux-x86_64.appimage
chmod a+x nvim-linux-x86_64.appimage 
sudo mv nvim-linux-x86_64.appimage /usr/bin/nvim

su rosuser -c "git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf"
su rosuser -c "~/.fzf/install --key-bindings --completion --update-rc"
