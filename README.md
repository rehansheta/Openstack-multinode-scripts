# openstack-multinode-scripts

Complete set of scripts for installing openstack juno on ubuntu 14.04 with neutron networking. It considers a 3 node cluster with a controller node, a neutron node and a compute node.

# Instructions

1. Update the variables of config.cfg file

2. Edit the “update file /etc/network/interfaces” section of all *-1-ipadd.sh files

3. Log into Controller:
	a) Run the following script files
		sudo ./control-1-ipadd.sh
		sudo ./control-2-prepare.sh
		sudo ./control-3-create-db.sh
		sudo ./control-4-keystone.sh
		sudo ./control-5-creatusetenant.sh
	c) Test keystone
		source admin-openrc.sh
		keystone user-list
	d) Run the following script file
		sudo ./control-6-glance.sh
	e) Test glance
		source admin-openrc.sh
		cd images/
		glance image-create --name "cirros-0.3.3-x86_64" --disk-format qcow2 --container-format bare --is-public True --progress < cirros-0.3.3-x86_64-disk.img
		glance image-list
	f) Run the following script files		
		sudo ./control-7-nova.sh
		sudo ./control-8-neutron.sh
	g) Test neutron
		source admin-openrc.sh
		neutron ext-list

4. Log into Network:
	a) Run the following script files
		sudo ./net-1-ipadd.sh
		sudo ./net-2-prepare.sh

5. Log into Compute1:
	a) Run the following script files
		sudo ./com1-1-ipadd.sh
		sudo ./com1-2-prepare.sh

6. Log into Compute2:
	a) Run the following script files
		sudo ./com2-1-ipadd.sh
		sudo ./com2-2-prepare.sh

7. Log into Controller
	a) Run the following script files
		sudo ./control-9-create-net.sh
		sudo ./control-10-horizon.sh

8. Restart all the nodes

9. Test on controller
	source admin-openrc.sh
	keystone user-list
	nova service-list
	glance image-list
	neutron agent-list

# Reference

<http://docs.openstack.org/juno/install-guide/install/apt/content/ch_basic_environment.html>
