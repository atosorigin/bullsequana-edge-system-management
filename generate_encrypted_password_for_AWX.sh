#!/bin/bash

CMDNAME=`basename $0`

ANSIBLECMD="ansible-vault encrypt_string --vault-id bullsequana_edge_password@prompt "

usage()
{
  echo -e "\033[32mUsage: See Options for $ANSIBLECMD\033[0m"
  echo "Example: $CMDNAME --name='name_for_my_password' 'my_secre!_p@ssw0rd' "
  echo
  echo "Following is the help for $ANSIBLECMD Options":
  docker exec -it awx_web $ANSIBLECMD --help
  exit -1
}

if [ $# -eq 0 ]
  then
    usage;
fi

# Write generated temporary file
docker exec -it awx_web $ANSIBLECMD $@ | tee /tmp/fileEncrypt$$

# Read generated temporary file
ansible_vault_password=$(cat /tmp/fileEncrypt$$)

# Check insensitive errors
result_error=$(echo "$ansible_vault_password" | grep -i 'error\|not match' )

if [ ! -z "$result_error" ]
then
  if test -f "/tmp/fileEncrypt$$"
  then
    rm -f /tmp/fileEncrypt$$
  fi  
  exit -1
fi

# Check duplicate "!vault" word 
# workaround for space character in password 
result_too_many_vaults=$(echo "$ansible_vault_password" | grep "!vault " | wc -l)

if [ ! "$result_too_many_vaults" -eq 1 ]
then
  echo -e "error in generation : \033[31m\"The password was NOT generated\"\033[0m"
  if test -f "/tmp/fileEncrypt$$"
  then
    rm -f /tmp/fileEncrypt$$
  fi  
  exit -1
fi

# Check regular expression => See https://regex101.com/
result_ansible_vault_password=$(echo "$ansible_vault_password" | grep "^.*: !vault \|[\n ]*\$ANSIBLE_VAULT;1\.2;AES256;bullsequana_edge_password([\na-fA-F0-9 ]*)*")

if [ -z "$result_ansible_vault_password" ]
then
  echo -e "error in generation : \033[31m\"The password was NOT generated\"\033[0m"
else
  # Write encrypted string in passwords.yml
  sed '/^New vault password (bullsequana_edge_password):\|^Confirm new vault password (bullsequana_edge_password):\|^Encryption successful/d' /tmp/fileEncrypt$$ >> ./ansible/vars/passwords.yml
  # extract variable name to help user
  name_variable=$(echo "$result_ansible_vault_password" | awk -F: '{print$1}')
  echo "you can now use your variable in your Ansible inventory"
  echo -e "go to Inventory, select your host(s) and add \033[32m\"password: {{ $name_variable }}\"\033[0m in extra vars section"
fi

if test -f "/tmp/fileEncrypt$$"
then
  rm -f /tmp/fileEncrypt$$
fi

