#!/bin/bash
echo "=== Checking system dependencies for Cuckoo ==="

check_pkg() {
    if dpkg -s "$1" &>/dev/null; then
        echo "[OK] $1 is already installed"
    else
        echo "[MISSING] $1 is not installed"
    fi
}

# Python & dev
check_pkg python
check_pkg python-pip
check_pkg python-dev
check_pkg python-virtualenv
check_pkg python-setuptools

# Libraries
check_pkg libffi-dev
check_pkg libssl-dev
check_pkg libjpeg-dev
check_pkg zlib1g-dev
check_pkg swig

# DB & networking
check_pkg postgresql
check_pkg libpq-dev
check_pkg tcpdump
check_pkg docker.io
check_pkg docker-compose

echo "=== Check completed ==="
