#!/bin/bash

set -e

curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

sudo apt update
sudo apt install xrdp -y
sudo systemctl enable --now xrdp
