#!/bin/bash -ex
source config.cfg

echo "########## Installing KEYSTONE ##########"
apt-get -y install keystone python-keystoneclient 

echo "########## Configuring file nova.conf ##########"
filekeystone=/etc/keystone/keystone.conf
test -f $filekeystone.orig || cp $filekeystone $filekeystone.orig

# update Config file /etc/keystone/keystone.conf
cat << EOF > $filekeystone
[DEFAULT]
verbose = True
log_dir=/var/log/keystone
admin_token = $TOKEN_PASS

[assignment]
[auth]
[cache]
[catalog]
[credential]

[database]
connection = mysql://keystone:$KEYSTONE_DBPASS@$CON_MGNT_IP/keystone

[ec2]
[endpoint_filter]
[endpoint_policy]
[federation]
[identity]
[identity_mapping]
[kvs]
[ldap]
[matchmaker_redis]
[matchmaker_ring]
[memcache]
[oauth1]
[os_inherit]
[paste_deploy]
[policy]
[revoke]
driver = keystone.contrib.revoke.backends.sql.Revoke

[saml]
[signing]
[ssl]
[stats]
[token]
provider = keystone.token.providers.uuid.Provider
driver = keystone.token.persistence.backends.sql.Token

[trust]
[extra_headers]
Distribution = Ubuntu

EOF

# Remove default keystone db
rm  /var/lib/keystone/keystone.db

echo "########## Restarting KEYSTONE service ##########"
service keystone restart
sleep 3
service keystone restart

echo "########## Syncing KEYSTONE db ##########"
sleep 3
keystone-manage db_sync

(crontab -l -u keystone 2>&1 | grep -q token_flush) || \
echo '@hourly /usr/bin/keystone-manage token_flush >/var/log/keystone/keystone-tokenflush.log 2>&1' >> /$



