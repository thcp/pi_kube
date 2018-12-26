#!/bin/bash

set -e 
source config.ini

#
# Download Raspbian Image
#
OUTFILE='raspbian_lite.zip'
if [ ! -f $OUTFILE ]; then
    curl -o "$OUTFILE" -L https://downloads.raspberrypi.org/raspbian_lite_latest
fi
unzip "$OUTFILE"

#
# Write Image to MicroSD 
#
IMG_FILE=$(ls *.img)
read -p "Plug your MicroSD card and press enter to continue"
df -h | grep "/dev"
echo -n "Confirm and type MicroSD card location (eg: /dev/xpto): "
read SD_LOCATION
echo
echo "Unmounting disk..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    sudo diskutil unmountDisk $SD_LOCATION
    echo "Burning image..."
    sudo dd bs=4m if="$IMG_FILE" of="$SD_LOCATION" conv=sync
else
    sync
    umount $BOOT_PATH
    echo "Burning image..."
    sudo dd bs=4M if="$IMG_FILE" of="$SD_LOCATION" conv=fsync
fi

#
# Touch 'ssh' file for enabling SSH server
#
sleep 10
echo
df
echo -n "Confirm and type boot mount point (eg: /run/media/user/boot): "
read BOOT_PATH
sudo touch "$BOOT_PATH/ssh"

#
# Sync and Unmount
#
if [[ "$OSTYPE" == "darwin"* ]]; then
    sudo diskutil unmountDisk $BOOT_PATH
else 
    sync
    umount $BOOT_PATH
fi

#
# Wait for your new friend to be available and setup key auth.
#
echo
echo "Unplug and boot to your new Pi!"
echo -n "Enter the remote IP address of the new Pi: "
read REMOTE_IP
echo
echo "Adding public key..."
echo "NOTE: The default password of 'raspberry' should be used (if prompted)"
ssh-copy-id pi@$REMOTE_IP
ssh pi@$REMOTE_IP sudo passwd -l pi

#
# Copy config and setup script to your new node and install docker/kubernetes
#
echo
echo "Copying files to our new friend and deploy kubernetes, sit back and relax"
scp config.ini setup.sh pi@$REMOTE_IP:/home/pi
ssh pi@$REMOTE_IP sh -c './setup.sh'
