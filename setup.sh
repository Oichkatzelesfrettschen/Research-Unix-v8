#!/bin/bash
set -e

# update package lists
sudo apt-get update

# install build tools and analysis utilities
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install \
    clang-14 gcc-12-m68k-linux-gnu binutils-m68k-linux-gnu \
    cscope cloc nodejs npm

# install tree-sitter CLI
sudo npm install -g tree-sitter-cli

# install Python tools
pip install --break-system-packages lizard

# initialize tree-sitter config if absent
if [ ! -f "$HOME/.config/tree-sitter/config.json" ]; then
    tree-sitter init-config
fi

# install C grammar for tree-sitter
npm install tree-sitter-c

# generate tags using cscope
cscope -bkR

# generate code statistics
cloc . --exclude-dir=.git --include-lang=C --quiet --json --out=cloc.json

# compute code complexity
lizard usr/src/libF77 > lizard.csv

