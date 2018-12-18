# pi-kube

Install Kubernetes/Docker on raspberry pi 3 B+


# Usage

Simply execute `sd_write.sh` and the following actions will be take care of:
- Download of the latest Raspbian lite image
- Write image to microsd card
- Enable ssh connection
- Wait for connection for copying public key
- ssh-copy  of `setup.sh` and `config.ini` for the new guy and automatic steps will be taken care of:
- Network setup 
- Update Kernel kernel arguments necessary for kubernetes on `/boot/cmdline.txt` file
- Swap disable
- Install Docker/Kubernetes
- Setup Weave Network

# Todo

- [ ] Deploy nodes via Chef
- [ ] Improve image writer logic
- [ ] Include Kubernetes Dashboard deployment
- [ ] Include helm/tiller installation ?
- [ ] Auto add new nodes to Cluster
