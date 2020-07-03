#!/usr/bin/python
import os

ansible_vars = os.getenv("ANSIBLE_EXTERNAL_VARS")
if not ansible_vars:
  print("ANSIBLE_EXTERNAL_VARS environment variable shoud be defined")
  exit(-1)

print("$ANSIBLE_EXTERNAL_VARS is {ansible_vars}".format(ansible_vars=ansible_vars))

if( not os.path.exists(ansible_vars) ):
  f = open(ansible_vars,"a")
  f.close()

external_vars = {a:b for a, b in [i.strip('\n').split(":") for i in open(ansible_vars) if (i.strip()) and (not '#' in i) ] }

f = open(ansible_vars, "a")
if(not external_vars.get('technical_state_path')):
  f.write("# Set a path to a Bull Technical State file\n")
  f.write("technical_state_path: /mnt\n")
if(not external_vars.get('rsyslog_server_ip')):
  f.write("# Define rsyslog ip\n")
  f.write("rsyslog_server_ip:\n")
if(not external_vars.get('purpose_to_delete')):
  f.write("# To delete a ready image : uncomment and fill the Purpose and the Version\n")
  f.write("purpose_to_delete:\n")
if(not external_vars.get('version_to_delete')):
  f.write("version_to_delete:\n")
if(not external_vars.get('file_to_upload')):
  f.write("# File to upload with update_firmware_from_file.yml playbook\n")
  f.write("#file_to_upload: /mnt/Resources/Firmware_and_related_documents/BIOS/<here your file .tar or .gzip>\n")
  f.write("file_to_upload:\n")
if(not external_vars.get('rsyslog_server_port')):
  print("Adding rsyslog_server_port: 514")
  f.write("# rsyslog port (default is 514)\n")
  f.write("rsyslog_server_port: 514\n")
if(not external_vars.get('power_cap')):
  print("Adding default power cap: 500")
  f.write("# Define a power capability\n")
  f.write("power_cap: 500\n")
if(not external_vars.get('forceoff')):
  print("Adding forceoff: False")
  f.write("# Update and Activate playbooks use these variables if needed\n")
  f.write("forceoff: False\n")
if(not external_vars.get('reboot')):
  print("Adding reboot: False")
  f.write("reboot: False\n")
if(not external_vars.get('token_timeout')):
  print("Adding token timeout in SECONDS: 5")
  f.write("# url timeout when creating token\n")
  f.write("token_timeout: 5\n")
if(not external_vars.get('reboot_countdown')):
  print("Adding reboot_countdown: 3 minutes")
  f.write("# Count down before checking a successfull reboot in MINUTES\n")
  f.write("reboot_countdown: 2\n")
if(not external_vars.get('poweron_countdown')):
  print("Adding poweron_countdown: 5 seconds")
  f.write("# Count down before checking a successfull for power on/off in SECONDS\n")
  f.write("poweron_countdown: 5\n")
if(not external_vars.get('poweroff_countdown')):
  print("Adding poweroff_countdown: 5 seconds")
  f.write("# Count down before checking a successfull for power on/off in SECONDS\n")
  f.write("poweroff_countdown: 5\n")
if(not external_vars.get('activating_countdown')):
  print("Adding activating_countdown: 30 seconds")
  f.write("# Count down after activating update in SECONDS\n")
  f.write("activating_countdown: 30\n")
if(not external_vars.get('reboot_maxretries')):
  print("Adding reboot_maxretries: 10 times")
  f.write("# Number of retries while rebooting before failure\n")
  f.write("reboot_maxretries: 10\n")
if(not external_vars.get('poweron_maxretries')):
  print("Adding poweron_maxretries: 10 times")
  f.write("# Number of retries while powering on before failure\n")
  f.write("poweron_maxretries: 10\n")
if(not external_vars.get('poweroff_maxretries')):
  print("Adding poweroff_maxretries: 10 times")
  f.write("# Number of retries while powering off before failure\n")
  f.write("poweroff_maxretries: 10\n")
if(not external_vars.get('activating_maxretries')):
  print("Adding activating_maxretries: 10 times")
  f.write("# Number of retries while activating firmwares before failure\n")
  f.write("activating_maxretries: 10\n")
f.close()
