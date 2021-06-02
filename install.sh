#!/bin/sh

echo -e "\033[32mThis will install AWX and Zabbix\033[0m"

while true; do
    read -p "Do you wish to install Ansible playbooks and plugins too? [y yes / n no]: " yn
    case $yn in
        [Yy]* ) ./add_ansible_playbooks_and_plugins.sh; break;;
        [Nn]* ) break;;
        * ) echo "Please answer y yes or n no.";;
    esac
done

./install_awx.sh
./install_zabbix.sh

echo "----------------------------------------------------------------------------------------------------"
echo -e "Now wait \e[101m10 minutes\e[0m for the migration to complete...."
echo "check the login page at https://localhost"
echo -e "and run \e[101m./add_awx_playbooks.sh\e[0m"
echo "AWX is available on        https://localhost:443"
echo "Zabbix is now available on https://localhost:4443"
echo "pgadmin is available on    http://localhost:7070"
echo "for more info, refer to github site https://github.com/atosorigin/bullsequana-edge-system-management"
echo "----------------------------------------------------------------------------------------------------"
