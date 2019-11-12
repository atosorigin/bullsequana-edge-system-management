# BullSequana Edge Ansible Playbooks and Modules

BullSequana Edge Ansible Playbooks and Modules allows Data Center and IT administrators to use RedHat Ansible or AWX to automate and orchestrate the operations (power, update) of BullSequana Edge.

## Supported Platforms
BullSequana Edge 

## Prerequisites
Ansible playbooks can be used as is with following prerequisites:
  * AWX 4.0+
  * Ansible 2.8.5+
  * Python 3.6.8+

Optionaly, 2 ready-to-go AWX-Ansible images are available on Dockerhub
  * Dockerhub AWX images 
    - [BullSequana Edge Dockerhub AWX web image](https://cloud.docker.com/repository/docker/francinesauvage/mism_awx_web)
    - [BullSequana Edge Dockerhub AWX task image](https://cloud.docker.com/repository/docker/francinesauvage/mism_awx_task)
  * Docker CE
  * Docker compose

## Summary
- [BullSequana Edge Playbooks](#playbooks)
- [What to do first on AWX](#what_awx)
- [What to do first on Ansible](#what_ansible)
- [How to log on a docker container](#howto_docker_logon)
- [How to manage encrypted passwords](#howto_manage_password)
- [How to change my proxy](#howto_proxy)
- [How to change technical states file path](#howto_ts)
- [How to change certificat on AWX server](#howto_cert)
- [How to change AWX passwords](#howto_passwords)
- [Warning for updates](#warning_updates)
- [More help](#more_help)
- [Support](#support)
- [LICENSE](#license)
- [Version](#version)

## <a name="playbooks"></a>BullSequana Edge Playbooks
- `Activate firmware updates`: Activate BullSequana Edge updated firmwares
- `Evaluate firmware update from Technical State`:Evaluate firmware update from Atos specific Technical State file (comparaison)
- `Delete firmware image`: Delete a firmware image by id
- `Firmware inventory` - Active: Get  firmware inventory in "Active" state
- `Firmware inventory - Ready`: Get  firmware inventory in "Ready" state
- `BIOS Boot Mode`: Get current BIOS Boot Mode
- `Set BIOS Boot Mode Regular`: Set BIOS Boot Mode to Regular
- `Set BIOS Boot Mode Safe`: Set BIOS Boot Mode to Safe
- `Set BIOS Boot Mode Setup`: Set BIOS Boot Mode to Setup
- `BIOS Boot Source`: Get current BIOS Boot Source
- `Set BIOS Boot Source Default`: Set BIOS Boot Source to Default
- `Set BIOS Boot Source Disk`: Set BIOS Boot Source to Disk
- `Set BIOS Boot Source Media`: Set BIOS Boot Source to Media
- `Set BIOS Boot Source Network`: Set BIOS Boot Source to Network
- `Update firmware from file`: Update Firmware from a file (tar or gzip file)
- `Update firmwares from Technical State`: Update all Firmwares from technical state (Atos specific TS file)
- `Upload firmware images from Technical State`: Upload images from technical state (Atos specific TS file) - Do NOT activate firmwares (need to be planed after)
- `Check critical high and low alarms`: Check critical high and low alarm states from sensors
- `Check warning high and low alarms`: Check warning high and low alarm states from sensors
- `State BMC`: Get BullSequana Edge current BMC state
- `State Chassis`: Get BullSequana Edge current chassis state 
- `State Host`:Get BullSequana Edge current host state
- `Get FRU`: Get BullSequana Edge FRU information
- `Get Network`: Get BullSequana Edge Network information
- `Get Sensors`: Get BullSequana Edge Sensors information
- `Get System`: Get BullSequana Edge System information
- `Check Rsyslog Server IP and Port`: Compare Rsyslog Server IP and Port to variables defined in inventory
- `Rsyslog Server IP and Port`: Get BullSequana Edge Rsyslog IP and Port
- `Set Rsyslog Server IP`: Set Rsyslog BullSequana Edge IP
- `Set Rsyslog Server Port: `Set Rsyslog BullSequana Edge Port
- `Immediate Shutdown`: Request an Immediate Shutdown
- `Check BMC alive`: Check if BullSequana Edge device is alive
- `Check Power Off`: Check if BullSequana Edge host is powered off
- `Check Power On`: Check if BullSequana Edge host is powered on
- `Get LED state`: Get BullSequana Edge LED state
- `Power Cap`: Get BullSequana Edge Power Cap
- `Orderly Shutdown`: Request an Orderly Shutdown
- `Power On`: Request a Power On
- `Reboot`: Reboot the BullSequana Edge BMC
- `Set LED on/off`: Set BullSequana Edge LED state
- `Set Power Cap on/off`: Set BullSequana Edge Power cap on/off

## <a name="what_AWX"></a>What to do first on AWX

### check proxy configuration

By default, the following proxy environment variables are copied in AWX docker context : 
- HTTP_PROXY
- HTTPS_PROXY
- NO_PROXY

For more details, read the [How to change my Proxy](#howto_proxy)

### launch installer
First clone this repository  

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/git_clone.png)

if you copy this repository, just type:   
```
git clone <paste here>
```

if you zip this repository, just type:   
```
unzip <your_repo_zip>
```

Bull Sequana Edge Ansible Extensions has three AWX installers  
Just choose your favorite installation for your environment  
`<install_dir>/install.sh` it will install Ansible and Zabbix Bull Sequana Edge Extensions at once => use **stop.sh** and **start.sh** after  
`<install_dir>/install_awx.sh` it will build and run docker containers from your local Dockerfile that you can adapt as needed => use **stop_awx.sh** and **start_awx.sh** after  
`<install_dir>/install_awx_from_dockerhub.sh` install dockerhub atosorigin dockerhub images, you cannot adapt the local Dockerfiles but you will inherit image updates => use **stop_awx_from_dockerhub.sh*** and **start_awx_from_dockerhub.sh** after  
For more information about dockehubr installation Visit https://hub.docker.com/repository/docker/atosorigin/bull-sequana-edge-awx-web
 
![#9ECBFF](https://placehold.it/15/9ECBFF/000000?text=+) Best Practice: remove useless install, stop and start scripts

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) Warning: Do not use direct images in production, prefer second method and choose a stable version instead of *latest*

### access your dashboard
run a browser with: ` https://<your_server>`  

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/awx.png)

### add your playbooks
If you did not already add your playbooks, just run:  

`<install_dir>/add_playbooks.sh`

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/awx_playbooks.png)

You should have now:
- 1 Organization : Bull
- 1 Inventory : BullSequana Edge Inventory
- 1 Group : BullSequana Edge Group
- 1 Host as an example
- 1 Project : BullSequana Edge Playbooks
- 1 Credential : Bull Sequana Edge Vault
- Bull playbooks

### complete your inventory first
1. go to Inventory 
2. select or create an inventory
3. add your hosts
4. optionally, depending on host number, create multiple groups

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/awx_inventory.png)

*Don't forget to copy/paste baseuri in every host as is `baseuri: {{inventory_hostname}}`  

Optionally, your can import hosts from ansible: [See how to export ansible inventory hosts file to awx inventory section](#howto_export_inventory)  
Optionally, your can detect hosts with nmap inventory script: [See nmap in Command line section](#howto_nmap)  

### change your inventory variables 
#### - technical_state_path variable
The technical state path should point to a technical state directory - technical iso file delivered by Atos.
The default value is mapped to the /mnt root of the host, in other words, /host/mnt in the docker containers:  
`technical_state_path = /host/mnt`  
You can change this value in the inventory variables:

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/awx_inventory_variables.png)
  
For more information See [How to change technical states file path](#howto_ts)

#### - reboot
Default value is **True**  

Following playbooks need to reboot in case of BMC update firmware:
- Update firmwares from Technical State
- Update firmware from file
- Activate firmware updates

if you never want to automatically reboot the BMC, you need to change *reboot* variable in your inventory / variable part:  
`reboot = False`

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/awx_reboot_variable.png)

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) Warnings if **reboot** = False
- Default is True meaning the BMC will reboot automatically after an update  
- Playbooks needing a **reboot** will not proceed to reboot: BMC update will be effective next reboot   
- *Reboot* playbook does NOT care this variable  

#### - forceoff
Default value is **True**  

Following playbooks need to reboot in case of BMC update firmware:
- Update firmwares from Technical State
- Update firmware from file
- Activate firmware updates

if you never want to automatically force the remote server power off, you need to change **forceoff** variable in your inventory / variable part:

`forceoff = False`

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) Warnings if **forceoff** = False
- Default is **True** meaning the BMC will power off automatically the host (server) during BIOS update   
- Playbooks needing a **forceoff** will not activate BIOS update: BIOS update will be effective next power off / on cycle  
- *Immediate Shutdown* and *Orderly Shutdown* playbooks do NOT care this variable  

#### - power_cap
**power_cap** is used in *Set Power Cap on* playbook

So, the **power_cap** variable is defined localy inside extra_vars section of the playbook

Change the extra_vars section as needed:  
`power_cap: 500`  

Adjust the prompt on launch option as needed, you can unselect it:  
`prompt on launch`

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/set_power_cap_on.png)

By default, the "prompt on launch" option is selected and this is a way to change the value on the fly, a pop-up window will appear at each launch:

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/prompt_launch.png)

#### - file_to_upload
**file_to_upload** is used in *Update firmware from file* playbook

So, the **file_to_upload** variable is defined localy inside extra_vars section of the playbook

Change the extra_vars section as needed:  
` file_to_upload: /host/mnt/Resources/your_image.ext" `  
Adjust the prompt on launch option as needed:  
`prompt on launch`  

#### - countdowns
In your inventory *Variables* section, just change the appropriate countdown variable:

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/awx_variables_inventory_section.png)

#### - rsyslog_server_ip / port
Following playbooks need these variables:
- Check Rsyslog Server IP and Port
- Set Rsyslog Server IP
- Set Rsyslog Server Port
  
### use your credential

#### - change your vault password
The *add_playbooks.sh* script already creates a vault for you and associates every templates to this vault.  

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/create_vault_playbooks.png)

The default *Bull Sequana Edge Vault* has intentionaly NO password, so you should define your own password  

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) Warning : You should remember your vault password  

1. go to AWX Credentials
2. select *Bull Sequana Edge Vault*
3. change the vault password

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/change_vault_password.png)
4. save your change
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/vault_id.png)
  
![#c5f015](https://placehold.it/15/c5f015/000000?text=+) Info: The vault-id can be used in ansible command line  
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/vault_ansible_id.png)

#### - generate your passwords
You can now generate your passwords: See [How to manage encrypted passwords](#howto_manage_password)
You should generate as many *password variables* as different real passwords you have.

#### - use it in your inventory
1. go to AWX Inventory
2. select the host where you need to customize the password
3. add "password:" variable for each host

```
password: "{{root_password_for_edge}}"
```
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/change_encrypted_password.png)

#### check job template credential
You can check the credential of your job template:
1. go to Templates
2. select a job template
3. check the Credential section

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/awx_vault_credential_template.png)

#### check with clear password
For test purpose, you can always use a clear password in a host:
1. go to Inventory
2. select a host
3. change the password in clear

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/awx_clear_password.png)

## <a name="what_ansible"></a>What to do first on Ansible

### what is the content
Bull Sequana Edge Ansible extension contains:
1. Playbooks
2. One Inventory Plugin for nmap detection
3. One Callback Plugin for better CLI stdout UX 

This extension can be installed:
1. locally if you have or you want to have a local Ansible, or inside docker containers => See [install ansible locally](#install_locally)
2. inside a container to have AWX and a docker ansible through container => See [install ansible docker](#install_docker)

### how to install ansible
#### <a name="install_locally"></a>install ansible locally
If you already have an Ansible installation, you can just install ansible playbooks and plugins:  
1. install ansible 
`yum install python3`   
`pip3 install ansible`  

2. edit and customize *install_locally.sh* script
The script basically copies ansible and plugins in default ansible directories  
![#f03c15](https://placehold.it/15/f03c15/000000?text=+) If you change default ansible directories, you should adapt the script target directories as needed
3. run the script `<install_dir>/install_locally.sh`  

Check your ansible python version:  
`ansible --version`  

As explained in the documentation, you should force python3 interpreter:
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/ansible_python3_interpreter.png)

#### <a name="install_docker"></a>Install ansible on docker
Bull Sequana Edge Ansible Extensions has three installers: Just choose your favorite installation for your environment
1. `<install_dir>/install.sh` run all (Ansible and Zabbix Bull Sequana Edge Extensions) => use stop.sh and start.sh after  
2. `<install_dir>/install_awx.sh` build and run from local Dockerfile that you can adapt => use stop_awx.sh and start_awx.sh after  
3. `<install_dir>/install_awx_from_dockerhub.sh` download and run atosorigin dockerhub images => use stop_awx_from_dockerhub.sh and start_awx_from_dockerhub.sh after  

![#9ECBFF](https://placehold.it/15/9ECBFF/000000?text=+) Best Practice: remove useless install, stop and start scripts

### how to change ansible configuration
Here is the basic configuration for ansible:  
config file = <install_dir>/ansible/inventory/ansible.cfg file  
inventory = <install_dir>/ansible/inventory/hosts file  
variables = <install_dir>/ansible/vars/external_vars.yml file  
encrypted passwords = <install_dir>/ansible/vars/passwords.yml file  

![#9ECBFF](https://placehold.it/15/9ECBFF/000000?text=+) With docker installation, for all CLI commands like *ansible* or *ansible-playbook*, you should be logged on a docker awx_web container: [See How to log on a docker container](#howto_docker_logon)

### how to add a host in ansible inventory
1. edit ansible/inventory/hosts file
2. add your ip addresses or hostnames followed by baseuri and username variables
3. generate an encrypted password for your password variable
4. add your password variable for your host

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/host_password.png)

For test purpose, you can always use a clear password in your *hosts* file  
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/ansible_clear_password.png)

### how to change your external variables
1. edit <install_dir>/ansible/vars/external_vars.yml file
2. comment/uncomment/modify your variables

### how to run your playbooks
1. optionaly log on to awx_web docker container
2. go to your playbook directory
3. execute ansible-playbook command with appropriate parameters and desired playbook
  
![#f03c15](https://placehold.it/15/f03c15/000000?text=+) Warning : --vault-id bullsequana_edge_password@<source> is mandatory if you use vault credentials  
*<source can be @prompt to be prompted or any encrypted source file>*
  
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/ansible_playbook_vault_id.png)

### <a name="howto_export_inventory"></a>how to export ansible inventory hosts file to awx inventory
1. optionaly log on to docker awx_web
`docker exec -it awx_web bash`
2. get your targeted inventory id
`tower-cli inventory list`

example: inventory id for 'Ansible Inventory' name is 2  
bash-4.2# tower-cli inventory list  

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/tower_inventory_list.png)  

3. export with awx_manage  
`awx-manage inventory_import --source=inventory/ --inventory-id=3`  

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/awx_manage.png)  

Your hosts should appear as **imported**  
Variables and groups should appear as **imported** too  
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/awx_imported.png)

### general options

General options can always be used with any ansible command as an optional and cumulative parameter

#### how to limit to a group of servers :
```
--limit=<my_group> 
```
*<my_group> should be declared in hosts file*

#### how to specify a BMC password in the CLI on the fly:
```
-e "username=<mon user> password=<mon mot de passe>"
```
#### how to change general variables:
You can refer to Ansible documentation: Visit https://docs.ansible.com/ansible/2.5/user_guide/playbooks_variables.html

To summarize, two main possibilities:
1. As a command parameter, indicate variable/value with --extra-vars as CLI argument :

`ansible-playbook myfile.yml --extra-vars "ma_variable=my_value"`

2. In the appropriated file <install_dir>/vars/external_vars.yml, uncomment and set the desired variable :
`my_variable: my_value `

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) Warning : Care the precedence order  
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/precedence_order.png)
Best site that explain variable orders and conflicts: Visit https://subscription.packtpub.com/book/networking_and_servers/9781787125681/1/ch01lvl1sec13/variable-precedence

