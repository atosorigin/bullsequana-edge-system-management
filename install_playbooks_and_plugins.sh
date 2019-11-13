#!/bin/sh

cp -r ansible/vars/ /etc/ansible/
# uncomment if you want host example
#cp -r ansible/inventory/hosts /etc/ansible/
# comment if you have your own ansible configuration.
cp -r ansible/inventory/ansible.cfg /etc/ansible/

# ansible plugin inventory is copied in default shared directory /usr/share/ansible/plugins/inventory/
# you can adapt it if you have another ansible plugin inventory directory
cp ansible/plugins/inventory/redfish_plugin_ansible_inventory.yml /usr/share/ansible/plugins/inventory/redfish_plugin_ansible_inventory.yml
cp ansible/plugins/inventory/redfish_plugin_ansible_inventory.py  /usr/share/ansible/plugins/inventory//redfish_plugin_ansible_inventory.py

# ansible plugin callback is copied in default shared directory /usr/share/ansible/plugins/callback/
# you can adapt it if you have another ansible plugin callback directory
cp -r ansible/plugins/callback/ansible_stdout_compact_logger      /usr/share/ansible/plugins/callback/ansible_stdout_compact_logger

# ansible plugin module is copied in default shared directory /usr/share/ansible/plugins/modules/
# you can adapt it if you have another ansible plugin module directory
mkdir /usr/share/ansible/plugins/modules/remote_management
mkdir /usr/share/ansible/plugins/modules/remote_management/openbmc
cp ansible/plugins/modules/remote_management/openbmc/atos_openbmc.py       /usr/share/ansible/plugins/modules/remote_management/openbmc/atos_openbmc.py
cp ansible/plugins/modules/remote_management/openbmc/atos_openbmc_utils.py /usr/share/ansible/plugins/modules/remote_management/openbmc/atos_openbmc_utils.py

./add_playbooks.sh
