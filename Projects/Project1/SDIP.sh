#!/bin/bash

# Directory where the files will be saved
DOWNLOAD_DIR="/home/SDIP"

# Create the download directory if it doesn't exist
mkdir -p "$DOWNLOAD_DIR"

# URLs for downloading the SDIPC executable and configuration file
SDIPC_EXECUTABLE_URL="https://raw.githubusercontent.com/mrb4haa/sdip-pkgs/main/SDIPC/SDIPC"
SDIPC_CONFIG_URL="https://raw.githubusercontent.com/mrb4haa/sdip-pkgs/main/Projects/Project1/SDIPC.ini"

# Set execute permissions on SDIPC executable and configuration file
wget -q --output-document="$DOWNLOAD_DIR/SDIPC" "$SDIPC_EXECUTABLE_URL"
wget -q --output-document="$DOWNLOAD_DIR/SDIPC.ini" "$SDIPC_CONFIG_URL"
chmod +x "$DOWNLOAD_DIR/SDIPC"
chmod +x "$DOWNLOAD_DIR/SDIPC.ini"

# Create systemd service unit file
cat <<EOF | sudo tee /etc/systemd/system/sdip.service >/dev/null
[Unit]
Description=SDIP Auto Start

[Service]
Type=simple
ExecStart=$DOWNLOAD_DIR/SDIPC -c $DOWNLOAD_DIR/SDIPC.ini
ExecStartPre=/bin/sleep 20
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
sudo systemctl daemon-reload

# Enable and start the service
sudo systemctl enable sdip
sudo systemctl start sdip

# Add command to /etc/rc.local
echo "$DOWNLOAD_DIR/SDIPC -c $DOWNLOAD_DIR/SDIPC.ini &" | sudo tee -a /etc/rc.local >/dev/null

# Set execute permissions on /etc/rc.local
sudo chmod +x /etc/rc.local

# Inform user about completion
echo "SDIP service setup complete."

# You may need to reboot for the changes to take full effect
echo "Please reboot your system for the changes to take effect."
