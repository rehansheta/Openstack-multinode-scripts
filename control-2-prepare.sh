#!/bin/bash -ex
source config.cfg

echo "############ Configuring hostnames ############"
sleep 3
iphost=/etc/hosts
test -f $iphost.orig || cp $iphost $iphost.orig
rm $iphost
touch $iphost

# update hosts file /etc/hosts
cat << EOF >> $iphost
127.0.0.1       localhost
#127.0.1.1      controller-juno
$CON_MGNT_IP    $CON_NAME
$COM1_MGNT_IP   $COM1_NAME
$COM2_MGNT_IP   $COM2_NAME
$NET_MGNT_IP    $NET_NAME
EOF

echo "########## Updates for Ubuntu ##########"
apt-get install ubuntu-cloud-keyring -y
echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu" \
"trusty-updates/juno main" > /etc/apt/sources.list.d/cloudarchive-juno.list
sleep 5
apt-get -y update && apt-get -y dist-upgrade

echo "########## Install and config NTP ##########"
sleep 3 
apt-get install ntp -y
cp /etc/ntp.conf /etc/ntp.conf.bka
rm /etc/ntp.conf
cat /etc/ntp.conf.bka | grep -v ^# | grep -v ^$ >> /etc/ntp.conf

sed -i 's/server ntp.ubuntu.com/ \
server 0.vn.pool.ntp.org iburst \
server 1.asia.pool.ntp.org iburst \
server 2.asia.pool.ntp.org iburst/g' /etc/ntp.conf

sed -i 's/restrict -4 default kod notrap nomodify nopeer noquery/ \
#restrict -4 default kod notrap nomodify nopeer noquery/g' /etc/ntp.conf

sed -i 's/restrict -6 default kod notrap nomodify nopeer noquery/ \
restrict -4 default kod notrap nomodify \
restrict -6 default kod notrap nomodify/g' /etc/ntp.conf

# sed -i 's/server/#server/' /etc/ntp.conf
# echo "server $CON_MGNT_IP" >> /etc/ntp.conf


echo "########## Install and Config RabbitMQ ##########"
sleep 3
apt-get install rabbitmq-server -y
rabbitmqctl change_password guest $RABBIT_PASS
sleep 3

service rabbitmq-server restart
echo "########## Finish setup pre-install package ##########"

