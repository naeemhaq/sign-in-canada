#!/bin/bash

# isntall gluu server 
echo "setting up repos for gluu"
wget https://repo.gluu.org/rhel/Gluu-rhel7.repo -O /etc/yum.repos.d/Gluu.repo
wget https://repo.gluu.org/rhel/RPM-GPG-KEY-GLUU -O /etc/pki/rpm-gpg/RPM-GPG-KEY-GLUU
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-GLUU
yum clean all

# update hosts file with hostname and IP addresses
echo "updating hosts file with hostname and IP addresses"

zayn=$(curl -H Metadata:true "http://169.254.169.254/metadata/instance/compute/name?api-version=2017-08-01&format=text")
hostname="${zayn}.canadacentral.cloudapp.azure.com"
ip=$(curl -H Metadata:true "http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/publicIpAddress?api-version=2017-08-01&format=text")
privateIP=$(curl -H Metadata:true "http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/privateIpAddress?api-version=2017-08-01&format=text")
sed -i.bkp "$ a $ip $hostname" /etc/hosts
sed -i.bkp "$ a $privateIP $hostname" /etc/hosts
echo > /etc/hostname
echo $hostname > /etc/hostname

# certbot ini file. 
echo -e "# Use a 4096 bit RSA key instead of 2048.\nrsa-key-size = 4096\n\n# Set email and domains.\nemail = info@nqtech.ca\ndomains = ${hostname}\n\n\n# Text interface.\ntext = True\n# No prompts.\nnon-interactive = True\n# Suppress the Terms of Service agreement interaction.\nagree-tos = True\n\n# Use the webroot authenticator.\nauthenticator = webroot\nwebroot-path = /var/www/html" >

echo "install certbot"
yum -y install epel-release
yum -y install snapd
systemctl enable --now snapd.socket
ln -s /var/lib/snapd/snap /snap
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install certbot python2-certbot-apache

sudo certbot certonly --standalone

echo "gluu server install begins"
#yum install -y gluu-server
wget https://repo.gluu.org/centos/7/gluu-server-4.0-centos7.x86_64.rpm
rpm -Uvh gluu-server-4.0-centos7.x86_64.rpm
echo "updating the timeouts"
sed -i "s/# jetty.server.stopTimeout=5000/jetty.server.stopTimeout=15000/g" /opt/gluu-server/opt/gluu/jetty/identity/start.ini
sed -i "s/# jetty.http.connectTimeout=15000/jetty.http.connectTimeout=15000/g" /opt/gluu-server/opt/gluu/jetty/identity/start.ini

echo "enabling gluu server and logging into container"
/sbin/gluu-serverd enable
/sbin/gluu-serverd start

echo "downloading SIC tarball"
wget https://sicqa.blob.core.windows.net/staging/SIC-AP-0.0.31.tgz
tar -xvf SIC-AP-0.0.31.tgz

exit

#echo "downloading setup.py and updating properties file"
#cd /opt/gluu-server/install/community-edition-setup
#wget https://raw.githubusercontent.com/naeemhaq/sign-in-canada/master/gluu-az-template/template2/setup.properties
#sed -i "s/10.1.0.5/$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)/g" setup.properties

#cd

#/sbin/gluu-serverd login
#cd /install/community-edition-setup
#./setup.py -psn -f setup.properties 

