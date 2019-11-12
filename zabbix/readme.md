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
    - [BullSequana Edge Dockerhub Zabbix server image](https://hub.docker.com/repository/docker/atosorigin/bull-sequana-edge-zabbix-server)
    - [BullSequana Edge Dockerhub Zabbix web image](https://hub.docker.com/repository/docker/atosorigin/bull-sequana-edge-zabbix-web)
    - [BullSequana Edge Dockerhub Zabbix agent image](https://hub.docker.com/repository/docker/atosorigin/bull-sequana-edge-zabbix-agent)
  * Docker CE
  * Docker compose

## Summary
- [BullSequana Edge Zabbix Templates](#templates)
- [What to do first](#what_first)
- [How to install BullSequana Edge template](#edge_template)
- [How to install rsyslog template](#rsyslog_template)
- [How to create my first Edge dashboard](#dashboard)
- [How to change my Proxy](#howto_proxy)
- [How to change Local Date / Time Zone](#datetimezone)
- [How to add Security](#security)
- [How to test](#test)
- [How to log on a docker container](#howto_docker_logon)
- [Warning for updates](#updates)
- [Support](#support)
- [LICENSE](#license)
- [Version](#version)

## <a name="what_first"></a>What to do first

### check proxy configuration

By default, the following XXX_PROXY environment variables are copied in zabbix context : HTTP_PROXY, HTTPS_PROXY, NO_PROXY

For more details, read the [How to change my Proxy](#howto_proxy) part

### launch installer
Run the install script:

`<install_dir>/install_zabbix.sh`

or if you want to use the Docker Atos images, you can now run the following Dockerhub install script:

`<install_dir>/install_zabbix_from_dockerhub.sh`

### enable automatic inventory by default
1. Go to Administration / General / Others
2. Check 'Automatic' for inventory

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/Admin_Automatic_Inventory.png)

### rename Zabbix Server
1. Go to Configuration / Hosts
2. Select you Zabbix server host
3. Cut/Paste the "Zabbix server" name to "Visible name":
Visible name : Zabbix Server
4. Enter name with a minus '-'
Host Name    : zabbix-server
5. ![#c5f015](https://placehold.it/15/c5f015/000000?text=+) => stop and start docker containers

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) !!! very important !!!
you should first rename your Zabbix Server
=> This is because it is highly recommanded to have a hostname without space (by default on Zabbix !!)

Be careful: The "Visible name" is used by Zabbix Dashboards, so let "Zabbix server" persist as a Visible name.

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/Zabbix_Server_Configuration.png)

5. Change the agent to zabbix-agent:
- Remove IP = 127.0.0.1 
- Add DNS = zabbix-agent on the NEXT CASE
- Click on DNS instead of IP
- Port should be 10050

### install Atos templates
You should copy the templates from <install_dir>\zabbix\server\externalscripts\ to a local path
1. Go to Configuration / Templates
2. Click on Import button at the right
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/Import_templates.png)
3. Locate your Atos templates
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/Select_template.png)
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
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/Applications.png)

- items belong to Applications

- discovered items belong to Applications named "Discovery..."

Fans, Temperature and Voltage are discovered - values are float => it could be added in 'Graph'

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/item_prototypes.png)

- triggers

Firmware update failures are triggered

- 4 discovered triggers
1. Critical high & low triggers corresponding to Critical Alarms Threshold fo BullSequana Edge device are Enabled by default
2. Warning high & low triggers to Warning Alarms Threshold fo BullSequana Edge device are Disabled by default
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/4_triggers.png)

- automatic inventory mapping

Model, Asset, Serial number, Software Version, OOB IP Address and Manufacturer are automatically fulfilled

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/automatic_inventory.png)

- discovered graphs (prototypes) for each fans, temperatures and voltages discoverd item with Critical High and Low values

- 1 screen with the 3 graphs : All Fans, Temperatures and Voltages

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/host_screens.png)

screens are available in host inventory details:

1. Go to Monitoring / Inventory / Hosts
2. Select your BullSequana Edge device

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/monitoring_host.png)

Screens appear in contextual menu when Host column is available:

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/contextual_host_menu.png)

## <a name="dashboard"></a>How to create my first Edge dashboard
### create a dashboard
1. Go to Monitoring / Dashboard
2. Click on the right button "Create Dashboard"

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/create_dashboard.png)

3. Add a Name 
4. Add a Widget

### add a graph
1. Select "Graph"
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/add_graph_widget_dashboard.png)

2. Select whatever items you want or write an item regular expression like  
Fan: *  
Temp: *  
Volt: *  

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/dashboard_graphs_sensors.png)

3. Optionally add another Dataset with different colors by clicking *Add a new Data Set* button below

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/3_fan_colors_set.png)

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/3_fan_colors_design.png)

4. Optionally if you need to start from 0, adjust the min Y axe :

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/axes_0.png)

### add a data overview 
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/add_data_overview_widget_dashboard.png)

1. Select "Data Overview"
2. Select whatever Application you want
3. Adapt the refresh interval

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/states.png)

### add a plain text
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/plain_text.png)

1. Select "Plain text"
2. Select whatever items you want

![#c5f015](https://placehold.it/15/c5f015/000000?text=+) items are prefixed with application names like "Control:" "Network:" "State:" ...

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/select_items.png)

3. Adapt the refresh interval
3. Adapt the "show lines" number

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/network.png)