### update
#### how to update one image on all BMCs

```
ansible-playbook --extra-vars "file_to_upload=<path_and_filename>" update_firmware_from_file.yml 
```

exemple:  
[root@awx firmware]# ansible-playbook --limit=openbmc --extra-vars "file_to_upload=/mnt/BIOS_SKD080.13.03.003.tar.gz username=root password=mot_de_passe" -vv   update_firmware_from_file.yml  

#### how to evaluate a TS file (Technical State)

```
ansible-playbook evaluate_firmware_update.yml
```

ex: [root@awx firmware]# ansible-playbook --limit=openbmc -vv evaluate_firmware_update.yml

#### how to load images

```yml
ansible-playbook -vv upload_firmwares.yml
```

#### how to update all servers from a TS

```yml
ansible-playbook --limit=openbmc update_firmwares.yml -vv
```

#### how to retrieve firmwares inventory

```yml
ansible-playbook get_firmware_inventory.yml
```

ex: [root@awx firmware]# ansible-playbook --limit=openbmc -vv get_firmware_inventory.yml

#### how to remove an image

```yml
ansible-playbook delete_firmware_image.yml -vv --extra-vars "image=81af6684"
```
ex: [root@awx firmware]# ansible-playbook --limit=openbmc delete_firmware_image.yml -vv --extra-vars "image=81af6684 username=root password=mot_de_passe"

