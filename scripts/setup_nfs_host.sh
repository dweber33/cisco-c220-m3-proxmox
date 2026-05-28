#!/bin/bash
# setup_nfs_host.sh - Automates the NFS server setup for Cisco CIMC vMedia mounting.

# Usage: sudo ./setup_nfs_host.sh <CIMC_IP>

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)"
   exit 1
fi

CIMC_IP=$1
if [ -z "$CIMC_IP" ]; then
    echo "Usage: ./setup_nfs_host.sh <CIMC_IP>"
    exit 1
fi

ISO_DIR="$(pwd)/iso_share"
mkdir -p "$ISO_DIR"

echo "Installing NFS Server..."
apt-get update && apt-get install -y nfs-kernel-server

echo "Configuring NFS Export for $CIMC_IP..."
# Add export rule if it doesn't exist
EXPORT_LINE="$ISO_DIR $CIMC_IP(rw,sync,no_subtree_check,no_root_squash)"
if ! grep -qF "$EXPORT_LINE" /etc/exports; then
    echo "$EXPORT_LINE" >> /etc/exports
fi

exportfs -ra
systemctl restart nfs-kernel-server

echo "------------------------------------------------"
echo "NFS Setup Complete!"
echo "Share Directory: $ISO_DIR"
echo "Next Step: Place your Proxmox ISO in that folder."
echo "CIMC Command: map-nfs proxmox $(hostname -I | awk '{print $1}'):$ISO_DIR <filename>.iso"
echo "------------------------------------------------"
