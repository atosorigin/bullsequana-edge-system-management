Warning for updates
=================== 
<span style="color:red">Never change original playbooks => duplicate playbooks

You can use the directory ansible/playbooks/openbmc to add your own playbooks.

What to do first on AWX
=========================
## Add your playbooks
If you did NOT already add your playbooks, just run :
`<instal_dir>/add_playbooks.sh

## Complete your inventory first
Go to inventory and add all your hosts manually
Optionally, your can detect hosts with nmap inventory script: See nmap in Command line section

`cd <instal_dir>/ansible/awx_ssl

*Don't forget to copy/paste baseuri in every host unmodified*
`baseuri: {{inventory_hostname}} 

## Create your vault
1. Go to AWX Credentials
```
Create a new Vault (+ button at the right)
type = Vault
no optional identifier
remember your password
```
2. Generate a password
```
./generate_encrypted_password_for_AWX.sh -name my_variable_name my_password_to_encrypt
```
*you should indicate your AWX Vault password during this generation*

3. Follow the instruction steps of the script

4. Adapt your password variable
```
password: {{my_password_to_encrypt}}
```
5. In all templates, you should now indicate the Credential you want before running it

## Change your inventory variables 
if you never want to automatically reboot the BMC, you need to change reboot = False variable in your inventory / variable part (Default is True)
if you never want to automatically force the remote server power off, you need to change force_off = False variable in your inventory / variable part (Default is True)
*Be careful
*playbooks needing a reboot or forceoff will fail*
*reboot and shutdown playbooks do NOT care these variables*

What to do first on Ansible CLI
===============================
Here is the basic configuration for ansible:
config file = ansible/inventory/ansible.cfg file
inventory = ansible/inventory/hosts file
variables = ansible/vars file

*For every CLI commands, you should be logged on a docker AWX container like awx_web or awx_task or add 'docker exec -it <container name>' before all commands*

## General Options
### To limit to a group of servers :
```
--limit=<my_group> 
```
*my_group should be declared in hosts file*

### To specify a BMC password in the CLI  :
```
-e "username=<mon user> password=<mon mot de passe>"
```

### To change general variables:
2 possibilities :
1. As a command parameter, indicate variable/value with --extra-vars as CLI argument :

`ansible-playbook myfile.yml --extra-vars "ma_variable=my_value"

2. In the appropriated file playbooks/vars/external_vars.yml, uncomment and set the desired variable :
`my_variable: my_value 

<span style="color:red">Warning : the 2 different ways are exclusive : You should declare a same variable in file OR in parameter, else it will conflict</span>

## Update
### To update one image on all BMCs

```yml
ansible-playbook --extra-vars "file_to_upload=<path_and_filename>" update_firmware_from_file.yml 
```

exemple: 
[root@awx firmware]# ansible-playbook --limit=openbmc --extra-vars "file_to_upload=/mnt/BIOS_SKD080.13.03.003.tar.gz username=root password=mot_de_passe" -vv update_firmware_from_file.yml

### to evaluate a TS file (Technical State)

```yml
ansible-playbook evaluate_firmware_update.yml
```

exemple
[root@awx firmware]# ansible-playbook --limit=openbmc -vv evaluate_firmware_update.yml

### To load images

```yml
ansible-playbook -vv upload_firmwares.yml
```

### To update all servers from a TS

```yml
ansible-playbook --limit=openbmc update_firmwares.yml -vv
```

### To retrieve firmwares inventory

```yml
ansible-playbook get_firmware_inventory.yml
```

example: 
[root@awx firmware]# ansible-playbook --limit=openbmc -vv get_firmware_inventory.yml

### To remove an image

```yml
ansible-playbook delete_firmware_image.yml -vv --extra-vars "image=81af6684"
```

exemple:
[root@awx firmware]# ansible-playbook --limit=openbmc delete_firmware_image.yml -vv --extra-vars "image=81af6684 username=root password=mot_de_passe"

### To force stop
```
forceoff: True
```
### To reboot the bmc
```
reboot: False
```

### To change ts path on docker
```
technical_state_path: '/host/mnt'
```

## Power

### To stop host

```
ansible-playbook power_off.yml
example:
[root@awx power]# ansible-playbook --limit=openbmc -e "username=my_user password=my_pass" power_off.yml 
```
### To start host

```yml
ansible-playbook power_on.yml
example:
[root@awx power] ansible-playbook --limit=openbmc -e "username=root password=mot_de_passe" power_on.yml
```

## Logs
### To configure rsyslog

```yml
ansible-playbook set_rsyslog_server_ip.yml
ansible-playbook set_rsyslog_server_port.yml
exemple:
[root@awx logs]# ansible-playbook set_rsyslog_server_port.yml
```
*WARNING : default rsyslog IP address is a fake*
rsyslog_server_ip: 0.0.0.0
*rsyslog port*
rsyslog_server_port: 514

## Power capabilities

### To limit "power cap"
power_cap: 3000

## To use the nmap plugin inventory for redfish
### to detect nmap hosts
`./get_redfish_nmap_hosts.sh

*you can copy/paste detected hosts in your AWX inventory or your ansible 'hosts' file*
*you should adapt each BMC user/password*

### top use it in CLI commands

