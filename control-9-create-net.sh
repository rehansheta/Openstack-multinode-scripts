#!/bin/bash -ex
source config.cfg
source admin-openrc.sh

echo "########## Add rules to the default policy ##########"
nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
nova secgroup-add-rule default tcp 1 65535 0.0.0.0/0
nova secgroup-add-rule default udp 1 65535 0.0.0.0/0


###############################
# PROVIDER
###############################

echo "########## Create provider (EXTENAL) network ##########"
neutron net-create ext_net --router:external True --shared

echo "########## Create EXTENAL subnet ##########"
neutron subnet-create --name sub_ext_net ext_net $EXTERNAL_ADDRESSES --gateway $GATEWAY_IP --allocation-pool start=$EX_NET_ALLOC_POLL_START,end=$EX_NET_ALLOC_POLL_END --enable_dhcp=False --dns-nameservers list=true $DNS_NAME_SERVER $DNS_NAME_SERVER_2


###############################
# Create tenant Network
###############################

echo "########## Create INTERNAL data and management networks ##########"
neutron net-create int_net_1
neutron net-create int_net_2

echo "########## Create INTERNAL data and management sub-nets ##########"
neutron subnet-create int_net_1 --name int_subnet_1 $INTERNAL_DATA_ADDRESSES --allocation-pool start=$INT_DATA_NET_ALLOC_POLL_START,end=$INT_DATA_NET_ALLOC_POLL_END --dns-nameserver $DNS_NAME_SERVER

neutron subnet-create int_net_2 --name int_subnet_2 $INTERNAL_MANAGEMENT_ADDRESSES --allocation-pool start=$INT_MGMT_NET_ALLOC_POLL_START,end=$INT_MGMT_NET_ALLOC_POLL_END --dns-nameserver $DNS_NAME_SERVER


###############################
# Create router and interfaces
###############################

echo "########## Create router ##########"
neutron router-create router_1

echo "########## Add interfaces to Router ##########"
neutron router-interface-add router_1 int_subnet_1
neutron router-interface-add router_1 int_subnet_2

echo "########## Add defaul gateway to Router ##########"
neutron router-gateway-set router_1 ext_net

