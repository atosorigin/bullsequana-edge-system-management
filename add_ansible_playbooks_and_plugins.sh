#!/bin/sh

###################################################################################################################
# ansible prerequisite
###################################################################################################################
echo "checking ansible prerequisite"
ansible_version=$(ansible --version|grep "ansible python module location")
if [ -z "$ansible_version" ]
then
  echo -e "\033[31mansible is NOT installed\033[0m"
  exit -1
fi

###################################################################################################################
# ansible.config
###################################################################################################################
if [ -z $ANSIBLE_CONFIG ]
then
  export ANSIBLE_CONFIG=/etc/ansible/ansible.cfg
fi
echo "your ansible configuration file is $ANSIBLE_CONFIG"

if [ -z $ANSIBLE_INVENTORY ]
then
  export ANSIBLE_INVENTORY=/etc/ansible/hosts #default
fi
echo "your ansible inventory hosts file is $ANSIBLE_INVENTORY"

add_lines()
{
  echo -e "\033[32m---------------------------------------------------------------------------------------\033[0m"
  echo -e "\033[31mPlease change yourself the following configuration in your $ANSIBLE_CONFIG:\033[0m"
  echo "# MANDATORY: for atos module plugin to work, uncomment line at the begining of the file:"
  echo -e "\033[31mlibrary = /usr/share/ansible/plugins/modules\033[0m"
  echo "# MANDATORY: for atos module utils to work, uncomment line at the begining of the file:"
  echo -e "\033[31mmodule_utils = /usr/share/ansible/plugins/module_utils\033[0m"
  echo "# OPTION for a better Atos sensors / log / yaml rendering"
  echo -e "stdout_callback = \033[32mmismunixy\033[0m"
  echo "# OPTION if you wish a more human-readable rendering"
  echo "See https://docs.ansible.com/ansible/2.5/plugins/callback.html#managing-adhoc"
  echo -e "bin_ansible_callbacks = \033[32mTrue\033[0m"
  echo "# to enable Atos python3 playbboks"
  echo -e "ansible_python_interpreter = \033[32m/usr/bin/python3\033[0m"
  echo "# if target certificates are self-signed"
  echo "host_key_checking = False"
  echo -e "\033[32m----------------------------------------------------------------------------------------\033[0m"
}

while true; do
    read -p "Do you wish to overwrite your $ANSIBLE_CONFIG file ? y yes / n no: " yn
    case $yn in
        [Yy]* ) cp ansible/inventory/ansible.cfg $ANSIBLE_CONFIG ; break;;
        [Nn]* ) add_lines; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

###################################################################################################################
# passwords.yml
###################################################################################################################

# add ANSIBLE_PASSWORDS=<your install dir>/ansible/vars/passwords.yml to hosts file
# add ANSIBLE_EXTERNAL_VARS=<your install dir>/ansible/vars/external_vars.yml to hosts file
pwd=$(pwd)
export ANSIBLE_PASSWORDS=$pwd/ansible/vars/passwords.yml
export ANSIBLE_EXTERNAL_VARS=$pwd/ansible/vars/external_vars.yml

if [ ! -f $ANSIBLE_PASSWORDS ] 
then
  touch $ANSIBLE_PASSWORDS
  echo -e "\033[32m$ANSIBLE_PASSWORDS was successfully created\033[0m"
fi

# delete old ANSIBLE_PASSWORDS path
grep -q ANSIBLE_PASSWORDS= $ANSIBLE_INVENTORY && sed -i.bak '/ANSIBLE_PASSWORDS=.*/d' $ANSIBLE_INVENTORY
# add the new ANSIBLE_PASSWORDS path
sed -i "/all:vars/a ANSIBLE_PASSWORDS=$ANSIBLE_PASSWORDS" $ANSIBLE_INVENTORY
echo "The following line was added in your $ANSIBLE_INVENTORY:"
echo -e "\033[32mANSIBLE_PASSWORDS=$ANSIBLE_PASSWORDS\033[0m"
echo -e "your passwords.yml file is now $ANSIBLE_PASSWORDS"
echo -e "you should copy your passwords in $ANSIBLE_PASSWORDS"
echo -e "\033[32m----------------------------------------------------------------------------------------\033[0m"

