#!/bin/bash
set -e

# Detect OS and install dependencies
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$NAME" in
        *Ubuntu*)
            echo "ubuntu linux"
            sudo apt-get update
            sudo apt-get install -y libgnutls28-dev libtinfo-dev pkg-config libgccjit-12-dev ripgrep librime-dev
            ;;
        *Rocky*)
            echo "rocky linux"
            sudo yum install -y gnutls pkg-config gnutls-devel ncurses-devel zlib zlib-devel libgccjit libgccjit-devel ripgrep librime-devel
            ;;
        *)
            echo "system not recognized"
            exit 1
            ;;
    esac
else
    echo "Cannot detect OS"
    exit 1
fi

# Download and build Emacs
wget -c https://mirror.ossplanet.net/gnu/emacs/emacs-30.2.tar.xz
tar -xvf emacs-30.2.tar.xz

JOBS=$(nproc 2>/dev/null || echo 4)
cd emacs-30.2 && ./configure --with-modules && make -j"$JOBS" && sudo make install
