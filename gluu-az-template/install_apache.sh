#!/bin/bash

apt-get -y update

# isntall gluu server 
echo "gluu server install begins"
echo "deb https://repo.gluu.org/ubuntu/ bionic main" > /etc/apt/sources.list.d/gluu-repo.list
curl https://repo.gluu.org/ubuntu/gluu-apt.key | apt-key add - &> install.log
wget https://repo.gluu.org/ubuntu/pool/main/bionic/gluu-server_4.0~bionic_amd64.deb
apt-get update

# update hosts file with hostname and IP addresses
echo "updating hosts file with hostname and IP addresses"

ip=$(curl -H Metadata:true "http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/publicIpAddress?api-version=2017-08-01&format=text")
 hostname=gluuserver-cc-01.canadacentral.cloudapp.azure.com
 privateIP=$(curl -H Metadata:true "http://169.254.169.254/metadata/instance/network/interfacipAddress/0/privateIpAddress?api-version=2017-08-01&format=text")
 sed -i.bkp "$ a $ip $hostname" /etc/hosts
 sed -i.bkp "$ a $privateIP $hostname" /etc/hosts

 echo "installing gluu server package"
apt install -y /var/lib/waagent/custom-script/download/0/gluu-server_4.0~bionic_amd64.deb

echo "enabling gluu server and logging into container"
/sbin/gluu-serverd enable
/sbin/gluu-serverd start
/sbin/gluu-serverd login
cd /install/community-edition-setup
echo pwd
wget https://raw.githubusercontent.com/naeemhaq/sign-in-canada/master/gluu-az-template/template2/setup.properties
sed -i "s/10.1.0.5/$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)/g" setup.properties
./setup.py -psn -f setup.properties 

echo downloading shib repo contents
wget https://github.com/sign-in-canada/shib-oxauth-authn3/archive/master.zip
echo finished downloading
echo unziping shib-oxauth-authn3
unzip master.zip
rm master.zip
echo downloading gluu-passport
wget https://github.com/sign-in-canada/gluu-passport/archive/master.zip
echo finished downloading
unzip master.zip
