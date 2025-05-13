#!/bin/bash
set -e

# System packages
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo apt install -y fuse libfuse2 wget

sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt-get install -y python3.8 python3.8-venv

su rosuser -c "git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf"
su rosuser -c "~/.fzf/install --key-bindings --completion --update-rc"
