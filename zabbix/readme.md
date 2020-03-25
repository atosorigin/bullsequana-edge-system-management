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
- [How to install BullSequana Edge Host template](#host_template)
- [How to install BullSequana Edge Map template](#map_template)
- [How to install BullSequana Edge Rsyslog template](#rsyslog_template)
- [How to create your first Edge dashboard](#dashboard)
- [How to change your Proxy](#howto_proxy)
- [How to change Local Date / Time Zone](#datetimezone)
- [How to add Security](#security)
- [How to send Email ](#email)
- [How to send SMS](#sms)
- [How to add a Media for a User](#add_media)
- [How to configure a Triggered Action for Users / User Group](#configure_media_action)
- [How to test](#test)
- [How to log on a docker container](#howto_docker_logon)
- [How to build your own docker container](#howto_build)
- [Warning for updates](#updates)
- [Support](#support)
- [LICENSE](#license)
- [Version](#version)

## <a name="what_first"></a>What to do first

### get it !
You can get it from
- Bull SOL (Support on line): full installation
- get zip from this repository
- clone this repository  

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/ansible/doc/git_clone.png)

from zip file, just unzip the file:  
```
unzip <your_zip>
```

from this repository, just clone:   
```
git clone https://github.com/atosorigin/bullsequana-edge-system-management.git
```

### check proxy configuration

The following XXX_PROXY environment variables are automatically **copied** in zabbix context:
- HTTP_PROXY
- HTTPS_PROXY
- NO_PROXY

For more details, read the [How to change your Proxy](#howto_proxy) section

### launch installer
Bull Sequana Edge Zabbix Extensions has 3 Zabbix installers and an option to try it  
Just choose your favorite installation for your environment  
`on existing zabbix: import Atos templates`: you can import Atos templates in your Zabbix environment if you have an existing Zabbix installation  
`full install: <install_dir>/install.sh` Full install - All in Once - it will load all docker containers and optionnaly install Ansible playbooks and plugins => use **stop.sh** and **start.sh** after  
`partial: <install_dir>/install_zabbix.sh` it will build and install only Zabbix docker containers from your local Dockerfiles that you can adapt as needed => use **stop_zabbix.sh** and **start_zabbix.sh** after  
`try it: <install_dir>/install_zabbix_from_dockerhub.sh` mainly dedicated to try bullsequana edge system management tool, it will install dockerhub atosorigin images, you cannot adapt the local Dockerfiles => use **stop_zabbix.sh*** and **start_zabbix.sh** after  
For more information about dockerhub installation Visit https://hub.docker.com/repository/docker/atosorigin/bull-sequana-edge-zabbix-server
 
![#9ECBFF](https://placehold.it/15/9ECBFF/000000?text=+) Best Practice: remove useless install, stop and start scripts  
![#f03c15](https://placehold.it/15/f03c15/000000?text=+) Warning: atosorigin dockerhub images have no warranty, do not use in production  
![#c5f015](https://placehold.it/15/c5f015/000000?text=+) Info: if tar files are not present, images are loaded from internet  

### log on to zabbix
- default url: `https://<ip_address_of_your_host>:4443`
- default user/password is default zabbix user/password: `Admin / zabbix` !! Care the uppercase 'A' !!

### enable automatic inventory by default
1. Go to Administration / General / Others
2. Check 'Automatic' for inventory

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/Admin_Automatic_Inventory.png)

### rename Zabbix Server

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) !!! VERY IMPORTANT !!! ![#f03c15](https://placehold.it/15/f03c15/000000?text=+) 
You should first rename your Zabbix Server
=> It is highly recommanded to have a hostname without space (by default Zabbix Server hostname has a blank space)

1. Go to Configuration / Hosts
2. Select you Zabbix server host
3. Cut/Paste the "Zabbix server" name to "Visible name":
Visible name : Zabbix Server
4. Enter name with a minus '-'
Host Name    : zabbix-server

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) Be careful: The "Visible name" is used by Zabbix Dashboards, so let "Zabbix server" persist as a Visible name.

![#c5f015](https://placehold.it/15/c5f015/000000?text=+) => stop and start zabbix docker containers

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/Zabbix_Server_Configuration.png)

5. Change the agent to zabbix-agent:
- Remove IP = 127.0.0.1 
- Add DNS = zabbix-agent on the NEXT CASE
- Click on DNS instead of IP
- Port should be 10050

### install Atos templates
Available Atos templates:
- **template-atos_openbmc-lld-zbxv4.xml**: should be applied on all Atos mipockets - [How to install BullSequana Edge template](#edge_template)
- **template-atos_openbmc-rsyslog-zbxv4.xml**: should be applied only on the zabbix-server - [How to install BullSequana Edge Rsyslog template](#rsyslog_template)
- **template-atos_openbmc-host-zbxv4.xml**: should be imported in Host Configuration - [How to install BullSequana Edge Host template](#host_template)
- **template-atos_openbmc-sysmap-zbxv4.xml**: should be imported in Map Monitoring - [How to install BullSequana Edge Map template](#map_template)

### add your host
#### add your hosts from host template
![#f03c15](https://placehold.it/15/f03c15/000000?text=+) Warning: You should import lld Bull Sequana Edge template BEFORE  
When you import the host template, you will have a host "BullSequana Edge" automatically configured as your first example
- Zabbix agent is configured to zabbix-agen:10050
- Automatic Inventory is configured
- Macros are prepared
- Atos Bull Sequana Edge LLD Template is linked

![#c5f015](https://placehold.it/15/c5f015/000000?text=+) Info: All you need is to complete empty Macros : go to" Fill Atos template macros" below

#### add your hosts manually
1. Go to Configuration / Hosts
2. Click on the right button "Create Host"
3. Add a Name 
4. Change the agent to zabbix-agent:
- Remove IP = 127.0.0.1  IP case should be empty
- Add DNS = zabbix-agent on the DNS case
- Click on DNS button instead of IP
- Port should be 10050

#### add your hosts with Zabbix discovery service
Optionaly, you can use the Zabbix discovery service to add your hosts.
1. First you should add a **Zabbix Discovery rule**
- Go to Configuration / Discovery
- Create a new Discovery Rule
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/create_discovery_rule.png)
- Fill the IP range and "Check https" protocol. Care the Update interval (1h by default) and choose DNS Name only if you have a DNS (instead you can choose IP Address)
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/discovery_rule.png)

2. Second you should add a **Zabbix Discovery action**:
- Go to Configuration / Actions
- Select Event Source = **Discovery**
- Create a new action
- In New condition select ""Discovery rule"" and choose your previously created rule
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/select_discovery_rule_in_action.png)
- Add your Condition
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/add_discovery_rule.png)
- Click Operations tab
- Fill the Operations you want: here the rule add the discovered host, add the host to "discovered hosts" group, link the template, enable the host and set the inventory to automatic
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/operations_discovery_rule.png)
3. Go to section **Fill Atos template macros** to complete your host with {$OPENBMC},{$USER}, {$PASSWORD} 

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) Warning: after Discovery complete, you may disable the Action to stop discovering hosts all the time and do some changes on you discovered hosts.

#### link Atos template to your host
1. Go to Configuration/Hosts
2. Select your host
3. Click on "Template" tab
4. Filter Atos template and retrieve Atos LLD template
5. Click on Add Link => The template should apear in "Linked Templates" part above
6. Click on Update button
  
*This part does not apply if you use Atos Host Template*
  
### Fill Atos template macros
1. Go to Configuration/Hosts
2. Select your host
3. Click on "Macros" tab
You must add 3 macros on each mipocket host:
- **{$OPENBMC}** the reachable address of Mipocket
- **{$USER}** with the username to be used
- **{$PASSWORD}** with the password for Mipocket (could be encrypted with PSK => See Security below)
  
*This part does not apply if you use Atos Host Template*
  
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/macros.png)

## <a name="edge_template"></a>How to install LLD BullSequana Edge template
### template content
- applications: All items are categorized inside applications with the following rules :
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/Applications.png)

- items belong to Applications

- discovered items belong to Applications named "...Discovery..."

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

- collect items belong to Applications named "...Collect..." : background scripts => NO DATA, do NOT use Collect applications/items in dashboard, except if you are interested in collect background information itself

screens are available in host inventory details:

1. Go to Monitoring / Inventory / Hosts
2. Select your BullSequana Edge device

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/monitoring_host.png)

Screens appear in contextual menu when Host column is available:

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/contextual_host_menu.png)

### import
1. Copy the templates from <install_dir>\zabbix\server\externalscripts\ to a **local path on you client computer running the browser**
2. Open a browser and go to Configuration / **Templates**
3. Click on Import button at the right
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/Import_templates.png)
4. Locate your Atos templates
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/Select_template.png)
5. Click on Import button

## <a name="dashboard"></a>How to create your first Edge dashboard
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
4. Adapt the "show lines" number

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/network.png)

## <a name="host_template"></a>How to install BullSequana Edge Host template
### template content
- 1 host as an example  
### prerequisite
![#c5f015](https://placehold.it/15/c5f015/000000?text=+) Info: You should install LLD Bull Sequana Edge before: [How to install BullSequana Edge template](#edge_template)  
### import
1. Copy the templates from <install_dir>\zabbix\server\externalscripts\ to a **local path on you client computer running the browser**
2. Open a browser and go to Configuration / **Hosts**
3. Click on Import button at the right
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/Import_host.png)
4. Check **Hosts** checkboxes
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/Select_hosts_template.png)
5. Import **template-atos_openbmc-host-zbxv4.xml**

## <a name="rsyslog_template"></a>How to install BullSequana Edge Rsyslog template
### template content
- application rsyslog is available for textual widget and history analysis
- 1 item  
A unique item is detecting rsyslog file change
- 1 trigger  
A unique trigger is triggering on BullSequana Edge device error events

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) The rsyslog should be activated BEFORE loading rsyslog template

### import
1. Copy the templates from <install_dir>\zabbix\server\externalscripts\ to a **local path on you client computer running the browser**
2. Open a browser and go to Configuration / **Templates**
3. Click on Import button at the right
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/Import_templates.png)
4. Locate your Atos templates
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/Select_template.png)
5. Click on Import button

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

### check the read/write rights
check the path of the file, the zabbix agent should have the rights to read it and your system should have the right to write in the file, all along the **path**:
```
example:
- chmod ugo+rw /var
- chmod ugo+rw /var/log
- chmod ugo+rw /var/log/rsyslog
```

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) The rsyslog should have read / write rights all along the **path**

![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/rsyslog_rights.png)

The **rsyslog* file is monitored after the import of the template, so the collect will be triggered by the next line written in the rsyslog file.

![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/rsyslog_key.png)

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
:hostname, contains, "your_naming_convention"	?RemoteLogs;rsyslog_format
& ~
```
where your_naming_convention is a substring contained in all BMC hostnames

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
log on to your bmc : ` ssh user@<your_bmc>`  

with journalctl:  
` journalctl -r`  

with telnet to check port opening:  
` telnet <your_rsyslog_server_ip> <your_rsyslog_port>`  

with logger command:  
` logger 'here is a test log message from <your_rsyslog_server_ip>'`  

More information: Visit https://www.tecmint.com/install-rsyslog-centralized-logging-in-centos-ubuntu/

### known issues
#### I have an rsyslog directory instead of a rsyslog file
If ever you start docker containers after loading the rsyslog template : 

=> remove the rsyslog directory created in /var/log/rsyslog because the docker container did not successfully map to /var/log/rsyslog and created a directory (instead of a file) by default:

`rm -rf /var/log/rsyslog`

and check that the file exists BEFORE loading rsyslog template
`ls /var/log|grep rsyslog`

#### add firewall rules
If telnet is not working but the ping is working : firewall daemon could be the issue  
You should add 2 firewall rules   
```
[root@server ~]# firewall-cmd --permanent --zone=public --add-port=514/tcp
[root@server ~]# firewall-cmd --permanent --zone=public --add-port=514/udp
[root@server ~]# firewall-cmd --reload 
```
![#f03c15](https://placehold.it/15/f03c15/000000?text=+) Be careful to reload it after changes

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) More information: Visit https://www.itzgeek.com/how-tos/linux/centos-how-tos/setup-syslog-server-on-centos-7-rhel-7.html

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/sysLog_firewall_add_exception.png)

#### flush iptables
If telnet is not working but the ping is working: iptables rules could be the issue  
You can flush the iptables rules   

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) Be careful to be able to recreate iptables rules after this command ` iptables -F `

## <a name="map_template"></a>BullSequanaEdgeMap template installation
### template content
- 1 Map template  
![#f03c15](https://placehold.it/15/f03c15/000000?text=+) WARNING: The BullSequanaEdgeIconMapping should be created BEFORE importing BullSequanaEdgeMap template [Create BullSequanaEdge icons](#create_icons) and [Create BullSequanaEdge icon mapping](#create_icon_mapping)

### prerequisite
![#c5f015](https://placehold.it/15/c5f015/000000?text=+) Info: You should install Host Bull Sequana Edge BEFORE: [How to install Host BullSequana Edge template](#host_template)  

### import
1. Copy the templates from <install_dir>\zabbix\server\externalscripts\ to a **local path on you client computer running the browser**
2. Open a browser and go to **Monitoring** / **Map**
3. Click on Import button at the right
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/Import_map.png)
4. Locate your Atos templates
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/Select_maps_template.png)
5. Check the maps and images checkboxes
6. Click on Import button

### <a name="create_icons"></a>Create BullSequanaEdge icons

1. From your browser, you should be able to access <instal_dir>/zabbix/icons directory
2. Go to Administration / General / Image / Icon
3. Create as many icons as images in <instal_dir>/zabbix/icons directory
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/BullSequanaEdge_create_icon.png)
4. Check your icons
![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/BullSequanaEdge_images.png)

### <a name="create_icon_mapping"></a>Create BullSequanaEdge icon mapping

1. Go to Administration / General / Image / IconMapping
2. Create one "Icon Mapping" as below:  
  a- Name should be BullSequanaEdgeIconMapping  
  b- Select Inventory field = Model  
  c- Write Expression = BullSequana Edge  
  d- Select your prefered Icon Size and Default Icon Size  

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/BullSequanaEdge_icon_mapping.png)
  
![#f03c15](https://placehold.it/15/f03c15/000000?text=+) WARNING: Inventory should be "Automatic" for your BullSequana Edge (Model field should be filled)

### Import BullSequanaEdge Map
1. Copy the templates from <install_dir>\zabbix\server\externalscripts\ to a **local path on you client computer running the browser**
2. Open a browser and go to Configuration / Templates
3. Click on Import button at the right
4. Check Maps and Images checkboxes only for Create New
5. Import **template-atos_openbmc-sysmaps-zbxv4.xml**

![#c5f015](https://placehold.it/15/c5f015/000000?text=+) INFO: Your icons will be automatically detected for BullSequana Edge while creating your maps

### Create a map 
1. Go to Monitoring / Maps
2. Create a new Map
3. Add a new Map item
  a- Select 'Host' type  
  b- Select your Host  
  c- Select Automatic icon mapping  

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/BullSequanaEdge_map.png)
  
Your server should behave like any other servers:  

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/BullSequanaEdge_map_warning.png)

## <a name="howto_proxy"></a>How to change your proxy
By default, when you start the installer, the proxy environment variables are added in containers thanks to the following section in docker-compose-awx.yml file:

```
    env-file:
        - Dockerfiles/zabbix.env
      ...
```

You can check your PROXY environment while starting up your AWX:

![alt text](https://github.com/atosorigin/bullsequana-edge-system-management/blob/master/zabbix/doc/proxy.png)

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) If your bullsequana edge IP address is not declared in proxy: You may need to add your bullsequana edge IP address in your NO_PROXY configuration to bypass the proxy 

```
export NO_PROXY="<your bullsequana edge IP address>,$NO_PROXY"
```

If you don't want to use the host configuration for XX_PROXY environment variables:
1. Remove the following line in *install and start shells* 
```
. ./proxy.sh
```

2. Add your proxy environement as desired in *docker-compose-zabbix.yml* file with explicit IP addresses and host names:
```
    env-file:
      zabbix.env
    environment:
      HTTP_PROXY: http://<your proxy>:<your port>
      HTTPS_PROXY: https://<your proxy>:<your port>
      NO_PROXY: <your bullsequana edge IP address>,127.0.0.1,localhost,zabbix-web,zabbix-server,zabbix-agent,awx_web,awx_task,rabbitmq,postgres,memcached
      ...
```

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) INFO: If you change a XXX_PROXY env variable, you should restart the containers :

```
./stop.sh or ./stop_zabbix.sh 
./start.sh or ./start_zabbix.sh
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
### activate PSK security on zabbix
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

![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/BullSequanaEdge_Zabbix_vault_generate_steps.png)

![#c5f015](https://placehold.it/15/c5f015/000000?text=+) you should restart docker containers

*more info on https://www.zabbix.com/documentation/4.0/fr/manual/encryption/using_pre_shared_keys*

### generate an encrypted passwords
1. generate an encrypted password for each different password 
` <install_dir>/generate_encrypted_password_for_zabbix.sh`

2. copy/paste encrypted result it in zabbix / Configuration / Hosts / you host / Macros / {$PASSWORD} Value


## <a name="email"></a>How to configure Email
### Configure Email
1. Go to Administration / Media types
2. Select Email
![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/BullSequanaEdge_Email_SMTP.png)
3. Change email server configuration
![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/BullSequanaEdge_Email_SMTP_Detail.png)

### Test it !
![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/BullSequanaEdge_Email_SMTP_Test.png)

## <a name="sms"></a>How to configure SMS for smsmode
### Create a smsmode User
1. Go to your SMS provider smsmode
See https://ui.smsmode.com
2. Create a token (API key)
![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/BullSequanaEdge_SMS_Token.png)
3. Copy it for further usage
4. You can consult your SMS list to check SMS traffic
![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/BullSequanaEdge_SMS_smsMode_SMSList.png)

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) INFO: 

### Configure SMS
1. Go to Administration / Media types
2. Click on right button "Create Mediatype"
![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/BullSequanaEdge_SMS_Mediatype_Create.png)
3. Fill the form with following parameters
  
--message={ALERT.SUBJECT} - {ALERT.MESSAGE}  
--to={ALERT.SENDTO}  
**--accessToken=<here paste your smsmode token>**  

![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/BullSequanaEdge_SMS_Mediatype.png)

4. Save the form
![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/BullSequanaEdge_SMS_smsmode.png)

## <a name="add_media"></a>How to add a Media for a User
1. Go to Administration / User / <your user> / Media
2. Click "Add" to add a Media
![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/BullSequanaEdge_SMS_Add_Media_For_User.png)
3. Select Email or SMS
4. Enter respectively a correct email or phone number
![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/BullSequanaEdge_SMS_Media.png)
5. Fill the active hours and the minimum severity level
6. Check your  newly created Media in the media list
![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/BullSequanaEdge_SMS_User_Media.png)

### Optionaly add User to a Group
You can add a User to a Group to send Email or SMS to all users of a named group
1. Go to Administration / UserGroups
2. Add User to your desired group

## <a name="configure_media_action"></a>How to configure a Triggered Action for Users / User Group
### Create an action
1. Go to ConfigurationActions
2. Check if "Trigger" Action is selected
3. Click on right button "Create Action"
![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/BullSequanaEdge_SMS_Create_Action.png) 
4. Name the Action
![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/BullSequanaEdge_SMS_Add_Action.png) 
5. Optionaly add a new condition. Your can let it empty to have NO condition

### Create an operation inside an action
1. Add an Operation
![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/BullSequanaEdge_SMS_Create_Operation.png) 
2. Add your desired users or user groups
![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/BullSequanaEdge_SMS_Create_Operation_Detail.png) 
3. Care the "Send only to" field and select needed target : Email or SMS or all
![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/BullSequanaEdge_SMS_Action_Sendto.png) 
4. For each problem - having the minimum severity level in Problems - you should receive an SMS:

![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/BullSequanaEdge_SMS_Alert.png) 
  
![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/BullSequanaEdge_SMS_Alert_SMS.png) 

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

## <a name="howto_build"></a>How to build your own docker container
If you need to adapt a Dockerfile in Dockerfiles directory:
1. edit the desired Dockerfile-xxx.**tag** and adapt it
2. run the corresponding build-xxx
3. edit the corresponding install-xxx script 
4. comment the remove-xxx-containers.sh line
5. run your newly modified install script

![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/dockerfiles_tag_latest.png) 

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) Warning: if you change MISM_TAG_BULLSEQUANA_EDGE_VERSION=**tag** to MISM_TAG_BULLSEQUANA_EDGE_VERSION=**latest**, you should use Dockerfile-xxx.**latest** files

if you need to adapt the versions:
1. edit versions.sh and adapt it
2. run the corresponding build-xxx
3. edit the corresponding install-xxx script 
4. comment the remove-xxx-containers.sh line
5. run your newly modified install script

- versions **tag**
![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/versions_tag.png) 
- versions **latest**
![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/versions_latest.png) 

![#f03c15](https://placehold.it/15/f03c15/000000?text=+) Warning: do *NOT* forget to comment the remove-xxx-containers.sh line at the beginning of the install-xxx script

![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/comment_remove.png) 

After a build and install process, the result should be:
![alt text](https://raw.githubusercontent.com/atosorigin/bullsequana-edge-system-management/master/zabbix/doc/build_process.png) 

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
