#!/bin/bash

CMDNAME=`basename $0`

ANSIBLECMD="ansible-vault encrypt_string"
usage()
{
  echo -e "\033[32mUsage: See Options for $ANSIBLECMD\033[0m"
  echo "Example: $CMDNAME --name=name_for_my_password my_secre!_p@ssw0rd "
  echo
  echo "Following is the help for $ANSIBLECMD Options":
  docker exec -it awx_web $ANSIBLECMD --help
  exit -1
}

if [ $# -eq 0 ]
  then
    usage;
fi

echo "Original output"
docker exec -it awx_web $ANSIBLECMD $@ | tee /tmp/fileEncrypt$$

# remove the two first lines and the last 
nbLine=`wc -l /tmp/fileEncrypt$$ | awk '{print$1}'`
s=3
e=$((nbLine - 1))
#sed -n "${s},${e}p" /tmp/fileEncrypt$$ 
# and replace  !vault /__ansible_vault: 
echo "Final output"
sed -n "${s},${e}p" /tmp/fileEncrypt$$ | sed 's/!vault /__ansible_vault: /'

echo "1. copy/paste generated lines to AWX / inventory / host / VARIABLES :"
echo "  username: ..."
echo "  my_root_password:"
echo "      !vault |"
echo "          $ANSIBLE_VAULT;1.1;AES256 ......"
echo
echo -e "2. replace \"\033[31m!vault  |\033[0m\"  with \"\033[32m__ansible_vault: |\033[0m\""
echo "    __ansible_vault:  | "
echo
echo "3. adapt your password variable with your name"
echo "  password: \"{{my_root_password}}\" "
echo

rm -f /tmp/fileEncrypt$$
