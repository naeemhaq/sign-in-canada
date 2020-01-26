#!/bin/bash

apt-get -y update

# install Apache2
apt-get -y install apache2
apt-get -y install unzip

# write some HTML
echo \<center\>\<h1\>My Demo App\</h1\>\<br/\>\</center\> > /var/www/html/demo.html

# restart Apache
apachectl restart

sudo bash
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

# isntall gluu server 
echo "gluu server install begins"
echo "deb https://repo.gluu.org/ubuntu/ bionic main" > /etc/apt/sources.list.d/gluu-repo.list
curl https://repo.gluu.org/ubuntu/gluu-apt.key | apt-key add -
apt-get install gluu-server

/sbin/gluu-serverd enable
/sbin/gluu-serverd start
/sbin/gluu-serverd login
cd /install/community-edition-setup
echo pwd
wget https://raw.githubusercontent.com/naeemhaq/sign-in-canada/master/gluu-az-template/template2/setup.properties
./setup.py -psn -f setup.properties 
