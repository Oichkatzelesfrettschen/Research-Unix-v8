#!/bin/bash
set -e
apt-get update
apt-get install -y clang-14 clang-tools-14 gcc-multilib cscope cloc npm python3-pip
pip3 install lizard
npm install -g tree-sitter-cli
