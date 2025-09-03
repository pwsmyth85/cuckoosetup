#!/bin/bash
set -e

# ------------------------
# Cuckoo Sandbox Startup Script
# ------------------------

# 1. Activate Python 2.7 venv for Cuckoo
echo "[*] Activating pyenv environment..."
eval "$(pyenv init -)"
pyenv activate cuckoo-py2

# 2. Start MongoDB container (if not running already)
if ! docker ps --format '{{.Names}}' | grep -q '^mongodb$'; then
    echo "[*] Starting MongoDB container..."
    docker start mongodb || docker run -d --name mongodb -p 27017:27017 -v ~/mongo-data:/data/db mongo:7.0
else
    echo "[*] MongoDB is already running."
fi

# 3. Start the main Cuckoo process (scheduler)
echo "[*] Starting Cuckoo scheduler..."
cuckoo -d &
CUCKOO_PID=$!

# 4. Start the Web Interface
echo "[*] Starting Cuckoo web interface on port 8000..."
cuckoo web runserver 0.0.0.0:8000 &
WEB_PID=$!

# 5. (Optional) Start API server
# echo "[*] Starting Cuckoo API on port 8090..."
# cuckoo api &

echo
echo "=========================================="
echo " Cuckoo Sandbox is running!"
echo " - Scheduler PID: $CUCKOO_PID"
echo " - Web UI PID:    $WEB_PID"
echo
echo " Access the Web UI at: http://<VM-IP>:8000"
echo "=========================================="

# Keep script running so background processes don’t exit
wait
