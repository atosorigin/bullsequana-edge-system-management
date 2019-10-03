#!/bin/bash

docker exec -it zabbix-agent openssl rand -hex 32 > zabbix/agent/zabbix_agentd.psk

echo "1. edit <install_dir>/zabbix/agent/zabbix_agentd.conf"
echo "2. locate the section:"
echo "####### TLS-RELATED PARAMETERS #######"
echo "3. uncomment:"
echo "TLSConnect=psk"
echo "TLSAccept=psk"
echo "TLSPSKIdentity=PSK_Mipocket_Agent"
echo "TLSPSKFile=/etc/zabbix/zabbix_agentd.psk"
echo "4. in zabbix / Configuration / Hosts / your host / Encryption"
echo "Connections to host : <select PSK>"
echo "Connections from host : <select PSK>"
echo "PSK Identity: PSK_Mipocket_Agent"
echo "PSK:"
docker exec -it zabbix-agent cat /etc/zabbix/zabbix_agentd.psk
echo
echo "this psk has been added in your <install_dir>/zabbix/agent/zabbix_agentd.psk file"
echo "this psk will now used to generate your encrypted passwords"
echo
echo "5. for each password you should run"
echo "./generate_encrypted_password_for_zabbix.sh --passord=<your_password>"
echo
echo -e "\033[31m!!WARNING : if you change this psk or re-run this script, you should change all generated passwords!!\033[0m"
echo



