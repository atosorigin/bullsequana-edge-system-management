#!/bin/bash

docker exec -it zabbix-agent openssl rand -hex 32 | tee zabbix/agent/zabbix_agentd.psk

zabbix_psk=$(cat zabbix/agent/zabbix_agentd.psk)

sed -i 's/#.*TLSConnect.*=.*psk.*/TLSConnect=psk/g' zabbix/agent/zabbix_agentd.conf
sed -i 's/#.*TLSAccept.*=.*psk.*/TLSAccept=psk/g'   zabbix/agent/zabbix_agentd.conf
sed -i 's/#.*TLSPSKIdentity.*=.*/TLSPSKIdentity=PSK_Mipocket_Agent/g' zabbix/agent/zabbix_agentd.conf
sed -i 's/#.*TLSPSKFile.*=.*/TLSPSKFile=\/etc\/zabbix\/zabbix_agentd.psk/g' zabbix/agent/zabbix_agentd.conf

echo "Steps to activate Encryption"
echo "1. Got to Zabbix / Configuration / Hosts / selected_host / Encryption"
echo "2. Select:"
echo -e "- Connections to host : <select \033[32mPSK\033[0m>"
echo -e "- Connections from host : <select \033[32mPSK\033[0m>"
echo -e "\033[32m- PSK Identity: PSK_Mipocket_Agent\033[0m"
echo -e "\033[32m- PSK:$zabbix_psk\033[0m"
echo -e "\033[31m!!WARNING: You should repeat these steps for zabbix-server itself and ALL your hosts\033[0m"
echo
echo "This psk is available in <install_dir>/zabbix/agent/zabbix_agentd.psk file"
echo "This psk can be used to generate your encrypted passwords"
echo "---------------------------------------------------------------------------------------------------------"
echo "After Zabbix configuration, for each password you need to encrypt, you should run"
echo "./generate_encrypted_password_for_zabbix.sh"
echo "---------------------------------------------------------------------------------------------------------"
echo
echo -e "\033[31m!!WARNING: if you change this psk or if you re-run this script => you should regenerate ALL passwords!!\033[0m"




