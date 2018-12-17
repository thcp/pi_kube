#!/bin/bash

set -e 

source config.ini
#
# Download Raspbian Image
#
OUTFILE='raspbian_lite.zip'
wget https://downloads.raspberrypi.org/raspbian_lite_latest -O "$OUTFILE"
unzip "$OUTFILE"
#
# Write Image to sd 
#
IMG_FILE=$(ls *.img)
read -p "Plug your microsd card and press enter to continue"
df -h | grep "/dev"
echo "Confirm and type sd card location ( eg: /dev/xpto ): "
read SD_LOCATION
echo "Burning image..."
sudo dd bs=4M if="$IMG_FILE" of="$SD_LOCATION" conv=fsync
#
# Touch ssh file for enabling ssh server
#
df 
echo "Confirm and type boot mount point ( eg: /run/media/user/boot ) : "
read BOOT_PATH
sudo touch "$BOOT_PATH/ssh"
#
# sync and umount
#
sync
umount $BOOT_PATH
#
# Wait for your new friend to be available and setup key auth.
#
echo "unplug boot your new pi and wait for ssh authentication"
while true; do
    ping -c 1 raspberrypi.local && break
done
echo "adding public key with default password, PLEASE CHANGE IT!!!"
sshpass -p raspberry ssh-copy-id pi@raspberrypi.local
#
# Copy config and setup script to your new node and install docker/kubernetes
#
echo "Copying files to our new friend and deploy kubernetes, sit back and relax"
scp config.ini setup.sh pi@raspberrypi.local:/home/pi
ssh pi@raspberrypi.local sh -c './setup.sh'
