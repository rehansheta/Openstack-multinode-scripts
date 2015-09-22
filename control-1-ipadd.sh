#!/bin/bash -ex
source config.cfg

echo "########## Config IP address for controller ##########"
ifaces=/etc/network/interfaces
test -f $ifaces.orig || cp $ifaces $ifaces.orig
rm $ifaces
touch $ifaces

# update the interface file /etc/network/interfaces
cat << EOF >> $ifaces

# LOOPBACK NETWORK 
auto lo
iface lo inet loopback

# MGNT NETWORK
auto $CON_MGNT_IFACE
iface $CON_MGNT_IFACE inet static
address $CON_MGNT_IP	
netmask $NETMASK_ADD	

# EXT NETWORK
auto $CON_EXT_IFACE
iface $CON_EXT_IFACE inet static
address $CON_EXT_IP	
netmask $NETMASK_ADD_2	
gateway $GATEWAY_IP	
dns-nameservers $DNS_NAME_SERVER	
EOF


#echo "Configuring hostname in CONTROLLER node"
#sleep 3
#echo "controller-juno" > /etc/hostname
#hostname -F /etc/hostname

# service networking restart

# ifdown eth0 && ifup eth0
# ifdown eth1 && ifup eth1
# ifdown eth2 && ifup eth2

echo "########## Rebooting machine ... ##########"
init 6

