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
cat > /etc/letsencrypt/cli.ini <<EOF
# Uncomment to use the staging/testing server - avoids rate limiting.
server = https://acme-staging.api.letsencrypt.org/directory
 
# Use a 4096 bit RSA key instead of 2048.
rsa-key-size = 4096
 
# Set email and domains.
email = info@nqteh.ca
domains = ${hostname}
 
# Text interface.
text = True
# No prompts.
non-interactive = True
# Suppress the Terms of Service agreement interaction.
agree-tos = True
 
# Use the webroot authenticator.
#authenticator = webroot
#webroot-path = /var/www/html
EOF

#echo "install certbot"
#yum -y install epel-release
#yum -y install snapd
#systemctl enable --now snapd.socket
#ln -s /var/lib/snapd/snap /snap
#yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
#yum -y install certbot python2-certbot-apache

#sudo certbot certonly --standalone

echo "gluu server install begins"
mkdir staging && cd staging
yum install -y gluu-server
wget https://repo.gluu.org/centos/7/gluu-server-4.1.0-centos7.x86_64.rpm
rpm -Uvh gluu-server-4.1.0-centos7.x86_64.rpm
#echo "updating the timeouts"
#sed -i "s/# jetty.server.stopTimeout=5000/jetty.server.stopTimeout=15000/g" /opt/gluu-server/opt/gluu/jetty/identity/start.ini
#sed -i "s/# jetty.http.connectTimeout=15000/jetty.http.connectTimeout=15000/g" /opt/gluu-server/opt/gluu/jetty/identity/start.ini

echo "enabling gluu server and logging into container"
/sbin/gluu-serverd enable
/sbin/gluu-serverd start

#echo "downloading SIC tarball"
#wget https://gluuccrgdiag.blob.core.windows.net/gluu/SIC-Admintools-0.0.132.tgz
#wget https://gluuccrgdiag.blob.core.windows.net/gluu/SIC-AP-0.0.132.tgz
#tar -xvf SIC-AP-0.0.132.tgz
#tar -xvf SIC-Admintools-0.0.132.tgz

wget -O setup.properties "https://gluuccrgdiag.blob.core.windows.net/gluu-install/setup.properties?sp=r&st=2020-10-19T00:29:58Z&se=2020-10-19T08:29:58Z&spr=https&sv=2019-12-12&sr=b&sig=JLEy%2BRnjvVvsv5r33h9KOUvPDNx2%2BAqlfgVzds6hcts%3D"

cp setup.properties /opt/gluu-server/install/community-edition-setup/

ssh  -o IdentityFile=/etc/gluu/keys/gluu-console -o Port=60022 -o LogLevel=QUIET \
                -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
                -o PubkeyAuthentication=yes root@localhost \
            "/install/community-edition-setup/setup.py -n -f setup.properties"

if [ ! -f /opt/gluu-server/install/community-edition-setup/setup.py ] ; then
   echo "Gluu setup install failed. Aborting!"
   exit
fi

echo "setting up ACME script"
yum install -y socat
curl https://get.acme.sh | sh
exec bash
/.acme.sh/acme.sh --issue --standalone -d $hostname

#echo "downloading setup.py and updating properties file"
#cd /opt/gluu-server/install/community-edition-setup
#wget https://raw.githubusercontent.com/naeemhaq/sign-in-canada/master/gluu-az-template/template2/setup.properties
#sed -i "s/10.1.0.5/$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)/g" setup.properties

#cd

#/sbin/gluu-serverd login
#cd /install/community-edition-setup
#./setup.py -psn -f setup.properties 

