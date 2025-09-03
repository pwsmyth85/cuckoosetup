#!/bin/bash

# ----------------------------
# Ubuntu 24.04 Cuckoo Sandbox Setup Script (Python 3)
# ----------------------------

set -e

# ----------------------------
# 1. Update and install system dependencies
# ----------------------------
sudo apt update
sudo apt upgrade -y
sudo apt install -y git python3 python3-venv python3-pip build-essential python3-dev \
libssl-dev swig wget curl net-tools tcpdump postgresql postgresql-contrib docker.io \
docker-compose

# Enable Docker
sudo systemctl enable --now docker
sudo usermod -aG docker $USER

# ----------------------------
# 2. Create Python 3 virtual environment
# ----------------------------
rm -rf ~/cuckoo-env
python3 -m venv ~/cuckoo-env
source ~/cuckoo-env/bin/activate

# Upgrade pip and setuptools
pip install --upgrade pip setuptools wheel

# ----------------------------
# 3. Clone Cuckoo Sandbox (Python 3 compatible)
# ----------------------------
git clone https://github.com/cuckoosandbox/cuckoo.git ~/cuckoo-git
cd ~/cuckoo-git

# ----------------------------
# 4. Install Python dependencies (skip optional problematic packages)
# ----------------------------
pip install python-magic yara-python flask requests chardet netaddr
pip install pydeep volatility3 pymongo

# Install Cuckoo in editable mode
pip install -e .

# ----------------------------
# 5. Setup tcpdump for non-root usage
# ----------------------------
sudo groupadd -f pcap
sudo usermod -a -G pcap $USER
TCPDUMP_PATH=$(which tcpdump)
sudo chgrp pcap $TCPDUMP_PATH
sudo setcap cap_net_raw,cap_net_admin=eip $TCPDUMP_PATH

# ----------------------------
# 6. Raise file limits for Cuckoo user
# ----------------------------
# Temporary for current shell
ulimit -n 65535

# Permanent for the user
LIMITS_CONF="/etc/security/limits.d/cuckoo.conf"
echo "$USER soft nofile 65535" | sudo tee $LIMITS_CONF
echo "$USER hard nofile 65535" | sudo tee -a $LIMITS_CONF

# ----------------------------
# 7. Setup MongoDB via Docker
# ----------------------------
mkdir -p ~/mongo-data
docker pull mongo:7.0
docker run -d --name mongodb -p 27017:27017 -v ~/mongo-data:/data/db mongo:7.0

# ----------------------------
# 8. Instructions after script finishes
# ----------------------------
echo "----------------------------------------"
echo "Cuckoo Python 3 setup complete!"
echo ""
echo "Next steps:"
echo "1. Make sure to log out and back in so Docker group changes take effect."
echo "2. Activate virtual environment before running Cuckoo:"
echo "   source ~/cuckoo-env/bin/activate"
echo "3. Run Cuckoo:"
echo "   cuckoo -h"
echo "----------------------------------------"
