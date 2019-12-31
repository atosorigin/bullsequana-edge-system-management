#set base image 
FROM zabbix/zabbix-web-nginx-pgsql:centos-4.4.1

ENV MISM_BULLSEQUANA_EDGE_VERSION=2.0.4

COPY items.inc.php /usr/share/zabbix/include/
COPY logo-header.svg /usr/share/zabbix/assets/img/
COPY dark-theme.css /usr/share/zabbix/assets/styles/
COPY blue-theme.css /usr/share/zabbix/assets/styles/