### power

#### how to stop host

```
ansible-playbook power_off.yml
```
ex: [root@awx power]# ansible-playbook --limit=openbmc -e "username=my_user password=my_pass" power_off.yml 

#### how to start host

```yml
ansible-playbook power_on.yml
```
ex: [root@awx power] ansible-playbook --limit=openbmc -e "username=root password=mot_de_passe" power_on.yml

### logs
#### how to configure rsyslog

```yml
ansible-playbook set_rsyslog_server_ip.yml
ansible-playbook set_rsyslog_server_port.yml

```

ex: [root@awx logs]# ansible-playbook set_rsyslog_server_port.yml

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) Warning : default rsyslog IP address is a fake
- rsyslog_server_ip: 0.0.0.0
- rsyslog_server_port: 514

### power capabilities

#### how to limit power capability
in your extra_vars file, just uncomment the appropriate value:
power_cap: 500

### countdowns

#### how to change countdowns 
in your extra_vars file, just change the appropriate value:

```
# Count down before checking a successfull reboot in MINUTES
reboot_countdown: 3
# Count down before checking a successfull for power on/off in SECONDS
poweron_countdown: 15
poweroff_countdown: 15
```

### <a name="howto_nmap"></a>how to use the nmap plugin inventory for redfish 
#### how to detect nmap hosts

