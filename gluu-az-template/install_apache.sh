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