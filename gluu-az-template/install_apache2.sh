#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Please specify Couchbase IP and password"
    echo "./install.sh 10.0.1.4 jibrish"
    exit
fi

echo Couchbase IP is ${1}... 
echo Couchbase password ${2}

echo Couchbase IP is ${1}... > couchbase.log
echo Couchbase Password ${2}... >> couchbase.log

ls -al 
pwd 