## <a name="rsyslog_template"></a>rsyslog template installation
### template content
- application rsyslog is available for textual widget and history analysis
- 1 item
A unique item is detecting rsyslog file change
- trigger
A unique trigger is triggering on BullSequana Edge device error events

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) The rsyslog should be activated BEFORE loading rsyslog template

If ever you start docker containers after loading the rsyslog template : 

=> remove the rsyslog directory created in /var/log/rsyslog because the docker container did not successfully map to /var/log/rsyslog and created a directory (instead of a file) by default:

`rm -rf /var/log/rsyslog`

### activate udp/tcp rsyslog port
In /etc/rsyslog.conf file, uncomment or copy the following lines:
```
### provides UDP syslog reception
$ModLoad imudp
$UDPServerRun 514

### provides TCP syslog reception
$ModLoad imtcp
$InputTCPServerRun 514
```

### activate a rsyslog directory in docker-compose mism file
In docker-compose-zabbix.yml file, zabbix-server service section, uncomment :
```
    volumes:
       # - /var/log/rsyslog:/var/log/zabbix/rsyslog:rw
```
where /var/log/rsyslog is a physical (or shared) file on host of the zabbix docker container containing the rsyslog server file

### install logrotate
log rotation is mandatory for the rsyslog template

install with your usual package manager like yum
` yum update && yum install logrotate`

rsyslog file should be the only file name of the current rsyslog file for the zabbix template to work => you must adapt the template if you have another rotation rule

### syslog template
Create your rsyslog template directly in /etc/rsyslog.conf  
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
```
systemctl daemon-reload
systemctl stop rsyslog
systemctl start rsyslog
```

### rsyslog from the bmc 
` ssh user@<my_bmc>`
with telnet to check port opening:
` telnet <my_rsyslog_server_ip> <my_rsyslog_port>`

with logger command:
` logger -n <my_rsyslog_server_ip> 'here is a test log message from <my_rsyslog_server_ip>'`

More information: Vist https://www.tecmint.com/install-rsyslog-centralized-logging-in-centos-ubuntu/

### flush iptables
If telnet is not working but the ping is working : iptables rules could be the issue  
You can flush the iptables rules   
![#f03c15](https://placehold.it/15/f03c15/000000?text=+) Be careful to be able to recreate itables rules after this command
` iptables -F `

## <a name="howto_proxy"></a>How to change my Proxy
By default, when you start the installer, the proxy environment variables are copied in containers thanks to the following section in docker-compose-zabbix.yml file:

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

If you don't want to use XX_PROXY environment variables, you can directly adapt the proxy configuration as desired in *docker-compose-zabbix.yml* file:
```
    environment:
      HTTP_PROXY: http://<your proxy>:<your port>
      HTTPS_PROXY: https://<your proxy>:<your port>
      NO_PROXY: <your bullsequana edge IP address>,127.0.0.1,localhost,zabbix-web,zabbix-server,zabbix-agent,awx_web,awx_task,rabbitmq,postgres,memcached
      ...
```

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) if you change a XXX_PROXY env variable, you should restart the containers :

```
./stop.sh
./start.sh
```

## <a name="datetimezone"></a>How to change local Date / Time Zone
### localtime
By default, containers and host have the same /etc/localtime.

To change your local time, edit docker-compose-zabbix.yml file
```
    volumes:
      - /etc/localtime:/etc/localtime:ro
```

### timezone
By default, when you start the installer, the host timezone (in /etc/timezone or /usr/share/zoneinfo) are copied inside containers as PHP_TZ.  
To override your time zone, edit docker-compose-zabbix.yml file
```
    environment:
      ...
      PHP_TZ: ${timezone}
```

## <a name="security"></a>How to add Security
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

![#c5f015](https://placehold.it/15/c5f015/000000?text=+) you should restart docker containers

*more info on https://www.zabbix.com/documentation/4.0/fr/manual/encryption/using_pre_shared_keys*

## generate an encrypted passwords
1. generate an encrypted password for each different password 
` <install_dir>/generate_encrypted_password_for_zabbix.sh --password=<your_clear_password> `

2. copy/paste encrypted result it in zabbix / Configuration / Hosts / you host / Macros / {$PASSWORD} Value

## <a name="test"></a>How to Test
### on mi-pocket side
  - Make sure your MiPocket is reachable from the zabbix server/proxy, test with: `telnet <IP OPENBMC>`
  - Make sure your MiPocket is reachable through a browser: `https://<IP OPENBMC>`
### zabbix_sender
See https://www.zabbix.com/documentation/4.4/manpages/zabbix_sender
### zabbix_get
See https://www.zabbix.com/documentation/4.4/manpages/zabbix_get

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
zabbix-server  
zabbix-agent  
zabbix-web  
zabbix-postgres  

examples :
`docker exec -it zabbix-server bash`

## <a name="updates"></a>Warning for updates

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) Never change original templates => duplicate or create your own template

## <a name="support"></a>Support
  * This branch corresponds to the release actively under development.
  * If you want to report any issue, then please report it by creating a new issue [here](https://github.com/atosorigin/bullsequana-edge-system-management/issues)
  * If you have any requirements that is not currently addressed, then please let us know by creating a new issue [here](https://github.com/atosorigin/bullsequana-edge-system-management/issues)

## <a name="license"></a>LICENSE
This project is licensed under GPL-3.0 License. Please see the [COPYING](../COPYING.md) for more information

## <a name="version"></a>Version
BullSequana Edge System Management Tool version 2.0.1
