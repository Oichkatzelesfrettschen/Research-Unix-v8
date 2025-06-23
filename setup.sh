#!/bin/sh
set -e

# Update package lists
sudo apt-get update

# Install build tools and analysis utilities
sudo apt-get install -y clang-14 build-essential cscope cloc npm python3-pip

# Node-based tree-sitter CLI
sudo npm install -g tree-sitter-cli

# Install lizard for complexity analysis
sudo pip install lizard --break-system-packages
