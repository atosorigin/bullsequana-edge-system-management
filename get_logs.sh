#!/bin/sh

#set -x

usage()
{
        USAGE="get_logs.sh [-h]"
        echo 
        echo -e Usage : $USAGE
        echo 
        echo "Get logs from hosts declared in hosts file" 
        echo -e "\033[0;31m Careful : You should fill your host in file <installation_dir>\ansible\inventory\host \033[0m"
        exit -1
}

############################
#       MAIN program
############################
####### Get arguments #######
while getopts hn:p: option
do
        case $option in
        h) usage;;
        ?) echo "No arguments is necessary, just complete your hosts file in <installation_dir>\ansible\inventory\hosts"
        esac
done

docker exec -it awx_web ansible-playbook projects/openbmc/logs/get_logs.yml



