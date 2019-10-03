#!/bin/bash

ZABBIXCMD="./encrypt_psk_password"

docker exec -it zabbix-server $ZABBIXCMD $@


