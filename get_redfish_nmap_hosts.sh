#!/bin/bash
#set -x

usage()
{
        USAGE="get_redfish_nmap_hosts.sh [-h]"
        echo 
        echo -e Usage : $USAGE
        echo
        echo "Retrieve nmap redfish-compatible servers (openbmc included)"
        echo "for a IP range declared in the following file:"
        echo "ansible/plugins/inventory/redfish_plugin_ansible_inventory.yml"
        echo
        echo "more info : docker exec -it awx_task ansible-doc -t inventory --list"
        echo
        echo "Options:"
        echo "-h                  show this help message and exit" 
        echo
        exit -1
}

############################
#       MAIN program
############################
####### Get arguments #######
while getopts h option
do
        case $option in
        h) usage;;
        ?) exit -1
        esac
done

docker exec -it awx_web ansible-inventory -i /usr/share/ansible/plugins/inventory/redfish_plugin_ansible_inventory.yml -y  --list

echo
echo "you can add discovered hosts in :"
echo "AWX inventory"
echo "or"
echo "<install_dir>/ansible/inventory/hosts file"
echo "and complete with users and passwords"

