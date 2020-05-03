#!/bin/bash
MYDIR=$(readlink -f "$(dirname "${0}")")
if grep Ubuntu /etc/lsb-release; then
    curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -
    # Replace with the branch of Node.js or io.js you want to install: node_6.x, node_8.x, etc...
    VERSION=node_12.x
    DISTRO="$(lsb_release -s -c)"
    echo "deb https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee /etc/apt/sources.list.d/nodesource.list
    echo "deb-src https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list
    sudo apt update
    sudo apt install -y nodejs
fi
if [ -f /etc/arch-release ]; then
    sudo pacman -S npm
fi
npm install -g --prefix "${MYDIR}/bin/cdk" cdk