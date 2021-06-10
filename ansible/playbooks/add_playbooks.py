#!/usr/bin/env python3
# # -*- coding: utf-8 -*-
#
# Atos BullSequana Edge Ansible Modules
# Version 2.0
# Copyright (C) 2019 Atos or its subsidiaries. All Rights Reserved.

# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
#
# Inspired from https://github.com/jsmartin/tower_populator

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
            for cle, valeur in i['variables'].items():
                if not cle in existing_variables:
                    print("Key not found => Creating key={} with value={} in your ANSIBLE VARIABLES".format(cle, valeur))
                    if type(valeur)=="str" and valeur.isdigit():
                        print(type(valeur))
                        valeur = int(valeur)
                    existing_variables[cle]=valeur
                else: # do NOT change existing variables
                    valeur_existing = existing_variables[cle]
                    if type(valeur_existing)=="str" and valeur_existing.isdigit():
                        valeur_existing = int(valeur_existing)
                    print("Key found => {} = {}".format(cle, valeur_existing))
                    existing_variables[cle] = valeur_existing

            result = yaml.dump(existing_variables)
            inv_res.modify(name=i['name'], variables=result)
            print("Updated Inventory: {name} variables\n".format(name=i['name']))
        except:
            print("Exception !! Recreating Inventory: {name}\n".format(name=i['name']))
            i['variables'] = yaml.dump(i['variables'])
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
