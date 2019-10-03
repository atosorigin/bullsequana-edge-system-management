#!/bin/sh

# uncomment if changes in ansible.cfg
# cp -r ansible/inventory mism/ansible/inventory
# cp -r ansible/awx-ssl mism/ansible/awx-ssl = useless
echo copy ansible ...
rm -rf mism/ansible
cp -r ansible mism

echo zabbix...
rm -rf mism/zabbix
cp -r zabbix mism/

rm -rf mism/*.sh
cp *.sh mism/
rm -f docker-compose-mism.yml
cp docker-compose-mism.yml mism/

cd mism
rm -f generate_tar.sh
rm -f remove_user_data.sh
rm -f uninstall_*.sh
rm -f ansible.environment.sh
rm -f ansible/plugins/inventory/ansible-inventory-cache/*
rm -rf zabbix/server/externalscripts/tests
rm ansible/plugins/callback/ansible_stdout_compact_logger/callback/*.pyc
rm -rf ansible/playbooks/library
rm -rf ansible/playbooks/openbmc/rabbitmq
rm -rf zabbix/server/externalscripts/.pytest_cache/
rm -rf zabbix/server/externalscripts/.vscode/
rm -f zabbix/server/externalscripts/decrypt_psk_password
rm -f zabbix/server/externalscripts/openbmc_debug
rm -f zabbix/agent/zabbix_agentd.psk
touch zabbix/agent/zabbix_agentd.psk
cd ..

echo restore images ...
docker save -o mism/mism_awx_task.tar mism_awx_task:latest
docker save -o mism/mism_awx_web.tar mism_awx_web:latest
docker save -o mism/mism_memcached.tar memcached:alpine
docker save -o mism/mism_postgres.tar mism_postgres:latest
docker save -o mism/mism_pgadmin.tar mism_pgadmin:latest
docker save -o mism/mism_rabbitmq.tar mism_rabbitmq:latest
docker save -o mism/mism_zabbix-agent.tar mism_zabbix-agent:latest
docker save -o mism/mism_zabbix-server.tar mism_zabbix-server:latest
docker save -o mism/mism_zabbix-web.tar mism_zabbix-web:latest

echo creating mism.gz
rm -f mism.tar.gz 
tar -czvf mism.tar.gz mism/*

rm -f mism_ansible.gz
rm -f mism_zabbix.gz
cd mism
echo creating mism_ansible.gz
tar -czvf mism_ansible.gz ansible/playbooks ansible/plugins add_playbooks.sh
echo creating mism_zabbix.gz
tar -czvf mism_zabbix.gz zabbix/server/externalscripts/template-atos_openbmc-lld-zbxv4.xml zabbix/server/externalscripts/template-atos_openbmc-rsyslog-zbxv4.xml 
mv mism_ansible.gz ..
mv mism_zabbix.gz ..
cd ..
