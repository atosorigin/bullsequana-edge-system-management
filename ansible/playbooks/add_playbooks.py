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

class Config:
    def __init__(self, **entries):
        self.__dict__.update(entries)

# load configuration
playbooks = "projects/playbooks.yml" # by default 
if len(sys.argv) > 1:
    playbooks = sys.argv[1]

c = yaml.load(open(playbooks).read())
tower = Config(**c)

org_res = tower_cli.get_resource('organization')
inv_res = tower_cli.get_resource('inventory')
host_res = tower_cli.get_resource('host')
group_res = tower_cli.get_resource('group')
project_res = tower_cli.get_resource('project')
job_template_res = tower_cli.get_resource('job_template')
cred_res = tower_cli.get_resource('credential')
cred_type = tower_cli.get_resource('credential_type')

print("\nCreating Organization Bull\n")
print(tower.org, tower.org_desc)
#check if Atos already exists
#if org_res.get_resource() :
#    return
# create organization
org = org_res.create(name=tower.org, description=tower.org_desc)
org_id = org['id']

if tower.credentials:
    # create one credential
    print("\nCreating Bull Sequana Edge Vault\n")
    for i in tower.credentials:
        #print(i)
        vault = cred_type.get(name=i['credential_type'])
        i['credential_type'] = vault['id']
        i['organization'] = org_id
        cred = cred_res.create(**i)

if tower.inventories:
    # create inventories
    print("\nCreating Inventories\n")
    for i in tower.inventories:
        #print(i)
        i['organization'] = org_id
        inv = inv_res.create(**i)
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
    # create projects 
    print("\nCreating Project: Playbooks {version} for BullSequana Edge\n")
    for p in tower.projects:
        #print(p)
        p['organization'] = org_id
        p['description'] = "Playbooks {version} for BullSequana Edge".format(version=os.environ.get('MISM_BULLSEQUANA_EDGE_VERSION'))
        project_res.create(**p)

if tower.job_templates:
    print("Waiting 30 seconds for projects to index.")
    print("Press any key to skip if you know what you're doing.")
    timeout = 30
    rlist, wlist, xlist = select([sys.stdin], [], [], timeout)
    # create job templates
    print("\nCreating Job Templates...\n")
    for j in tower.job_templates:
        print(j)
        inv = inv_res.get(name=j['inventory'])
        j['inventory'] = inv['id']
        project = project_res.get(name=j['project'])
        j['project'] = project['id']
        j['organization'] = org_id
        j['credential'] = cred['id']
        job_template_res.create(**j)

print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
print("What to do first ?")
print("See https://github.com/atosorigin/bullsequana-edge-system-management/tree/master/ansible")
print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")




