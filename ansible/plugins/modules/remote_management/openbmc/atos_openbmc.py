#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Atos BullSequana Edge Ansible Modules
# Version 2.0
# Copyright (C) 2019 Atos or its subsidiaries. All Rights Reserved.

# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
#

ANSIBLE_METADATA = {'status': ['production'],
                    'supported_by': 'Bull Atos R&D',
                    'metadata_version': '2.0.0'}

DOCUMENTATION = '''
---
    module: atos_openbmc
    version_added: "2.7"
    short_description: Out-Of-Band management using OpenBMC RESTFul API for Atos
    author: email=francine.sauvage@atos.net, github=francine-sauvage
    description:
        - Uses a YAML configuration file with a valid YAML extension.
    options:
      category:
        required: true
        default: None
        description:
          - Action category to execute on server
      command:
        required: true
        default: None
        description:
          - Command to execute on server
      technical_state_path:
        required: true
        default: mnt on host
        description:
          - mount path to technical state xml files which is used to evaluate firmware availability
      firmwares:
        required: true
        default: None
        description:
          - software inventory from remote OpenBMC
'''
EXAMPLES = '''
    in a playbook
    - name: load functional firmwares from Technical State xml file
      local_action: atos_openbmc technical_state_path={{ technical_state_path }} category=Update command=EvaluateFirmwareUpdate firmwares={{ firmware_inventory }}
'''
import os
import requests
import json
from ansible.module_utils.basic import AnsibleModule
# on host:
from ansible.module_utils.atos_openbmc_utils import AtosOpenbmcUtils
#from atos_openbmc_utils import AtosOpenbmcUtils

def run_module():
    result = { 'ret': False, 'msg': 'Invalid Category'}
    module = AnsibleModule(
        argument_spec = dict(
          category   = dict(required=True, type='str', default=None),
          command    = dict(required=True, type='str', default=None),
	        technical_state_path = dict(required=False, type='str', default='/host/mnt'),
          firmwares = dict(required=True, type='dict')
        ),
        supports_check_mode=False
    )

    category   = module.params['category']

    # Specific to Atos
    if category == "Update":
        result = { 'ret': False, 'msg': 'Invalid Command'}
        command    = module.params['command']
        if command == "EvaluateFirmwareUpdate":
            atos_obmc_utils = AtosOpenbmcUtils()            
            if not module.params['technical_state_path']:
                return { 'ret': False, 'msg': 'technical_state_path parameter: empty'}
            if not module.params['firmwares']:
                return { 'ret': False, 'msg': 'firmwares parameter: empty'}
            result = atos_obmc_utils.evaluate_firmware_upgrade(module.params['technical_state_path'], module.params['firmwares'])

    # Return data back or fail with proper message
    if result['ret'] == True:
        del result['ret']		# Don't want to pass this back
        module.exit_json(result=result)
    else:
        module.fail_json(msg=result['msg'])

def main():
    run_module()

if __name__ == '__main__':
    main()