###################################################################################################################
# external_vars.yml
###################################################################################################################
add_external_vars()
{
  echo "# Update and Activate playbooks use these variables if needed" > $ANSIBLE_EXTERNAL_VARS
  echo "forceoff: False" >> $ANSIBLE_EXTERNAL_VARS
  echo "reboot: False" >> $ANSIBLE_EXTERNAL_VARS
  echo "# Count down before checking a successfull reboot in MINUTES" >> $ANSIBLE_EXTERNAL_VARS
  echo "reboot_countdown: 3" >> $ANSIBLE_EXTERNAL_VARS
  echo "# Count down before checking a successfull for power on/off in SECONDS" >> $ANSIBLE_EXTERNAL_VARS
  echo "poweron_countdown: 15" >> $ANSIBLE_EXTERNAL_VARS
  echo "poweroff_countdown: 15" >> $ANSIBLE_EXTERNAL_VARS
  echo "# Set a path to a Bull Technical State file" >> $ANSIBLE_EXTERNAL_VARS
  echo "# uncomment for CLI Ansible ONLY (for AWX, please use the external vars in the graphical AWX inventory externale vars) " >> $ANSIBLE_EXTERNAL_VARS
  echo "# technical_state_path: /mnt" >> $ANSIBLE_EXTERNAL_VARS
  echo "# Define rsyslog ip and port" >> $ANSIBLE_EXTERNAL_VARS
  echo "# default rsyslog port is 514" >> $ANSIBLE_EXTERNAL_VARS
  echo "#rsyslog_server_ip: <here rsyslog ip address>" >> $ANSIBLE_EXTERNAL_VARS
  echo "rsyslog_server_port: 514" >> $ANSIBLE_EXTERNAL_VARS
  echo "# Define a power capability" >> $ANSIBLE_EXTERNAL_VARS
  echo "#power_cap: 500" >> $ANSIBLE_EXTERNAL_VARS
  echo "# File to upload with update_firmware_from_file.yml playbook" >> $ANSIBLE_EXTERNAL_VARS
  echo "#file_to_upload: /mnt/Resources/Firmware_and_related_documents/BIOS/<here your file .tar or .gzip>" >> $ANSIBLE_EXTERNAL_VARS
  echo "# To delete a ready image : uncomment and fill the Purpose and the Version" >> $ANSIBLE_EXTERNAL_VARS
  echo "#purpose_to_delete: BMC" >> $ANSIBLE_EXTERNAL_VARS
  echo "#version_to_delete: 00.00.0000" >> $ANSIBLE_EXTERNAL_VARS
}

if [ ! -f $ANSIBLE_EXTERNAL_VARS ] 
then
  touch $ANSIBLE_EXTERNAL_VARS
  add_external_vars
  echo -e "\033[32ma$ANSIBLE_EXTERNAL_VARS was successfully created\033[0m"
fi

# delete old ANSIBLE_EXTERNAL_VARS path
grep -q ANSIBLE_EXTERNAL_VARS= $ANSIBLE_INVENTORY && sed -i.bak '/ANSIBLE_EXTERNAL_VARS=.*/d' $ANSIBLE_INVENTORY
# add the new ANSIBLE_EXTERNAL_VARS path
sed -i "/all:vars/a ANSIBLE_EXTERNAL_VARS=$ANSIBLE_EXTERNAL_VARS" $ANSIBLE_INVENTORY
echo "The following line was added in your $ANSIBLE_INVENTORY :"
echo -e "\033[32mANSIBLE_EXTERNAL_VARS=$ANSIBLE_EXTERNAL_VARS\033[0m"
echo -e "your external_vars.yml file is now $ANSIBLE_EXTERNAL_VARS"
echo -e "you should edit your var preferences in $ANSIBLE_EXTERNAL_VARS"
echo -e "\033[32m----------------------------------------------------------------------------------------\033[0m"

# ansible plugin inventory is copied in default directory /usr/lib/python<major>.<minor>/site-packages/ansible/modules
# you can adapt it if you have another ansible plugin inventory directory

# ansible plugin module is copied in default shared directory /usr/share/ansible/plugins/modules/
# you can adapt it if you have another ansible plugin module directory


if [ ! -d "/usr/share/ansible/plugins/callback/ansible_stdout_compact_logger" ]
then
  mkdir -p /usr/share/ansible/plugins/callback/ansible_stdout_compact_logger
fi

cp -r ansible/plugins/callback/ansible_stdout_compact_logger/mismunixy.py /usr/share/ansible/plugins/callback/ansible_stdout_compact_logger/mismunixy.py


if [ ! -d "/usr/share/ansible/plugins/modules" ]
then
  mkdir -p /usr/share/ansible/plugins/modules
fi

if [ ! -d "/usr/share/ansible/plugins/module_utils" ]
then
  mkdir -p /usr/share/ansible/plugins/module_utils
fi

cp ansible/plugins/modules/remote_management/openbmc/atos_openbmc.py        /usr/share/ansible/plugins/modules/atos_openbmc.py
cp ansible/plugins/modules/remote_management/openbmc/atos_openbmc_utils.py  /usr/share/ansible/plugins/module_utils/atos_openbmc_utils.py
cp ansible/plugins/modules/remote_management/openbmc/__init__.py            /usr/share/ansible/plugins/modules/__init__.py

# previous install issue
if [ -d "/usr/share/ansible/plugins/callback/ansible_stdout_compact_logger/ansible_stdout_compact_logger" ]
then
  rm -rf /usr/share/ansible/plugins/callback/ansible_stdout_compact_logger/ansible_stdout_compact_logger
fi

if [ -d "/usr/share/ansible/plugins/callback/ansible_stdout_compact_logger/callback" ]
then
  rm -rf /usr/share/ansible/plugins/callback/ansible_stdout_compact_logger/callback
fi
