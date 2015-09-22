#!/bin/bash -ex
source config.cfg

echo "########## Updates for Ubuntu ##########"
apt-get -y install ubuntu-cloud-keyring
echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu" \
"trusty-updates/juno main" > /etc/apt/sources.list.d/cloudarchive-juno.list
apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y

echo "########## Install and Config OpenvSwitch ##########"
apt-get install -y openvswitch-controller openvswitch-switch openvswitch-datapath-dkms

echo "########## Install and Config NTP ##########"
sleep 7 
apt-get install ntp -y
apt-get install python-mysqldb -y

echo "########## Back-up NTP configuration ##########"
sleep 7 
cp /etc/ntp.conf /etc/ntp.conf.bka
rm /etc/ntp.conf
cat /etc/ntp.conf.bka | grep -v ^# | grep -v ^$ >> /etc/ntp.conf

sed -i 's/server 0.ubuntu.pool.ntp.org/ \
#server 0.ubuntu.pool.ntp.org/g' /etc/ntp.conf

sed -i 's/server 1.ubuntu.pool.ntp.org/ \
#server 1.ubuntu.pool.ntp.org/g' /etc/ntp.conf

sed -i 's/server 2.ubuntu.pool.ntp.org/ \
#server 2.ubuntu.pool.ntp.org/g' /etc/ntp.conf

sed -i 's/server 3.ubuntu.pool.ntp.org/ \
#server 3.ubuntu.pool.ntp.org/g' /etc/ntp.conf

sed -i "s/server ntp.ubuntu.com/server $CON_MGNT_IP iburst/g" /etc/ntp.conf

echo "########## Config br-int and br-ext for OpenvSwitch ##########"
sleep 5
ovs-vsctl add-br br-int
ovs-vsctl add-br br-ext
ovs-vsctl add-port br-ext $NET_EXT_IFACE_BR

echo "########## Config IP address for br-ext ##########"
ifaces=/etc/network/interfaces
test -f $ifaces.orig1 || cp $ifaces $ifaces.orig1
rm $ifaces

# update the interface file /etc/network/interfaces
cat << EOF > $ifaces

# LOOPBACK NETWORK
auto lo
iface lo inet loopback

auto br0
iface br0 inet static
address $NET_EXT_IP	
netmask $NETMASK_ADD_2	
gateway $GATEWAY_IP	
        bridge_ports $NET_EXT_IFACE_CON

# PRIMARY/EXT NETWORK
auto br-ext
iface br-ext inet static
address $NET_EXT_IP	
netmask $NETMASK_ADD_2	
gateway $GATEWAY_IP	
dns-nameservers $DNS_NAME_SERVER

auto $NET_EXT_IFACE_BR
iface $NET_EXT_IFACE_BR inet manual
   up ifconfig \$IFACE 0.0.0.0 up
   up ip link set \$IFACE promisc on
   down ip link set \$IFACE promisc off
   down ifconfig \$IFACE down

# MGNT NETWORK
auto br1
iface br1 inet static
address $NET_MGNT_IP	
netmask $NETMASK_ADD	
	bridge_ports $NET_MGNT_IFACE

# DATA NETWORK
auto $NET_DATA_IFACE
iface $NET_DATA_IFACE inet static
address $NET_DATA_VM_IP	
netmask $NETMASK_ADD	

iface eth0 inet manual
iface eth1 inet manual
iface eth2 inet manual
#iface eth3 inet manual
iface eth4 inet manual
#iface eth5 inet manual
#iface eth6 inet manual
#iface eth7 inet manual
iface eth8 inet manual
iface eth9 inet manual

EOF

#echo "Config hostname for NETWORK NODE"
#sleep 3
#echo "network-juno" > /etc/hostname
#hostname -F /etc/hostname

echo "########## Rebooting machine ... ##########"
init 6