`./get_redfish_nmap_hosts.sh`

*you can copy/paste detected hosts in your AWX inventory or your ansible 'hosts' file*

*you should adapt each BMC user/password*

#### how to use it in CLI commands

On each Ansible CLI, add :

`-i /usr/share/ansible/plugins/inventory/redfish_plugin_ansible_inventory.yml`

```
ansible-playbook get_system.yml -i /etc/ansible/redfish_plugin_ansible_inventory.yml
ansible-playbook evaluate_firmware_update.yml -i /etc/ansible/redfish_plugin_ansible_inventory.yml
```

### how to use a CLI Vault
1. generate your encrypted password: See [How to manage encrypted passwords](#howto_manage_password)
2. run your playbook
`ansible-playbook --vault-id root_password@prompt projects/openbmc/inventory/get_sensors.yml`

*@prompt means that you should enter the Vault password during the process (hidden)*

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/ansible_sensors.png)

## <a name="howto_cert"></a>How to change certificat on AWX server

*See https://www.youtube.com/watch?v=Ulrr9knCc_w >>> How to add certificate for AWX login <<<*

1. Stop the server:
`./stop.sh`

2. Go to ssl directory:
`cd <instal_dir>/ansible/awx_ssl`

3. Generate private key (2048):
without passwphrase:
`openssl genrsa -out nginx.key 3072`

