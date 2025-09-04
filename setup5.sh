#!/bin/bash

# ----------------------------
# Ubuntu 24.04 Cuckoo Sandbox Setup Script (Python 2)
# ----------------------------

set -e

# Install dependencies
sudo apt update
sudo apt install -y build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncurses5-dev libncursesw5-dev libjpeg-dev xz-utils tk-dev libffi-dev liblzma-dev git
sudo apt-get install -y postgresql libpq-dev tcpdump docker.io docker-compose \
ssdeep libfuzzy-dev 
sudo systemctl enable --now docker


# Install pyenv
curl https://pyenv.run | bash

# Add pyenv to shell
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Install Python 2.7.18 (last 2.7 release)
pyenv install 2.7.18



#install system wide dependancies
sudo apt-get install -y libjpeg-dev zlib1g-dev swig
sudo apt-get install -y libpq-dev postgresql


# Make the mongodb docker container
mkdir -p ~/mongo-data
docker pull mongo:7.0
docker run -d --name mongodb -p 27017:27017 -v ~/mongo-data:/data/db mongo:7.0

 #add the cuckoo user
 sudo adduser cuckoo

# setup tcpdump for non-root usage
sudo groupadd pcap
sudo usermod -a -G pcap cuckoo
sudo chgrp pcap /usr/bin/tcpdump
sudo setcap cap_net_raw,cap_net_admin=eip /usr/bin/tcpdump

# Raising file limits
LIMITS_CONF="/etc/security/limits.d/cuckoo.conf"
echo "cuckoo soft nofile 65535" | sudo tee $LIMITS_CONF
echo "cuckoo hard nofile 65535" | sudo tee -a $LIMITS_CONF


# Activate the venv, install cuckoo and python dependancies
pyenv virtualenv 2.7.18 cuckoo-py2
pyenv activate cuckoo-py2
pip install -U pip setuptools
pip install -U cuckoo
pip install python-magic yara-python flask requests chardet netaddr
pip install pymongo
pip install git+https://github.com/kbandla/pydeep.git

#python3 venv for volatility -Done
python3 -m venv ~/volatility3-env
source ~/volatility3-env/bin/activate

# Upgrade pip - Done
pip install --upgrade pip setuptools wheel

# Install volatility3 - Done
pip install volatility3

