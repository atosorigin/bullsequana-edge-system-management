#set base image 
FROM ansible/awx_web:latest

USER root 

ENV MISM_BULLSEQUANA_EDGE_VERSION=latest

# security
COPY ansible.credentials.py /etc/tower/conf.d/credentials.py
COPY ansible.env /etc/tower/conf.d/environment.sh
COPY ansible.cors.py /etc/tower/conf.d/cors.py
COPY ansible.SECRET_KEY /etc/tower/SECRET_KEY
COPY ansible.nginx.conf /etc/nginx/nginx.conf

#COPY logo-header.svg /var/lib/awx/venv/awx/lib64/python3.6/site-packages/awx/ui/static/assets/ 
COPY logo-atos-login.svg /var/lib/awx/venv/awx/lib64/python3.6/site-packages/awx/ui/static/assets/ 
COPY loginModal.partial.html /var/lib/awx/venv/awx/lib64/python3.6/site-packages/awx/ui/static/partials/login/loginModal/

#RUN yum update
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

# tower-cli install and config
RUN pip install ansible-tower-cli
RUN export TOWER_HOST=https://localhost:8052
RUN pip install paramiko --upgrade
RUN pip install pycryptodome

#Install netaddr so we can use ipaddr filter in ansible
RUN pip install netaddr

EXPOSE 8052

WORKDIR /var/lib/awx