*alternatively : it is HIGHLY recommanded to generate your private key with a passphrase you should remember*
with passphrase
`openssl genrsa -out nginx.key -passout stdin 3072`

**This command generates 1 file :**
nginx.key

4. Générer une demande de certificat csr:
`openssl req -sha256 -new -key nginx.key -out nginx.csr -subj '/CN=awx_web.local'`

**This command generates 1 file :**
nginx.csr

5. Générer le certificat crt:
openssl x509 -req -sha256 -days 365 -in nginx.csr -signkey nginx.key -out nginx.crt

**This command generates the certificat :**
nginx.crt

## <a name="howto_passwords"></a>How to change AWX passwords

#### postgres
1. change user and password in ansible.env files
DATABASE_USER=
DATABASE_NAME=
DATABASE_HOST=
DATABASE_PORT=
DATABASE_PASSWORD=
2. change in *credentials.py* 

```
DATABASES = {
    'default': {
        'ATOMIC_REQUESTS': True,
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': "mism",
        'USER': "<here your new postgres user>",
        'PASSWORD': "<here your new postgres password>",
        'HOST': "awx_postgres",
        'PORT': "5432",
    }
}
```

#### rabbitmq
You should first change the user and password from gui
1. Select Admin
2. Choose "Update this user"

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/update_rabbitmq_user.png)

