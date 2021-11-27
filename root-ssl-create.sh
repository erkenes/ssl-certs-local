#!/bin/bash

clear

echo -n "Create private Key."
echo ""
echo ""
openssl genrsa -out myRoot.key 2048

echo ""
echo ""
echo ""
echo -n "Create CA-Certificate"
echo ""
echo ""
openssl req -x509 -new -nodes -key myRoot.key -sha256 -days 3650 \
             -out myRoot.crt
echo ""
echo ""
echo ""
echo -n "You have to install the root certificate \"myRoot.crt\" to your system. DO NOT RENAME THIS FILE"