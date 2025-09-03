#!/bin/bash

# ----------------------------
# Ubuntu 24.04 Cuckoo Sandbox Setup Script (Python 2)
# ----------------------------

set -e

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
pyenv activate cuckoo-py2
pip install -U pip setuptools
pip install -U cuckoo
pip install python-magic yara-python flask requests chardet netaddr
pip install pydeep pymongo
