#!/bin/bash

echo -n Please enter the password you want to encrypt: 
read -s password

echo

ZABBIXCMD="./encrypt_psk_password"

docker exec -it zabbix-server $ZABBIXCMD --password=$password


