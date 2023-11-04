#!/bin/bash

# Stop the systemd service
sudo systemctl stop sdip

# Disable and remove the systemd service
sudo systemctl disable sdip
sudo rm /etc/systemd/system/sdip.service
sudo systemctl daemon-reload

# Remove the command from /etc/rc.local
sudo sed -i '/SDIPC/d' /etc/rc.local

# Remove the SDIPC files
DOWNLOAD_DIR="/home/SDIP"
rm "$DOWNLOAD_DIR/SDIPC"
rm "$DOWNLOAD_DIR/SDIPC.ini"

# Inform user about completion
echo "SDIP service and related files have been removed."

# You may need to reboot for all changes to take full effect
echo "Please reboot your system if required."
