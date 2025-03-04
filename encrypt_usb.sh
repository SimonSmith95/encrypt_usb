#!/bin/bash

# Must run as sudo
if [[ $EUID -ne 0 ]]; then
   echo "❌ Please run this script as root (sudo)."
   exit 1
fi

# Show available disks
echo "🔍 Available disks:"
diskutil list

# Ask user for the disk to format
read -p "Enter the disk identifier to format (e.g., disk2): " DISK

# Confirm selection
read -p "⚠ WARNING: This will ERASE ALL DATA on /dev/$DISK. Are you sure? (yes/no): " CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then
    echo "❌ Operation cancelled."
    exit 1
fi

# Unmount and erase the disk
echo "🧹 Formatting /dev/$DISK as APFS..."
diskutil eraseDisk APFS "SecureDrive" /dev/$DISK || { echo "❌ Erase failed. Exiting."; exit 1; }

# Wait to ensure changes are applied
sleep 2

# Show APFS volumes
echo "🔍 Available APFS volumes:"
diskutil apfs list

# Ask user for the APFS volume to encrypt
read -p "Enter the volume identifier to encrypt (e.g., disk3s1): " VOLUME


# Encrypt the selected volume
echo "🔒 Encrypting /dev/$VOLUME..."
echo "$PASSWORD" | diskutil apfs encryptVolume /dev/$VOLUME -user disk || { echo "❌ Encryption failed. Exiting."; exit 1; }

echo "✅ Drive successfully reformatted and encrypted! 🚀"
