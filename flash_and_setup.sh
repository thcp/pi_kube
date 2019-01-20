#!/bin/bash

set -e 

echo """
Before proceeding please update the following files:
- config.ini
- dhcpcd.conf
"""
read -p "Press any key to continue..."

source config.ini


#
# Download Raspbian Image
#
OUTFILE='raspbian_lite.zip'
if [ ! -f $OUTFILE ]; then
    curl -L https://downloads.raspberrypi.org/raspbian_lite_latest -o "$OUTFILE"
fi
unzip "$OUTFILE"

#
# Download latest Etcher release
#
GITHUB_URL="https://api.github.com/repos/balena-io/etcher/releases/latest"
VERSION=$(curl -s $GITHUB_URL | grep -oP '"tag_name": "\K(.*)(?=")'  | sed 's/v//g')

BASE_DOWNLOAD_URL="https://github.com/balena-io/etcher/releases/download"
if [[ "${OSTYPE}" == "darwin"* ]]; then
    DOWNLOAD_URL="${BASE_DOWNLOAD_URL}/v${VERSION}/balenaEtcher-${VERSION}.dmg"
else
    DOWNLOAD_URL="${BASE_DOWNLOAD_URL}/v${VERSION}/balena-etcher-electron-${VERSION}-linux-x64.zip"
fi

curl -L "${DOWNLOAD_URL}" -o etcher.zip && unzip etcher.zip && rm etcher.zip


echo """
###############################################
# Close Etcher after flashing...
###############################################
"""
./*"${VERSION}"*

echo "Create ssh file on /boot partition for enabling ssh server"
read -p "Press any key to continue..."
echo "Append content of cmdline.local.txt to /boot/cmdline.txt, please make a backup of the old one as cmdline.txt.bkp"
read -p "Press any key to continue..."
echo "Copy dhcpdcd.conf to /etc to your microsd root path"
read -p "Press any key to continue..."

echo
echo "Umount, boot your pi and perform the following commands: "
echo """
REMOTE_IP='ipaddr'
ssh-copy-id pi@\$REMOTE_IP
ssh pi@\$REMOTE_IP sudo passwd -l pi
scp config.ini setup.sh pi@\$REMOTE_IP:/home/pi
ssh pi@\$REMOTE_IP sh -c './setup.sh'
"""
