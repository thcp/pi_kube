# pi-kube

Deployment and configuration of Kubernetes on raspberry pi 3 b+


# Usage

#### Writing raspian image on micro sd
First you must use `raspian_install.sh` for writing [Raspbian Stretch Lite](https://www.raspberrypi.org/downloads/raspbian/) on your sd card, this script will also suggest you to enable ssh connections which consists on creating a ssh file where `boot` mount is placed. For those who are not aware, default credentials are `pi:raspberry`. Make sure to disable password at the sshd config file and copy your public key using `ssh-copy-id pi@<ip>` 


#### Deployment of network definitions, docker and kubernetes

Simply execute `raspbian_install.sh` , and the following actions will be take care of:
- Network setup by defining a static ip
- Update Kernel kernel arguments necessary for kubernetes on `/boot/cmdline.txt` file
- Swap disable
- Install Docker/Kubernetes
- Setup Weave Network

