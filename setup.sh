#!/bin/bash

set -e

sudo apt update
sudo apt install xrdp -y
sudo systemctl enable --now xrdp

curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up


