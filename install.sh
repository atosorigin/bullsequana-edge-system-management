#!/bin/sh

echo -e "\033[32mThis will install AWX and Zabbix\033[0m"

while true; do
    read -p "Do you wish to install Ansible playbooks and plugins too: [yn yes no] " yn
    case $yn in
        [Yy]* ) ./add_ansible_playbooks_and_plugins.sh; break;;
        [Nn]* ) break;;
        * ) echo "Please answer y yes or n no.";;
    esac
done

./install_awx.sh
./install_zabbix.sh

echo -e "\033[32mYou can now remove safely your old tar and tar.gz file\033[0m"

