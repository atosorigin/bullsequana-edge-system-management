#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
This script add ansible playbooks to awx
This script is called fomr add_awx_playbooks.sh file
Inspired from https://github.com/jsmartin/tower_populator

Copyright (C) 2022 Atos

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.
This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
You should have received a copy of the GNU General Public License along with
this program. If not, see <http://www.gnu.org/licenses/>.

All users shall be bound by the terms and 
conditions of the GNU General Public License v3.0  
which are stated extensively at the following address : 
https://www.gnu.org/licenses/gpl-3.0.en.html

"""

__author__ = "Francine Sauvage"
__contact__ = "support@atos.net"
__date__ = "2022/01/12"
__deprecated__ = False
__email__ =  "francine.sauvage@atos.net"
__license__ = "GPLv3"
__status__ = "Production"
__version__ = "2.1.10"
__copyright__ = "Copyright 2022, Atos"
__maintainer__ = "Francine Sauvage"
__credits__ = ["Francine Sauvage"]

import yaml
import sys
import tower_cli
import time
from select import select
import os 
import re

class Config:
    def __init__(self, **entries):
        self.__dict__.update(entries)

# load configuration
playbooks = "projects/playbooks.yml" # by default 
if len(sys.argv) > 1:
    playbooks = sys.argv[1]

c = yaml.load(open(playbooks).read())
tower = Config(**c)

bool_force_create=False

org_res = tower_cli.get_resource('organization')
inv_res = tower_cli.get_resource('inventory')
host_res = tower_cli.get_resource('host')
group_res = tower_cli.get_resource('group')
project_res = tower_cli.get_resource('project')
job_template_res = tower_cli.get_resource('job_template')
cred_res = tower_cli.get_resource('credential')
cred_type = tower_cli.get_resource('credential_type')

print("Creating Organization Bull\n")
print(tower.org, tower.org_desc)
#check if Atos already exists
#if org_res.get_resource() :
#    return
# create organization
org = org_res.create(name=tower.org, description=tower.org_desc)
org_id = org['id']

regex = r"[\"]?(?P<cle>[0-9a-zA-Z_\-\.]*)[\"]?: [\"]?(?P<valeur>[0-9a-zA-Z_\-\/\.]*)[\"]?[,]?"
pat = re.compile(regex) 

if tower.credentials:
    for i in tower.credentials:
        try:
            vault = cred_type.get(name=i['credential_type'])
            i['credential_type'] = vault['id']
            i['organization'] = org_id
            cred = cred_res.get(name=i['name'])
            print("Bull Sequana Edge Vault already exists\n")
        except:
            cred = cred_res.create(**i)
            print("Creating Bull Sequana Edge Vault\n")
            bool_force_create=True
        
if tower.inventories:
    # create inventories    
    for i in tower.inventories:        
        i['organization'] = org_id
        try:
            inv = inv_res.get(name=i['name'])
            print("Updating Inventory: {name} variables\n".format(name=i['name']))

            variables = inv.get("variables", None)
            
            if not variables:
                # no variables => creating all default variables
                print("Creating Inventory variables: {name} \n".format(name=i['name']))
                inv_res.modify(name=i['name'], variables=i['variables'])
                break
            matches = re.finditer(pat, variables)
            existing_variables = {}
            for match in matches:
                existing_variables[match.group("cle")] = match.group("valeur")
            #print(i['variables'].items())

            for cle, valeur in i['variables'].items():
                #print("{} {}".format(cle, valeur) )
                if cle == 'ntp_server_sync':                   
                    existing_variables[cle] = 'NTP'
                    print("Key found => {} = {}".format(cle, 'NTP'))
                    continue
                if not cle in existing_variables:
                    print("Key not found => Creating key={} with value={} in your ANSIBLE VARIABLES".format(cle, valeur))
                    if isinstance(valeur, "str") and valeur.isdigit():
                        print(type(valeur))
                        valeur = int(valeur)
                    existing_variables[cle]=valeur
                else: # do NOT change existing variables
                    valeur_existing = existing_variables[cle]
                    if valeur_existing.isdigit():
                        valeur_existing = int(valeur_existing)
                        print("Key found as integer => {} = {}".format(cle, valeur_existing))
                    elif isinstance(valeur_existing, bool) and valeur_existing :
                        print("Key found as True => {} = {}".format(cle, valeur_existing))
                        valeur_existing = True
                    elif isinstance(valeur_existing, bool) and not valeur_existing:
                        print("Key found as False => {} = {}".format(cle, valeur_existing))
                        valeur_existing = False
                    elif valeur_existing.lower() == 'true':
                        valeur_existing = True
                        print("Key found as bool=true => {} = {}".format(cle, valeur_existing))
                    elif valeur_existing.lower() == 'false':
                        valeur_existing = False
                        print("Key found as bool=false => {} = {}".format(cle, valeur_existing))
                    else :
                        print("Key found as string => {} = {}".format(cle, valeur_existing))
                    existing_variables[cle] = valeur_existing

            # result = yaml.dump(existing_variables)
            result = yaml.safe_dump(existing_variables, default_flow_style=False)
            # print(result)
            inv_res.modify(name=i['name'], variables=result)
            print("Updated Inventory: {name} variables\n".format(name=i['name']))
        except:
            print("Exception !! Recreating Inventory: {name}\n".format(name=i['name']))
            i['variables'] = yaml.safe_dump(i['variables'], default_flow_style=False)
            print(i['variables'])
            inv = inv_res.create(**i)
            bool_force_create=True
            # create dynamic groups, static ones can be imported better with awx-manage
            if 'groups' in i:
                for g in i['groups']:
                    #print(g)
                    g['inventory'] = inv['id']
                    # set the credential if this group has one
                    group = group_res.create(**g)
                    # sync the group if it has a credential
                    if 'group' in group:
                        id = group['group']
                    elif 'id' in group :
                        id = group['id']
                    if 'credential' in g:
                        group_res.sync(id)
                    if 'hosts' in g:
                        for h in g['hosts']:
                            h['inventory'] = inv['id']
                            #print(h)
                            host = host_res.create(**h)
                            host_res.associate(host=host['id'], group=group['id'])
        
       
if tower.projects:
    for p in tower.projects:
        p['description'] = "Playbooks {version} for BullSequana Edge".format(version=os.environ.get('MISM_BULLSEQUANA_EDGE_PLAYBOOKS_VERSION'))        
        try:
            proj = project_res.get(name=p['name'])
            print("Updating Project description: {description}\n".format(description=p['description']))
            project_res.modify(name=p['name'], description=p['description'])
        except:
            print("Creating Project: Playbooks {version} for BullSequana Edge\n".format(version=os.environ.get('MISM_BULLSEQUANA_EDGE_PLAYBOOKS_VERSION')))
            p['organization'] = org_id
            project_res.create(**p)
            bool_force_create=True

if tower.job_templates:
    print("Waiting 30 seconds for projects to index.")
    print("Press any key to skip if you know what you're doing.")
    timeout = 30
    rlist, wlist, xlist = select([sys.stdin], [], [], timeout)
    for j in tower.job_templates:
        try:
            inv = inv_res.get(name=j['inventory'])
            j['inventory'] = inv['id']
            project = project_res.get(name=j['project'])
            j['project'] = project['id']
            j['organization'] = org_id
            j['credential'] = cred['id']
            if bool_force_create :
                print("  Creating Job Template {name}\n".format(name=j['name']))
                job_template_res.create(**j)
                continue
            else:
                job_temp = job_template_res.get(name=j['name'])
                print("  Job Template {name} already exists\n".format(name=j['name']))
        except:
            print("  Creating Job Template {name}\n".format(name=j['name']))
            job_template_res.create(**j)

print("-----------------------------------------------------------------------------------------")
print("What to do first ?")
print("See https://github.com/atosorigin/bullsequana-edge-system-management/tree/master/ansible")
print("-----------------------------------------------------------------------------------------")

inv_res.delete(name="Demo Inventory")
project_res.delete(name="Demo Project")
cred_res.delete(name="Demo Credential")
job_template_res.delete(name="Demo Job Template") 
