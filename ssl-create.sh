#!/bin/bash

clear

echo -n "Save the cert files into this directory: "
read -r saveDir
clear

echo -n "Country Name (2 letter code): "
read -r cnf_country
clear

echo -n "State or Province Name (full name): "
read -r cnf_state
clear

echo -n "Locality Name (eg, city) "
read -r cnf_city
clear

echo -n "Organization Name (eg, company) :"
read -r cnf_organization
clear

echo -n "Email Address :"
read -r cnf_email
clear

echo -n "Full Domainname: "
read -r cnf_domain
clear

mkdir -p ./"$saveDir"
mkdir -p ./"$saveDir"/config
cp ./.ssl-shell/create_ssl.cnf ./"$saveDir"/config/"$cnf_domain".cnf
sed -i "/C = */c\C = $cnf_country" ./"$saveDir"/config/"$cnf_domain".cnf
sed -i "/ST = */c\ST = $cnf_state" ./"$saveDir"/config/"$cnf_domain".cnf
sed -i "/L = */c\L = $cnf_city" ./"$saveDir"/config/"$cnf_domain".cnf
sed -i "/O = */c\O = $cnf_organization" ./"$saveDir"/config/"$cnf_domain".cnf
sed -i "/emailAddress = */c\emailAddress = $cnf_email" ./"$saveDir"/config/"$cnf_domain".cnf
sed -i "/CN = */c\CN = $cnf_domain" ./"$saveDir"/config/"$cnf_domain".cnf

echo -n "Create Keys and CRT-File..."
echo ""
openssl req -new -sha256 -nodes \
             -out ./"$saveDir"/"$cnf_domain".csr \
             -newkey rsa:2048 -keyout ./"$saveDir"/"$cnf_domain".key \
             -config ./"$saveDir"/config/"$cnf_domain".cnf

echo -n "Create server certificate..."
echo ""

cp ./.ssl-shell/create_ssl.ext.cnf ./"$saveDir"/config/"$cnf_domain".ext.cnf
sed -i "/DNS.1 = */c\DNS.1 = $cnf_domain" ./"$saveDir"/config/"$cnf_domain".ext.cnf

echo ""
openssl x509 -req -in ./"$saveDir"/"$cnf_domain".csr \
             -CA myRoot.crt -CAkey myRoot.key -CAcreateserial \
             -extfile ./"$saveDir"/config/"$cnf_domain".ext.cnf \
             -out ./"$saveDir"/"$cnf_domain".crt -days 3650 -sha256
echo ""
echo -n "Finished."
