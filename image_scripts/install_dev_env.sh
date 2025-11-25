#!/bin/bash
set -e

# System packages
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo apt install -y fuse libfuse2 curl unzip

# Install xclip board for clipboard integration
# Works only if X11 socket is mounted
sudo apt-get install -y xclip

# Install less for better catting
sudo apt-get install -y less

sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt-get install -y python3.8 python3.8-venv
sudo apt-get install -y python3-venv

curl -Lo /tmp/nvim.appimage https://github.com/neovim/neovim-releases/releases/download/v0.11.0/nvim-linux-x86_64.appimage
chmod +x /tmp/nvim.appimage
cd /tmp
./nvim.appimage --appimage-extract
mv squashfs-root /opt/nvim
ln -s /opt/nvim/AppRun /usr/bin/nvim
rm /tmp/nvim.appimage

git clone https://github.com/stasdelen/dotfiles.git /root/dotfiles
chmod a+x /root/dotfiles/install.sh
/root/dotfiles/install.sh

git clone --depth 1 https://github.com/junegunn/fzf.git /root/fzf
/root/fzf/install --key-bindings --completion --update-rc

nvim --headless "+Lazy! sync" +qa
nvim --headless "+MasonUpdate" +qa
nvim --headless "+MasonToolsUpdateSync" +qa
nvim --headless "+TSUpdateSync" +qa

# Install additional dependencies
sudo apt-get install -y libompl-dev
