#!/bin/bash

CMDNAME=`basename $0`

ANSIBLECMD="ansible-vault encrypt_string --vault-id bullsequana_edge_password@prompt "
usage()
{
  echo -e "\033[32mUsage: See Options for $ANSIBLECMD\033[0m"
  echo "Example: $CMDNAME --name='name_for_my_password' 'my_secre!_p@ssw0rd' "
  echo
  echo "Following is the help for $ANSIBLECMD Options":
  $ANSIBLECMD --help
  exit -1
}

if [ $# -eq 0 ]
  then
    usage;
fi

$ANSIBLECMD $@ | tee /tmp/fileEncrypt$$

nbLine=`wc -l /tmp/fileEncrypt$$ | awk '{print$1}'`
s=3
e=$((nbLine - 1))

if [ $nbLine -le 6 ]
  then
    exit -1
fi

sed -n "${s},${e}p" /tmp/fileEncrypt$$ >> ansible/vars/passwords.yml
rm -f /tmp/fileEncrypt$$

echo "you can now use your variable in your Ansible playbooks"
echo -e "password: \033[31m\"{{your_password_name}}\"\033[0m"

