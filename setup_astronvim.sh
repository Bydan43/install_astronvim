#!/bin/bash

# Setup AstoNvim - https://docs.astronvim.com
# For Debian and Ubuntu
# Project https://docs.astronvim.com

TMP_DIR=/tmp

URL_FONTS="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip"
URL_NEOVIM_INSTALLER="https://github.com/neovim/neovim/releases/download/stable/nvim.appimage"
URL_RIPGREP="https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb"
URL_BOTTOM="https://github.com/ClementTsang/bottom/releases/download/0.9.6/bottom_0.9.6_amd64.deb"
GIT_ASTONVIM="https://github.com/AstroNvim/AstroNvim"


echo "--------------------------------------------"
echo "Install base pkg"
echo "--------------------------------------------"
apt-get update
apt-get install -y \
    unzip \
    curl \
    git \
    wget \
    tar \
    sudo \
    gdu \
    python3 \
    libfuse2 \
    nodejs \
    npm

#apt install cargo
#cargo install tree-sitter-cli

cd ${TMP_DIR}
# Install lazygit
echo "--------------------------------------------"
echo "Install lazygit"
echo "--------------------------------------------"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
lazygit --version

echo "--------------------------------------------"
echo "Install bottom"
echo "--------------------------------------------"
curl -Lo bottom.deb ${URL_BOTTOM}
dpkg -i bottom.deb

echo "--------------------------------------------"
echo "Install ripgrep"
echo "--------------------------------------------"
curl -Lo ripgrep.deb ${URL_RIPGREP}
dpkg -i ripgrep.deb

echo "--------------------------------------------"
echo "Install fonts"
echo "--------------------------------------------"
FONTS_NAME="jetbrains_fonts"
curl -Lo ${FONTS_NAME}.zip ${URL_FONTS} 
mkdir -p ${FONTS_NAME}
unzip ${FONTS_NAME}.zip -d ./${FONTS_NAME}
mkdir -p ~/.fonts
mv ${FONTS_NAME} ~/.fonts

echo "--------------------------------------------"
echo "Install nvim"
echo "--------------------------------------------"
NVIM_INSTALLER="nvim.appimage"
curl -Lo ${NVIM_INSTALLER} ${URL_NEOVIM_INSTALLER}
chmod u+x ${NVIM_INSTALLER}
./${NVIM_INSTALLER} --appimage-extract
cp -r squashfs-root/usr/* /usr/

echo "--------------------------------------------"
echo "Install AstroNvim"
echo "--------------------------------------------"
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
git clone --depth 1 ${GIT_ASTONVIM} ~/.config/nvim
rm -rf ${TMP_DIR}/*
nvim
