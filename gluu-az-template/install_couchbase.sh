#!/bin/bash

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

echo "pre-installation steps"
mkdir /etc/tuned/no-thp
echo -e "[main]\ninclude=virtual-guest\n[vm]\ntransparent_hugepages=never" > /etc/tuned/no-thp/tuned.conf
tuned-adm profile no-thp
sh -c 'echo 0 > /proc/sys/vm/swappiness'
cp -p /etc/sysctl.conf /etc/sysctl.conf.`date +%Y%m%d-%H:%M`
sh -c 'echo "" >> /etc/sysctl.conf'
sh -c 'echo "#Set swappiness to 0 to avoid swapping" >> /etc/sysctl.conf'
sh -c 'echo "vm.swappiness = 0" >> /etc/sysctl.conf'

set -o nounset
set -o errexit
 
# May or may not have HOME set, and this drops stuff into ~/.local.
export HOME="/root"
export PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
 
# No package install yet.
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto
mv certbot-auto /usr/local/bin
 
# Install the dependencies.
certbot-auto --noninteractive --os-packages-only
 
# Set up config file.
mkdir -p /etc/letsencrypt
cat > /etc/letsencrypt/cli.ini <<EOF
# Uncomment to use the staging/testing server - avoids rate limiting.
# server = https://acme-staging.api.letsencrypt.org/directory
 
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
authenticator = webroot
webroot-path = /var/www/html
EOF
 
# Obtain cert.
certbot-auto certonly

#echo "creating certbot ini file"
#echo -e "# Use a 4096 bit RSA key instead of 2048.\nrsa-key-size = 4096\n\n# Set email and domains.\nemail = info@nqtech.ca\ndomains = ${hostname}\n\n\n# Text interface.\ntext = True\n# No prompts.\nnon-interactive = True\n# Suppress the Terms of Service agreement interaction.\nagree-tos = True\n\n# Use the webroot authenticator.\nauthenticator = webroot\nwebroot-path = /var/www/html" >

echo "install couchbase"  
curl -O https://packages.couchbase.com/releases/couchbase-release/couchbase-release-1.0-x86_64.rpm
sudo rpm -i ./couchbase-release-1.0-x86_64.rpm
sudo yum -y install couchbase-server

echo "waiting for services to start"
sleep 30

echo "setup cluster"
curl -v -X POST http://localhost:8091/pools/default -d memoryQuota=2048 -d indexMemoryQuota=512
curl -v http://localhost:8091/node/controller/setupServices -d services=kv%2cn1ql%2Cindex
curl -v http://localhost:8091/settings/web -d port=8091 -d username=Administrator -d password=deep_thoughtS!