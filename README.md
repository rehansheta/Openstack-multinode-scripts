# openstack-multinode-scripts

Complete set of scripts for installing openstack juno on ubuntu 14.04 with neutron networking. It considers a 3 node cluster with a controller node, a neutron node and a compute node.

# Instructions

1. Update the variables of config.cfg file

2. Edit the “update file /etc/network/interfaces” section of all *-1-ipadd.sh files

3. Log into Controller:

	1. Run the following script files

		1. sudo ./control-1-ipadd.sh
		2. sudo ./control-2-prepare.sh
		3. sudo ./control-3-create-db.sh
		4. sudo ./control-4-keystone.sh
		5. sudo ./control-5-creatusetenant.sh
		
	2. Test keystone
	
		1. source admin-openrc.sh
		2. keystone user-list
		
	3. Run the following script file
	
		1. sudo ./control-6-glance.sh
		
	4. Test glance
	
		1. source admin-openrc.sh
		2. cd images/
		3. glance image-create --name "cirros-0.3.3-x86_64" --disk-format qcow2 --container-format bare --is-public True --progress < cirros-0.3.3-x86_64-disk.img
		4. glance image-list
		
	5. Run the following script files
	
		1. sudo ./control-7-nova.sh
		2. sudo ./control-8-neutron.sh
	
	6. Test neutron
		
		1. source admin-openrc.sh
		2. neutron ext-list

4. Log into Network:
	
	1. Run the following script files
		
		1. sudo ./net-1-ipadd.sh
		2. sudo ./net-2-prepare.sh

5. Log into Compute1:
	
	1. Run the following script files
		
		1. sudo ./com1-1-ipadd.sh
		2. sudo ./com1-2-prepare.sh

6. Log into Compute2:
	
	1. Run the following script files
		
		1. sudo ./com2-1-ipadd.sh
		2. sudo ./com2-2-prepare.sh

7. Log into Controller
	
	1. Run the following script files
		
		1. sudo ./control-9-create-net.sh
		2. sudo ./control-10-horizon.sh

8. Restart all the nodes

9. Test on controller
	
	1. source admin-openrc.sh
	2. keystone user-list
	3. nova service-list
	4. glance image-list
	5. neutron agent-list

# Reference

<http://docs.openstack.org/juno/install-guide/install/apt/content/ch_basic_environment.html>
