#set base image 
FROM ansible/awx_task:latest

USER root

ENV MISM_BULLSEQUANA_EDGE_VERSION=latest

USER root 

COPY ansible.credentials.py /etc/tower/conf.d/credentials.py
COPY ansible.env /etc/tower/conf.d/environment.sh
COPY ansible.SECRET_KEY /etc/tower/SECRET_KEY

# To be done manually from container : RUN yum update
RUN yum install -y nano which nmap
RUN yum install -y epel-release

RUN pip3 install --upgrade pip 

RUN pip install --upgrade ansible

# Warning : NOT nmap => https://stackoverflow.com/questions/14913153/module-object-has-no-attribute-portscanner
RUN pip install python-nmap
RUN pip install requests
RUN pip install lxml
RUN pip install urllib3
RUN pip install ansible-vault

# RUN pip install ansible-cmdb
RUN pip install pika
RUN pip install paramiko --upgrade
RUN pip install pycryptodome

#Install netaddr so we can use ipaddr filter in ansible
RUN pip install netaddr

WORKDIR /var/lib/awx
