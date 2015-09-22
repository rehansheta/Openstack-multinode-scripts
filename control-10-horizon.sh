#!/bin/bash -ex
source config.cfg
source admin-openrc.sh

echo "########## Installing Dashboard packages ##########"
apt-get -y install openstack-dashboard apache2 libapache2-mod-wsgi memcached python-memcache 

#echo "########## Removing the default theme ###########"
#dpkg --purge openstack-dashboard-ubuntu-theme

echo "########## Configuring the dashboard ##########"
sed -i "/OPENSTACK_HOST = /c\OPENSTACK_HOST = \"$CON_MGNT_IP\"" /etc/openstack-dashboard/local_settings.py
sed -i "/ALLOWED_HOSTS = /c\ALLOWED_HOSTS = ['*']" /etc/openstack-dashboard/local_settings.py
sed -i "s/127.0.0.1:11211/$CON_MGNT_IP:11211/g" /etc/openstack-dashboard/local_settings.py

echo "########## Restarting apache2 and memcached ##########"
service apache2 restart
service memcached restart

echo "########## LOGIN INFORMATION IN HORIZON ##########"
echo "URL: http://$CON_EXT_IP/horizon"
echo "User: admin or demo"
echo "Password:" $ADMIN_PASS

