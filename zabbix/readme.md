# BullSequana Edge Zabbix Templates

BullSequana Edge Zabbix Templates allows Data Center and IT administrators to use zabbix to monitor BullSequana Edge devices.

## Supported Platforms
BullSequana Edge

## Prerequisites
From zabbix directly :
  * Zabbix >= 4.2
  * Python >= 2.7.5

Optionally, 3 ready-to-go zabbix images are available on Dockerhub
  * Dockerhub Zabbix images 
    - [BullSequana Edge Dockerhub Zabbix server image](https://cloud.docker.com/repository/docker/francinesauvage/mism_zabbix_server)
    - [BullSequana Edge Dockerhub Zabbix web image](https://cloud.docker.com/repository/docker/francinesauvage/mism_zabbix_web)
    - [BullSequana Edge Dockerhub Zabbix agent image](https://cloud.docker.com/repository/docker/francinesauvage/mism_zabbix_agent)
  * Docker CE
  * Docker compose

## Summary
- [BullSequana Edge Zabbix Templates](#templates)
- [What to do first](#what_first)
- [How to install BullSequana Edge template](#edge_template)
- [How to install rsyslog template](#rsyslog_template)
- [Network Proxy](#proxy)
- [Security](#security)
- [Tests](#tests)
- [Warning for udates](#updates)
- [Support](#support)
- [LICENSE](#license)
- [Version](#version)

## <a name="what_first"></a>What to do first

### Change environment variables for Proxy

All default environment variables are declared in Dockerfiles/zabbix.env file.

By default, the following XXX_PROXY environment variables are copied in zabbix context : HTTP_PROXY, HTTPS_PROXY, NO_PROXY

To change it, open a terminal and change your XXX_PROXY environement variables:

export HTTP_PROXY="http://<proxy_ip>:<proxy_port>"

export HTTPS_PROXY="http://<proxy_ip>:<proxy_port>"

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) if you have a proxy between the server and the BMC or if ever you have proxy issues, try to add as many *<bullsequana_edge_ip_address>* as device instances you have in NO_PROXY environment variable :

export NO_PROXY="127.0.0.1,localhost,zabbix,webserver,0.0.0.0:9090,0.0.0.0,ansible,awx,awx_web,awx_task,*<bullsequana_edge_ip_address>*"

You can now run the installer.

### Launch installer
Run the install script:

`./install_zabbix.sh`

or if you want to use the Docker Atos images, you can now run the following Dockerhub install script:

`./install_zabbix_from_dockerhub.sh`

### enable automatic inventory by default
1. Go to Administration / General
2. Select you Zabbix server host

![alt text](https://github.com/frsauvage/MISM/blob/master/zabbix/doc/Zabbix_Server_Configuration.png)

### rename Zabbix Server
1. Go to Configuration / Hosts
2. Select you Zabbix server host
3. Cut/Paste the "Zabbix server" name to "Visible name":
Visible name : Zabbix Server
4. Enter name with a minus '-'
Host Name    : zabbix-server
5. ![#c5f015](https://placehold.it/15/c5f015/000000?text=+) => stop and start docker containers

- ![#f03c15](https://placehold.it/15/f03c15/000000?text=+) !!! very important !!!
you should first rename your Zabbix Server
=> This is because it is highly recommanded to have a hostname without space (by default on Zabbix !!)

Be careful: The "Visible name" is used by Zabbix Dashboards, so let "Zabbix server" persist as a Visible name.

![alt text](https://github.com/frsauvage/MISM/blob/master/zabbix/doc/Zabbix_Server_Configuration.png)

5. Change the agent to zabbix-agent:
- Remove IP = 127.0.0.1 
- Add DNS = zabbix-agent on the NEXT CASE
- Click on DNS instead of IP
- Port should be 10050

### install Atos templates
You should copy the templates from <install_dir>\zabbix\server\externalscripts\ to a local path
1. Go to Configuration / Templates
2. Click on Import button at the right
![alt text](https://github.com/frsauvage/MISM/blob/master/zabbix/doc/Import_templates.png)
3. Locate your Atos templates
![alt text](https://github.com/frsauvage/MISM/blob/master/zabbix/doc/Select_template.png)
4. Click on Import button below

### add your hosts
1. Go to Configuration / Hosts
2. Click on the right button "Create Host"
3. Add a Name 
4. Change the agent to zabbix-agent:
- Remove IP = 127.0.0.1  IP case should be empty
- Add DNS = zabbix-agent on the DNS case
- Click on DNS button instead of IP
- Port should be 10050

### link Atos template to your host
1. Go to Configuration/Hosts
2. Select your host
3. Click on "Template" tab
4. Filter Atos template and retrieve Atos LLD template
5. Click on Add Link => The template should apear in "Linked Templates" part above
6. Click on Update button
7. Click on "Macros" tab
You must add 3 macros on each mipocket host:
- {$PASSWORD} with the password for Mipocket (could be encrypted with PSK => See Security below)
- {$USER} with the username to be used
- {$OPENBMC} the reachable address of Mipocket

## <a name="edge_template"></a>How to install BullSequana Edge template
### template content
- applications: All items are categorized inside applications with the following rules :
![alt text](https://github.com/frsauvage/MISM/blob/master/zabbix/doc/Applications.png)

- items belong to Applications

- discovered items belong to Applications named "Discovery..."

Fans, Temperature and Voltage are discovered - values are float => it could be added in 'Graph'

![alt text](https://github.com/frsauvage/MISM/blob/master/zabbix/doc/item_prototypes.png)

- triggers

Firmware update failures are triggered

- 4 discovered triggers
1. Critical high & low triggers corresponding to Critical Alarms Threshold fo BullSequana Edge device are Enabled by default
2. Warning high & low triggers to Warning Alarms Threshold fo BullSequana Edge device are Disabled by default
![alt text](https://github.com/frsauvage/MISM/blob/master/zabbix/doc/4_triggers.png)

- automatic inventory mapping

Model, Asset, Serial number, Software Version, OOB IP Address and Manufacturer are automatically fulfilled

![alt text](https://github.com/frsauvage/MISM/blob/master/zabbix/doc/automatic_inventory.png)

- discovered graphs (prototypes) : Fans, Temperatures and Voltages graphs

- 3 dynamic screens: Fans, Temperatures and Voltages screens that you could reach in host details

![alt text](https://github.com/frsauvage/MISM/blob/master/zabbix/doc/host_inventory.png)

![alt text](https://github.com/frsauvage/MISM/blob/master/zabbix/doc/host_screens.png)

## <a name="rsyslog_template"></a>rsyslog template installation
### template content
- application rsyslog is available for textual widget and history analysis
- 1 item
A unique item is detecting rsyslog file change
- trigger
A unique trigger is triggering on BullSequana Edge device error events

!! The rsyslog should be activated BEFORE loading rsyslog template
If ever you start docker containers after loading the rsyslog template : 
=> remove the rsyslog directory created in /var/log/rsyslog because the docker container did not successfully map to /var/log/rsyslog and created a directory (instead of a file) by default:
`rm -rf /var/log/rsyslog`

### activate udp/tcp rsyslog port
in /etc/rsyslog.conf file, uncomment or copy the following lines:
```
### Provides UDP syslog reception
$ModLoad imudp
$UDPServerRun 514

### Provides TCP syslog reception
$ModLoad imtcp
$InputTCPServerRun 514
```

### activate a rsyslog directory in docker-compose mism file
in docker-compose-mism.yml file, zabbix-server service section, uncomment :
    volumes:
       # - /var/log/rsyslog:/var/log/zabbix/rsyslog:rw
where /var/log/rsyslog is a physical (or shared) file on host of the zabbix docker container containing the rsyslog server file

### install logrotate
` yum update && yum install logrotate`
rsyslog should be the only file name of the current rsyslog file for the zabbix template to work
log rotation is mandatory for the rsyslog template immediatly
you must adapt the template if you have another rotation rule

### install logrotate

### syslog template
create your rsyslog template directly in /etc/rsyslog.conf 

or
 
if this line exists in rsyslog.conf
```

### Include all config files in /etc/rsyslog.d/
$IncludeConfig /etc/rsyslog.d/*.conf
```
you can now create a .conf (like /etc/rsyslog.d/rsyslog_template.conf) file in /etc/rsyslog.d/ and place your template format :

`$template rsyslog_format,"%timegenerated% %hostname% %FROMHOST-IP% %syslogfacility-text%:%syslogpriority-text% %syslogtag%%msg:::drop-last-lf%\n" `

and add the following lines in your /etc/rsyslog.conf 

```
$template RemoteLogs,"/var/log/rsyslog"
#*.* ?RemoteLogs;rsyslog_format
:hostname, contains, "my_naming_convention"	?RemoteLogs;rsyslog_format
& ~
```
where my_naming_convention is a substring contained in all BMC hostnames

### rsyslog configuration
Change user permission on rsyslog
` chmod uo+rw /var/log/rsyslog`

### rsyslog system reload/restart after changes

systemctl daemon-reload
systemctl stop rsyslog
systemctl start rsyslog

### rsyslog from the bmc 
` ssh user@<my_bmc>
with telnet to check port opening:
` telnet <my_rsyslog_server_ip> <my_rsyslog_port>

with logger command:
` logger -n <my_rsyslog_server_ip> 'here is a test log message from <my_rsyslog_server_ip>' `

More information on : https://www.tecmint.com/install-rsyslog-centralized-logging-in-centos-ubuntu/

### flush iptables
if telnet is not working but the ping is working : iptables rules could be the issue
You can flush the iptables rules 
!! be careful to be able to recreate itables rules !!

` iptables -F `

## <a name="proxy"></a>Network Proxy
When you start the installer, the declared XXX_PROXY environment variables are copied inside containers :
 
export HTTP_PROXY="http://<proxy_ip>:<proxy_port>"

export HTTPS_PROXY="http://<proxy_ip>:<proxy_port>"

export NO_PROXY="127.0.0.1,localhost,zabbix-server,zabbix-agent,zabbix-web,ansible,awx,awx_web,awx_task,<bullsequana_edge_ip_address>"

![#c5f015](https://placehold.it/15/c5f015/000000?text=+) if you change the XXX_PROXY env variable, you should restart the containers :

```
./stop.sh 
./start.sh
```

## <a name="security"></a>Security
## activate PSK security on zabbix
1. generate a key in /etc/zabbix/zabbix_agentd.psk and follow the instructions
```
<install_dir>/generate_psk_key_for_zabbix.sh
```

2. edit zabbix/agent/zabbix_agentd.conf

3. locate the section and uncomment the 4 following items:

```
####### TLS-RELATED PARAMETERS #######
TLSConnect=psk
TLSAccept=psk
TLSPSKIdentity=PSK_Mipocket_Agent
TLSPSKFile=/etc/zabbix/zabbix_agentd.psk
```

4. activate the PSK security in zabbix / Configuration / Hosts / your host / Encryption
```
Connections to host : <select PSK>
Connections from host : <select PSK>
PSK Identity: PSK_Mipocket_Agent"
echo PSK: <your psk>
```

5. ![#c5f015](https://placehold.it/15/c5f015/000000?text=+) => stop and start docker containers

*more info on https://www.zabbix.com/documentation/4.0/fr/manual/encryption/using_pre_shared_keys*

## generate an encrypted passwords
1. generate an encrypted password for each different password 
` <install_dir>/generate_encrypted_password_for_zabbix.sh --passord=<your_clear_password> `

2. copy/paste encrypted result it in zabbix / Configuration / Hosts / you host / Macros / {$PASSWORD} Value

## <a name="tests"></a>Tests
#### on mi-pocket side
  - Make sure your MiPocket is reachable from the zabbix server/proxy, test with: `telnet <IP OPENBMC>`
  - Make sure your MiPocket is reachable through a browser: `https://<IP OPENBMC>`
#### zabbix_sender
See https://www.zabbix.com/documentation/4.4/manpages/zabbix_sender
#### zabbix_get
See https://www.zabbix.com/documentation/4.4/manpages/zabbix_get

## <a name="updates"></a>Warning for updates
Never change original templates => duplicate or create your own template

## <a name="support"></a>Support
  * This branch corresponds to the release actively under development.
  * If you want to report any issue, then please report it by creating a new issue [here](https://github.com/atos/MISM/issues)
  * If you have any requirements that is not currently addressed, then please let us know by creating a new issue [here](https://github.com/atos/MISM/issues)

## <a name="license"></a>LICENSE
This project is licensed under GPL-3.0 License. Please see the [COPYING](./COPYING.md) for more information

## <a name="version"></a>Version
BullSequana Edge System MAnagement Tool version 2.0.1