3. change in *credentials.py*

```
BROKER_URL = 'amqp://{}:{}@{}:{}/{}'.format(
    "<here your new rabbitmq user>",
    "<here your new rabbitmq password>",
    "rabbitmq",
    "5672",
    "awx")
```
4. change rabbitmq environment variable in Dockerfiles/ansible.env

RABBITMQ_HOST=rabbitmq  
RABBITMQ_DEFAULT_VHOST=awx  
RABBITMQ_DEFAULT_USER=<here your new rabbitmq user>  
RABBITMQ_DEFAULT_PASS=<here your new rabbitmq password>  

#### how to change awx password : 
1. change user and password from gui
2. change awx and tower environment variable in Dockerfiles/ansible.env

AWX_ADMIN_USER=<here your new awx user>  
AWX_ADMIN_PASSWORD=<here your new awx password>  
TOWER_USERNAME=<here your new tower user>  
TOWER_PASSWORD=<here your new tower password>  

3. change the next environment variable if the certificate is not self-signed
TOWER_VERIFY_SSL=false  
TOWER_INSECURE=true  

## <a name="howto_proxy"></a>How to change my proxy
By default, when you start the installer, the proxy environment variables are copied in containers thanks to the following section in docker-compose-awx.yml file:

```
    environment:
      HTTP_PROXY: ${HTTP_PROXY}
      HTTPS_PROXY: ${HTTPS_PROXY}
      NO_PROXY: ${NO_PROXY}
      ...
```
![#f03c15](https://placehold.it/15/f03c15/000000?text=+) If your bullsequana edge IP address is not declared in proxy: You may need to add your bullsequana edge IP address in your NO_PROXY configuration to bypass the proxy 

```
export NO_PROXY="<your bullsequana edge IP address>,$NO_PROXY"
```

If you don't want to use XX_PROXY environment variables, you can directly adapt the proxy configuration as desired in *docker-compose-awx.yml* file with explicit IP addresses and host names:
```
    environment:
      HTTP_PROXY: http://<your proxy>:<your port>
      HTTPS_PROXY: https://<your proxy>:<your port>
      NO_PROXY: <your bullsequana edge IP address>,127.0.0.1,localhost,zabbix-web,zabbix-server,zabbix-agent,awx_web,awx_task,rabbitmq,postgres,memcached
      ...
```

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) If you change a XXX_PROXY env variable, you should restart the containers :

