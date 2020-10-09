#!/bin/bash

echo "pre-installation steps"
mkdir /etc/tuned/no-thp
echo -e "[main]\ninclude=virtual-guest\n[vm]\ntransparent_hugepages=never" > /etc/tuned/no-thp/tuned.conf
tuned-adm profile no-thp
sh -c 'echo 0 > /proc/sys/vm/swappiness'
cp -p /etc/sysctl.conf /etc/sysctl.conf.`date +%Y%m%d-%H:%M`
sh -c 'echo "" >> /etc/sysctl.conf'
sh -c 'echo "#Set swappiness to 0 to avoid swapping" >> /etc/sysctl.conf'
sh -c 'echo "vm.swappiness = 0" >> /etc/sysctl.conf'

echo "install couchbase"  
curl -O https://packages.couchbase.com/releases/couchbase-release/couchbase-release-1.0-x86_64.rpm
sudo rpm -i ./couchbase-release-1.0-x86_64.rpm
sudo yum -y install couchbase-server

echo "setup cluster"
curl -v -X POST http://localhost:8091/pools/default -d memoryQuota=2048  -d indexMemoryQuota=512
curl -v http://localhost:8091/node/controller/setupServices -d services=kv%2cn1ql%2Cindex