On each Ansible CLI, add :
`-i /usr/share/ansible/plugins/inventory/redfish_plugin_ansible_inventory.yml

example:
ansible-playbook get_system.yml -i /etc/ansible/redfish_plugin_ansible_inventory.yml
ansible-playbook evaluate_firmware_update.yml -i /etc/ansible/redfish_plugin_ansible_inventory.yml


## to use a CLI Vault
1. Create your encrypted password

```
ansible-vault encrypt_string --name=my_root_password sdd@atos

root_password: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          61653761383061633134313137633731613461333164343831376666376466646239386337303130
          6136623166396136663736306337333230646533356337390a633734396235623838396266383230
          63643431316534303232316161323664386539323231323063356431346435366631333532663039
          6166623036356263330a303237613366623861366437666631346134663262313431643036663163
          3730
```
2. Copy/Paste it in ansible/playbooks/vars/passwords.yml file

3. Add the following lines to your own playbooks (do NOT change the originals) near the "vars:" section :

```
  vars_files:
    - /var/lib/awx/projects/vars/passwords.yml
```
4. run your playbook
ansible-playbook --vault-id root_password@prompt projects/openbmc/inventory/get_sensors.yml

*@prompt means that you should enter the Vault password during the process (hidden)*

How to change certificat on AWX server :
========================================
*See https://www.youtube.com/watch?v=Ulrr9knCc_w >>> How to add certificate for AWX login <<<*

### 1. Stop the server:
`./stop.sh

### 2. Go to ssl directory:
`cd <instal_dir>/ansible/awx_ssl

### 3. Generate private key (2048):
without passwphrase:
`openssl genrsa -out nginx.key 3072

*alternatively : it is HIGHLY recommanded to generate your private key with a passphrase you should remember*
with passphrase
`openssl genrsa -out nginx.key -passout stdin 3072

**This command generates 1 file :**
nginx.key

### 4. Générer une demande de certificat csr:
`openssl req -sha256 -new -key nginx.key -out nginx.csr -subj '/CN=awx_web.local'

**This command generates 1 file :**
nginx.csr

### 5. Générer le certificat crt:
openssl x509 -req -sha256 -days 365 -in nginx.csr -signkey nginx.key -out nginx.crt

**This command generates the certificat :**
nginx.crt

How to change passwords:
========================
### awx rabbitmq postgres
user=mism
password=mismpass

## awx : 
1. change= user and password from gui
2. change tower environment variable for next add_playbook.sh to execute correctly

## rabbitmq : follow the above procedure
1. Change user/password from rabbimq web interface (gui)
2. Log on to docker awx_web container and change the password
```
docker exec -it awx_task bash
cd /etc/tower/conf.d/
nano credentials.py
==> change the BROKER_URL user and password (first and second amqp parameters)
nano environment.sh
==> change the RABBITMQ_DEFAULT_USER and RABBITMQ_DEFAULT_PASS as needed
==> change the folowwing env variables :
export TOWER_USERNAME=<your new user>
export TOWER_PASSWORD=<your new password>

```
the 'export' step is only necessary on awx_web container as tower_cli is NOT installed on awx_task
3. Iterate the same for awx_web container

How to declare my proxy :
=========================
# proxy
if you have a proxy, add the following environment variables in docker-compose-mism.yml file :
awx_task:
```
  environment:
    http_proxy: http://<your proxy>:<your port>
    https_proxy: https://<your proxy>:<your port>
    no_proxy: 127.0.0.1,localhost,zabbix-web,zabbix-server,zabbix-agent,awx_web,awx_task,rabbitmq,postgres,memcached,<your IP address>

awx_web:
...
  environment:
    http_proxy: http://<your proxy>:<your port>
    https_proxy: https://<your proxy>:<your port>
    no_proxy: 127.0.0.1,localhost,zabbix-web,zabbix-server,zabbix-agent,awx_web,awx_task,rabbitmq,postgres,memcached,<your IP address>

```
How to change technical states file path :
==========================================
By default, the root host / is mapped as a read online access inside the docker container :
    - /:/host:ro

You can adapt the 'volumes' mapping:

1. Edit docker-compose-mism.yml
2. Go to section 'volumes' in both awx_web et awx_task service :
```
  volumes:
    - /:/host:ro
```
3. Change mapped volumes with whatever you want except :
/tmp:/tmp => change AWX behavior
/:/ => dangerous because container will be able to change host files

!! Be careful to change both awx_web and awx_task docker containers !!

How to log on a docker container :
==================================
To log on a container with an interactive terminal:

```
docker exec -it <container name> <executable command or shell>
where:
-i = interactive
-t = terminal
<container name> is awx_web or awx_task : both can be use to use ansible CLI
<executable command or shell> 
  shell : could be bash or sh
  command : any ansible command
```
container names are :
awx_web
awx_task
postgres
memcached
rabbitmq
zabbix
zabbix-agent
zabbix-web

examples :
docker exec -it awx_task bash
docker exec -it awx_web ansible-playbook projects/openbmc/inventory/get_sensors.yml

More help
=========
Ansible Help is accessible as Ansible Documentation :
#### outside a awx_web docker container
`docker exec -it awx_web ansible-doc -t module atos_openbmc
#### inside docker containers
ansible-doc -t inventory --list

Version:
========
MISM version 2.0.1
