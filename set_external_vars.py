#!/usr/bin/python
import os

ansible_vars = os.getenv("ANSIBLE_EXTERNAL_VARS")
if not ansible_vars:
  print("ANSIBLE_EXTERNAL_VARS environment variable shoud be defined")
  exit(-1)

print("$ANSIBLE_EXTERNAL_VARS is {ansible_vars}".format(ansible_vars=ansible_vars))

if( not os.path.exists(ansible_vars) ):
  f = open(ansible_vars,"a")
  print("Adding commented external vars => You should uncomment and complete it after install")
  f.write("# Set a path to a Bull Technical State file\n")
  f.write("#technical_state_path: /mnt\n")
  f.write("# Define rsyslog ip and port\n")
  f.write("#rsyslog_server_ip: <here rsyslog ip address>\n")
  f.write("# Define a power capability\n")
  f.write("#power_cap: 500\n")
  f.write("# File to upload with update_firmware_from_file.yml playbook\n")
  f.write("#file_to_upload: /mnt/Resources/Firmware_and_related_documents/BIOS/<here your file .tar or .gzip>\n")
  f.write("# To delete a ready image : uncomment and fill the Purpose and the Version\n")
  f.write("#purpose_to_delete: BMC\n")
  f.write("#version_to_delete: 00.00.0000\n")
  f.close()

external_vars = {a:b for a, b in [i.strip('\n').split(":") for i in open(ansible_vars) if (i.strip()) and (not '#' in i) ] }

f = open(ansible_vars, "a")
if(not external_vars.get('forceoff')):
  print("Adding forceoff: False")
  f.write("# Update and Activate playbooks use these variables if needed\n")
  f.write("forceoff: False\n")
if(not external_vars.get('reboot')):
  print("Adding reboot: False")
  f.write("reboot: False\n")
if(not external_vars.get('reboot_countdown')):
  print("Adding reboot_countdown: 3 minutes")
  f.write("# Count down before checking a successfull reboot in MINUTES\n")
  f.write("reboot_countdown: 3\n")
if(not external_vars.get('poweron_countdown')):
  print("Adding poweron_countdown: 15 seconds")
  f.write("# Count down before checking a successfull for power on/off in SECONDS\n")
  f.write("poweron_countdown: 15\n")
if(not external_vars.get('poweroff_countdown')):
  print("Adding poweroff_countdown: 15 seconds")
  f.write("# Count down before checking a successfull for power on/off in SECONDS\n")
  f.write("poweroff_countdown: 15\n")
if(not external_vars.get('activating_countdown')):
  print("Adding activating_countdown: 180 seconds")
  f.write("# Count down after activating update in SECONDS\n")
  f.write("activating_countdown: 180\n")
if(not external_vars.get('rsyslog_server_port')):
  print("Adding rsyslog_server_port: 514")
  f.write("# rsyslog port (default is 514)\n")
  f.write("rsyslog_server_port: 514\n")
f.close()
