#!/bin/bash

# isntall gluu server 
echo "setting up repos for gluu"
echo "deb https://repo.gluu.org/ubuntu/ bionic main" > /etc/apt/sources.list.d/gluu-repo.list
curl https://repo.gluu.org/ubuntu/gluu-apt.key | apt-key add -
apt-get update

# update hosts file with hostname and IP addresses
echo "updating hosts file with hostname and IP addresses"

ip=$(curl -H Metadata:true "http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/publicIpAddress?api-version=2017-08-01&format=text")
hostname=gluuserver-cc-01.canadacentral.cloudapp.azure.com
privateIP=$(curl -H Metadata:true "http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/privateIpAddress?api-version=2017-08-01&format=text")
sed -i.bkp "$ a $ip $hostname" /etc/hosts
sed -i.bkp "$ a $privateIP $hostname" /etc/hosts
echo > /etc/hostname
echo $hostname > /etc/hostname

echo "gluu server install begins"
apt-get install gluu-server

echo "enabling gluu server and logging into container"
/sbin/gluu-serverd enable
/sbin/gluu-serverd start
#/sbin/gluu-serverd login
#cd /install/community-edition-setup
#./setup.py -psn -f setup.properties 

