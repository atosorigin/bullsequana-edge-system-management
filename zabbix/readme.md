#What to do first on Zabbix

!!! very important !!!
From zabbix web site: go to Configuration / Host and rename:
=> Host Name = "Zabbix server" to Host Name = "zabbix-server" in the first line (mandatory)
=> Visible name = "Zabbix server"

### rename Zabbix Server
1. Go to Configuration / Hosts
2. Select you Zabbix server host
3. Cut/Paste the "Zabbix server" name to "Visible name":
Visible name : Zabbix Server
4. Enter name with a minus '-'
Host Name    : zabbix-server

=> This is because it is highly recommanded to have a hostname without space
==> stop and start docker containers

Be careful: The "Visible name" is used by Zabbix Dashboards, so let "Zabbix server" persist as a Visible name.

5. Change the agent to zabbix-agent:
Remove IP = 127.0.0.1 
Add DNS = zabbix-agent on the NEXT CASE
Click on DNS instead of IP
Port should be 10050

### install Atos templates
You should copy the templates from <install_dir>\zabbix\server\externalscripts\ to a local path
1. Go to Configuration / Templates
2. Click on the right button Import
![alt text](https://github.com/frsauvage/MISM/blob/master/zabbix/doc/Import_templates.png)
3. Locate your Atos templates
4. Click on the Import button below
![alt text](https://github.com/frsauvage/MISM/blob/master/zabbix/doc/Select_template.png)

### add your hosts
1. Go to Configuration / Hosts
2. Click on the right button "Create Host"
3. Add a Name 
4. Change the agent to zabbix-agent:
Remove IP = 127.0.0.1  IP case should be empty
Add DNS = zabbix-agent on the DNS case
Click on DNS button instead of IP
Port should be 10050

### link Atos template to your host
1. Go to Configuration/Hosts
2. Select your host
3. Click on "Template" tab
4. Filter Atos template and retrieve Atos LLD template
5. Click on Add Link => The template should apear in "Linked Templates" part above
6. Click on Update button
7. Click on "Macros" tab
You must add 3 macros on each mipocket host:
    * {$PASSWORD} with the password for Mipocket (could be encrypted with PSK => See Security below)
    * {$USER} with the username to be used
    * {$OPENBMC} the reachable address of Mipocket


## rsyslog template installation
Ensure you renamed zabbix-server for rsyslog template (previously explained)
The hostname for zabbix server should be zabbix-server.

!! The rsyslog should be activated BEFORE loading rsyslog template
If ever you start docker containers after loading the rsyslog template : 
=> remove the rsyslog directory created in /var/log/rsyslog because the docker container did not successfully map to /var/log/rsyslog and created a directory (instead of a file) by default:
`rm -rf /var/log/rsyslog`

#### activate udp/tcp rsyslog port
in /etc/rsyslog.conf file, uncomment or copy the following lines:
```
# Provides UDP syslog reception
$ModLoad imudp
$UDPServerRun 514

# Provides TCP syslog reception
$ModLoad imtcp
$InputTCPServerRun 514
```

#### activate a rsyslog directory in docker-compose mism file
in docker-compose-mism.yml file, zabbix-server service section, uncomment :
    volumes:
       # - /var/log/rsyslog:/var/log/zabbix/rsyslog:rw
where /var/log/rsyslog is a physical (or shared) file on host of the zabbix docker container containing the rsyslog server file

#### install logrotate
` yum update && yum install logrotate`
rsyslog should be the only file name of the current rsyslog file for the zabbix template to work
log rotation is mandatory for the rsyslog template immediatly
you must adapt the template if you have another rotation rule

#### install logrotate

#### syslog template
create your rsyslog template directly in /etc/rsyslog.conf 

or
 
if this line exists in rsyslog.conf
```
# Include all config files in /etc/rsyslog.d/
$IncludeConfig /etc/rsyslog.d/*.conf
```
you can now create a .conf (like /etc/rsyslog.d/rsyslog_template.conf) file in /etc/rsyslog.d/ and place your template format :
$template rsyslog_format,"%timegenerated% %hostname% %FROMHOST-IP% %syslogfacility-text%:%syslogpriority-text% %syslogtag%%msg:::drop-last-lf%\n"

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

# Network Proxy
export HTTP_PROXY="http://<proxy_ip>:<proxy_port>"
export HTTPS_PROXY="http://<proxy_ip>:<proxy_port>"
if ever you have proxy issues, try to add as many <whatever_mipocket_ip_address> as mipocket instance in no_proxy environment variable :
export NO_PROXY="127.0.0.1,localhost,zabbix,webserver,0.0.0.0:9090,0.0.0.0,ansible,awx,awx_web,awx_task,<whatever_ip_address>"

# Security
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

*more info on https://www.zabbix.com/documentation/4.0/fr/manual/encryption/using_pre_shared_keys*

## generate an encrypted passwords
1. generate an encrypted password for each different password 
` <install_dir>/generate_encrypted_password_for_zabbix.sh --passord=<your_clear_password> `

2. copy/paste encrypted result it in zabbix / Configuration / Hosts / you host / Macros / {$PASSWORD} Value

# Tests
#### on mi-pocket side
  - Make sure your MiPocket is reachable from the zabbix server/proxy, test with: `telnet <IP OPENBMC>`
  - Make sure your MiPocket is reachable through a browser: `https://<IP OPENBMC>`
#### zabbix_sender
See https://www.zabbix.com/documentation/4.4/manpages/zabbix_sender
#### zabbix_get
See https://www.zabbix.com/documentation/4.4/manpages/zabbix_get

#Warning for updates
Never change original templates => duplicate or create your own template

#Version
MISM version 2.0.1
