# Naming Convention
# Master : NAME-master
# Workers: NAME-Worker-[0-9]

# library imports
import socket, struct

#export HOSTNAME=""
#export IPADDR=""
#export ROUTER=""
#export DNS=""

def get_default_gateway_linux():
    """Read the default gateway directly from /proc."""
    with open("/proc/net/route") as fh:
        for line in fh:
            fields = line.strip().split()
            if fields[1] != '00000000' or not int(fields[3], 16) & 2:
                continue

            return socket.inet_ntoa(struct.pack("<L", int(fields[2], 16)))

# get hostname, IP address, router and dns
def host_info():
    try:
        host_name = socket.gethostname()
        host_ip = socket.gethostbyname(host_name)
        router_info = get_default_gateway_linux()
        domain_name = socket.getfqdn()
        
        print("Host name: %s, Host IP: %s, Router: %s and Domain: %s" % (host_name, host_ip, router_info, domain_name))
    except:
        print("Unable to retrieve hostname information.")
