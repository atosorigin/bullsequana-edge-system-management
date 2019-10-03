
Installation de Docker
======================

**Installation de la version CE : https://docs.docker.com/install/linux/docker-ce/centos/**

``` Etape 1 : installation
$ sudo yum install docker-ce docker-ce-cli containerd.io docker-compose
```

``` Etape 2 : démarrage du service docker
$ sudo systemctl start docker
```

``` Etape 3 : première installation et mises à jour de mism
$ cd /var/mism
$ ./install.sh
```

``` Etape 4 : vérification
$ docker ps
/var/mism# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                                                                        NAMES
xxxxxxxxxxxx        mism_awx_task       "/tini -- /bin/sh -c…"   19 seconds ago      Up 12 seconds       8052/tcp awx_task
xxxxxxxxxxxx        mism_awx_web        "/tini -- /bin/sh -c…"   24 seconds ago      Up 19 seconds       0.0.0.0:443->8052/tcp awx_web
xxxxxxxxxxxx        mism_pgadmin        "/entrypoint.sh"         26 seconds ago      Up 19 seconds       443/tcp, 0.0.0.0:8080->80/tcp pgadmin4
xxxxxxxxxxxx        mism_rabbitmq       "docker-entrypoint.s…"   32 seconds ago      Up 26 seconds       4369/tcp,...->15672/tcp   rabbitmq
xxxxxxxxxxxx        mism_postgres       "docker-entrypoint.s…"   32 seconds ago      Up 26 seconds       5432/tcp awx_postgres
xxxxxxxxxxxx        memcached:alpine    "docker-entrypoint.s…"   32 seconds ago      Up 27 seconds       11211/tcp awx_memcached
```

Docker Proxy
============

**Configuration du Proxy : /etc/systemd/system/docker.service.d/http-proxy.conf**

[Service]
Environment="HTTP_PROXY=http://193.56.47.20:8080/"
Environment="HTTPS_PROXY=http://193.56.47.20:8080/"
Environment="NO_PROXY=127.0.0.1,localhost,elasticsearch,kibana,logstash,filebeat,metricbeat,heartbeat,auditbeat,grafana,prometheus,nodeexporter,node-red, caddy,cadvisor,alertmanager,172.31.130.224,172.31.60.18,172.31.92.239,172.31.100.156,172.31.60.18,172.31.92.249,172.31.92.222,172.31.92.44,172.31.92.34"

**~/.docker/config.json**

{
	"proxies":{
		"default":{
			"httpProxy":"http://193.56.47.20:8080",
			"httpsProxy":"https://193.56.47.20:8080",
			"noProxy":"l127.0.0.1,localhost,webserver,0.0.0.0:9090,0.0.0.0,ansible,awx,rabbitmq,postgres,memcached,elasticsearch,kibana,logstash,172.31.130.224,172.31.60.18,172.31.92.239,172.31.100.156,172.31.60.18,172.31.92.249,172.31.92.222,172.31.92.44,172.31.92.34"
		}
	}
}

**environment variables**

export NO_PROXY=127.0.0.1,localhost,zabbix,zabbix-server,zabbix-agent,webserver,0.0.0.0:9090,0.0.0.0,ansible,awx,awx_web,awx_task,rabbitmq,postgres,memcached,elasticsearch,kibana,logstash,filebeat,metricbeat,heartbeat,auditbeat,grafana,prometheus,nodeexporter,caddy,cadvisor,alertmanager,172.31.130.224,172.31.60.18,172.31.92.239,172.31.100.156,172.31.60.18,172.31.92.249,172.31.92.222,172.31.92.44,172.31.92.34

export HTTP_PROXY=193.56.47.20:8080
export HTTPS_PROXY=193.56.47.20:8080
ou
export HTTP_PROXY=193.56.47.8:8080
export HTTPS_PROXY=193.56.47.8:8080
ou
export HTTP_PROXY=129.182.4.159
export HTTPS_PROXY=129.182.4.159

Docker Livraison
================
### vérifier la version lors de la génération des images : 
1. MISM_VERSION doit exister dans les variables d'environnement lors du docker-compose / build
2. inscrire manuellement cette version dans le fichier de login : loginModal.partial.html
3. vérifier le fichier external_vars.yml : pas de variable par défaut
4. vérifier le fichier hosts : pas de variable par défaut

puis choisir une des 2 méthodes :

### méthode 1
1. fabriquer les tar des images
```
docker save -o mism/mism_awx_task.tar mism_awx_task:latest
docker save -o mism/mism_awx_web.tar mism_awx_web:latest
docker save -o mism/mism_memcached.tar memcached:alpine
docker save -o mism/mism_postgres.tar mism_postgres:latest
docker save -o mism/mism_pgadmin.tar mism_pgadmin:latest
docker save -o mism/mism_rabbitmq.tar mism_rabbitmq:latest
docker save -o mism/mism_zabbix-agent.tar mism_zabbix-agent:latest
docker save -o mism/mism_zabbix-server.tar mism_zabbix-server:latest
docker save -o mism/mism_zabbix-web.tar mism_zabbix-web:latest

```

2. copier les autres fichiers
cp -r ansible mism
cp -r zabbix mism
cp *.sh mism
cp docker-compose-mism.yml mism

