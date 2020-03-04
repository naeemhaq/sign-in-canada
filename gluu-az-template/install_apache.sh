#!/bin/bash

# isntall gluu server 
echo "setting up repos for gluu"
wget https://repo.gluu.org/rhel/Gluu-rhel7.repo -O /etc/yum.repos.d/Gluu.repo
wget https://repo.gluu.org/rhel/RPM-GPG-KEY-GLUU -O /etc/pki/rpm-gpg/RPM-GPG-KEY-GLUU
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-GLUU
yum clean all

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
#yum install -y gluu-server
wget https://repo.gluu.org/centos/7/gluu-server-4.0-centos7.x86_64.rpm
mv gluu-server-4.0-centos7.x86_64.rpm /home/gluu
#rpm -Uvh gluu-server-4.0-centos7.x86_64.rpm

echo "enabling gluu server and logging into container"
/sbin/gluu-serverd enable
/sbin/gluu-serverd start

echo "downloading SIC tarball"
wget https://sicqa.blob.core.windows.net/staging/SIC-AP-0.0.31.tgz
tar -xvf SIC-AP-0.0.31.tgz

echo "downloading couchbase"
mkdir /opt/gluu-server/opt/dist/couchbase
wget https://gluudiagst2.blob.core.windows.net/gluustaging/couchbase-server-enterprise-6.5.0-centos7.x86_64.rpm
mv /var/lib/waagent/custom-script/download/0/couchbase-server-enterprise-6.5.0-centos7.x86_64.rpm /opt/gluu-server/opt/dist/couchbase/
echo "done!!"

exit

#echo "downloading setup.py and updating properties file"
#cd /opt/gluu-server/install/community-edition-setup
#wget https://raw.githubusercontent.com/naeemhaq/sign-in-canada/master/gluu-az-template/template2/setup.properties
#sed -i "s/10.1.0.5/$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)/g" setup.properties

#cd

#/sbin/gluu-serverd login
#cd /install/community-edition-setup
#./setup.py -psn -f setup.properties 