```
./stop.sh 
./start.sh
```

## <a name="howto_ts"></a>How to change technical states file path
### default value
By default, the root host directory '/' is mapped as a read only access in the docker containers:  
`- /:/host:ro`

So, in your inventory, you can define the `technical_state_path:` variable to whatever you want  
`technical_state_path: /host/mnt`  
`technical_state_path: /host/var`  
`technical_state_path: /host/usr/me`  

### change your technical states file path
For any reason, if you really need to adapt the 'volumes' mapping, follow the instructions:

1. edit docker-compose-awx.yml
2. locate to 'volumes' section of awx_web and awx_task services:
```
  volumes:
    - /mnt:/mnt:ro
```
3. change mapped volumes with whatever you want except:

```
/tmp:/tmp => do NOT map /tmp directory => it change AWX behavior
/:/ => NO sens
```
![#f03c15](https://placehold.it/15/f03c15/000000?text=+) Be careful to change both awx_web and awx_task docker containers and to adapt the technical_state_path variable of your inventory  

`technical_state_path: /mnt`  

*in the previous example: if you change the /mnt of your host, it does NOT change the /mnt of your docker container, so be careful if you change the docker volumes mapping*

### check your technical states file path

If you need to check the directory, just log on to the docker awx_web/awx_task containers and check the file system:  
```
host$> docker exec -it awx_web bash
bash# ls /host/mnt
bash# exit
host$> docker exec -it awx_task bash
bash# ls /host/mnt
```
  
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/check_docker_volume_technical_state.png)

## <a name="howto_docker_logon"></a>How to log on a docker container

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
awx_postgres  
memcached  
rabbitmq   

examples 
```
docker exec -it awx_task bash`
docker exec -it awx_web ansible-playbook projects/openbmc/inventory/get_sensors.yml`
```
## <a name="howto_manage_password"></a>How to manage an encrypted password
### add an encrypted password
1. open a terminal on the host
2. execute the following script with the name of your password and the real password you want to encrypt  
  
`./generate_encrypted_password_for_AWX_Ansible.sh --name your_password_name your_real_password_to_encrypt`  

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/generate_password_result.png)  

*you should indicate your customized vault password during this generation*

### remove an encrypted password
1. edit the file <install_dir>/ansible/playbooks/vars/passwords.yml
2. remove the password entry as desired

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/remove_password.png)

## <a name="warning_updates"></a>Warning for updates
  
![#f03c15](https://placehold.it/15/f03c15/000000?text=+) Never change original playbooks => duplicate playbooks  
  
You can use the directory ansible/playbooks to add your own playbooks.  

## <a name="more_help"></a>More help
Ansible Help is accessible as Ansible Documentation :
#### outside a awx_web docker container
`docker exec -it awx_web ansible-doc -t module atos_openbmc`
#### inside docker containers
`ansible-doc -t inventory --list`

## <a name="support"></a>Support
  * This branch corresponds to the release actively under development.
  * If you want to report any issue, then please report it by creating a new issue [here](https://github.com/atosorigin/bullsequana-edge-system-management/issues)
  * If you have any requirements that is not currently addressed, then please let us know by creating a new issue [here](https://github.com/atosorigin/bullsequana-edge-system-management/issues)

## <a name="license"></a>LICENSE
This project is licensed under GPL-3.0 License. Please see the [COPYING](../COPYING.md) for more information

## <a name="version"></a>Version
BullSequana Edge System MAnagement Tool version 2.0.1