ou
### méthode 2
1. - recuperer le directory "mism/ansible" et les fichiers "docker-compose-mism.yml" et install.sh+uninstall.sh+start/stop.sh+remove_user_data.sh:
. git clone https://bitbucket.sdmc.ao-srv.com/scm/eds/mism.git
2. sous mism, ne garder que le repertoire ansible et les 2 fichiers "docker-compose-mism.yml" et les scripts install.sh+uninstall.sh+start/stop.sh.

`cd mism; ls -al`

drwxr-xr-x. 5 root root         48 Jul  4 16:57 ansible
drwxr-xr-x. 3 root root         20 Jul  4 16:58 pgdata
-rw-r--r--. 1 root root       4382 Jul  4 17:01 docker-compose-mism.yml
-rwxr-xr-x. 1 root root        715 Jul  4 16:57 install.sh
-rwxr-xr-x. 1 root root        715 Jul  4 16:57 uninstall.sh
-rwxr-xr-x. 1 root root        715 Jul  4 16:57 start.sh
-rwxr-xr-x. 1 root root        715 Jul  4 16:57 stop.sh
-rw-------. 1 root root 1340073472 Jul  4 16:01 mism_awx_task.tar
-rw-------. 1 root root 1139858944 Jul  4 16:50 mism_awx_web.tar
-rw-------. 1 root root   10688512 Jul  4 16:52 mism_memcached.tar
-rw-------. 1 root root  320713216 Jul  4 16:53 mism_postgres.tar
-rw-------. 1 root root  194176000 Jul  4 16:53 mism_rabbitmq.tar
-rw-------. 1 root root  237178880 Jul  4 16:55 mism_zabbix-agent.tar
-rw-------. 1 root root  322484224 Jul  4 16:55 mism_zabbix-server.tar
-rw-------. 1 root root  438543872 Jul  4 16:56 mism_zabbix-web.tar
drwxr-xr-x. 4 root root         83 Jul  4 16:57 zabbix

3. supprimer puis fabriquer le tar (gz):
```
cd ..
rm mism.gz 
tar -czvf mism.gz mism/*
```
4. fabriquer les livrables légers
rm mism_ansible.tar
rm mism_zabbix.tar
tar -cvf mism_ansible.tar ansible/* add_playbooks.sh
tar -cvf mism_zabbix.tar zabbix/server/externalscripts/template-atos_openbmc-lld-zbxv4.xml zabbix/server/externalscripts/template-atos_openbmc-rsyslog-zbxv4.xml 

4. copier mism.gz dans le serveur de livraison 172.31.65.210:
sous /usr/common_os/livraison/LIVRAISON-mism/version-x.x/rel-x

a) Se connecter sur 172.31.65.210
ssh 172.31.65.210
root
fsmfsm04
b) Aller dans le répertoire de destination
cd /usr/common_os/livraison/LIVRAISON-mism/version-<M>.<m>
c) Créer une release
mkdir rel-y
d) Copier mism.tar
scp mism.gz root@172.31.65.210:/usr/common_os/livraison/LIVRAISON-mism/version-<M>.<m>/rel-<tag>

6. Incrémenter MISM_VERSION

Docker Compose know issue
=========================
after a yum upgrade => if you have an issue : reinstall docker-compose

See https://stackoverflow.com/questions/49839028/how-to-upgrade-docker-compose-to-latest-version

$ yum remove docker-compose
$ export VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)
=> check VERSION : 
$ env|grep VERSION

$ export DESTINATION=/usr/local/bin/docker-compose
$ curl -L https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m) -o $DESTINATION

$ chmod +x /usr/local/bin/docker-compose
$ ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
$ docker-compose --version
=> check reinstall : 
docker-compose version 1.24.1, build 4667896b

Ansible CLI config outside docker
=================================
# Default on docker : ANSIBLE_CONFIG=/etc/ansible
# ansible.cfg is in /etc/ansible/ansible.cfg
# on host:
export ANSIBLE_CONFIG=/<install_dir>/mism/ansible/inventory/

# Default on docker : ANSIBLE_INVENTORY=/var/lib/awx/projects/inventory
# hosts is in  /var/lib/awx/projects/inventory/hosts
# on host:
export ANSIBLE_INVENTORY=/<install_dir>/mism/ansible/inventory

# Default on docker : DEFAULT_ANSIBLE_LIBRARY=~/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
# and DEFAULT_ANSIBLE_MODULE_UTILS=~/.ansible/plugins/module_utils:/usr/share/ansible/plugins/module_utils
# atos_openbmc module is in /var/mism/ansible/playbooks/library/remote_management/openbmc
# on host:
export DEFAULT_MODULE_PATH=~/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
export DEFAULT_MODULE_UTILS_PATH=~/.ansible/plugins/module_utils:/usr/share/ansible/plugins/module_utils
export ANSIBLE_LIBRARY=$DEFAULT_MODULE_PATH:/<install_dir>/mism/ansible/plugins/modules
export ANSIBLE_MODULE_UTILS=$DEFAULT_MODULE_UTILS_PATH:/var/mism/ansible/plugins/modules

# Default on docker : DEFAULT_ANSIBLE_CALLBACK_PLUGINS=~/.ansible/plugins/callback:/usr/share/ansible/plugins/callback
# unixy callback module is in /usr/share/ansible/plugins/callback/ansible_stdout_compact_logger
# on host:
export ANSIBLE_CALLBACK_PLUGINS=$DEFAULT_ANSIBLE_CALLBACK_PLUGINS:/<install_dir>/mism/ansible/plugins/callback/ansible_stdout_compact_logger
```

