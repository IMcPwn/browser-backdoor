#!/bin/bash
#
# Copyright (c) 2016 Carleton Stuberg - http://imcpwn.com
# BrowserBackdoorServer by IMcPwn.
# See the file 'LICENSE' for copying permission
#

set -e

echo "Deleting old certbot"
rm -f certbot-auto

echo "Downloading certbot"
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto

printf "Enter the domain for the certificate (getCert.sh only supports one domain per use): "
read -r domain

./certbot-auto certonly --standalone --domain "$domain"

echo "Creating symlinks for privkey.pem and fullchain.pem"
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
if [[ -e $(pwd)/fullchain.pem || -h $(pwd)/fullchain.pem ]]
then
    printf "fullchain.pem already exists. Delete? y | n: "
    read -r deleteCert
    if [[ $deleteCert == "y" ]]
    then
        rm -f "$(pwd)/fullchain.pem"
    else
        echo "Quitting"
        exit
    fi
fi
ln -s "/etc/letsencrypt/live/$domain/privkey.pem" "$(pwd)"
ln -s "/etc/letsencrypt/live/$domain/fullchain.pem" "$(pwd)"
echo "privkey.pem and fullchain.pem should be in the current directory."
