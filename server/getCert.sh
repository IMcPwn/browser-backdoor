#!/bin/bash
#
# Copyright (c) 2016 IMcPwn  - http://imcpwn.com
# BrowserBackdoorServer by IMcPwn.
# See the file 'LICENSE' for copying permission
#

set -e

echo "Deleting old certbot"
rm -f certbot-auto

echo "Downloading certbot"
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto

printf "Enter the domain for the certificate: "
read -r domain

./certbot-auto certonly --standalone --domain "$domain"

echo "Creating symlinks for privkey.pem and cert.pem"
if [[ -e $(pwd)/privkey.pem || -h $(pwd)/privkey.pem ]]
then
    printf "privkey.pem already exists. Delete? y | n: "
    read -r deletePrivKey
    if [[ $deletePrivKey == "y" ]]
    then
        rm -f "$(pwd)/privkey.pem"
    else
        echo "Quitting"
        exit
    fi
fi
if [[ -e $(pwd)/cert.pem || -h $(pwd)/cert.pem ]]
then
    printf "cert.pem already exists. Delete? y | n: "
    read -r deleteCert
    if [[ $deleteCert == "y" ]]
    then
        rm -f "$(pwd)/cert.pem"
    else
        echo "Quitting"
        exit
    fi
fi
ln -s "/etc/letsencrypt/live/$domain/privkey.pem" "$(pwd)"
ln -s "/etc/letsencrypt/live/$domain/cert.pem" "$(pwd)"
echo "privkey.pem and cert.pem should be in the current directory."
