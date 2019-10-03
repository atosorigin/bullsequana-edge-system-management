#!/usr/bin/env python
# -*- coding: utf-8 -*-

ANSIBLE_METADATA = {'status': ['preview'],
                    'supported_by': 'community',
                    'metadata_version': '1.1'}

DOCUMENTATION = """
module: atos_redfish
version_added: "2.3"
short_description: Out-Of-Band management using Redfish APIs for Atos
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
  baseuri:
    required: true
    default: None
    description:
      - Base URI of OOB controller
  username:
    required: false
    default: root
    description:
      - User for authentication with OOB controller
  password:
    required: false
    default: calvin
    description:
      - Password for authentication with OOB controller
  hostname:
    required: false
    default: None
    description:
      - server name to add to filename when exporting SCP file
  technical_state_path:
    required: false
    default: /tmp/TechnicalState.xml
    description:
      - absolute technical state xml file path which is used to evaluate firmware availability

  firmware_inventory_installed:
    required: false - true for Simple Update
    default: None
    description:
      - the firmware inventory from redfish_facts / GetFirmwareInventory

author: "francine.sauvage@atos.net", github: francine-sauvage
"""

import os
import requests
import json
#from requests.packages.urllib3.exceptions import InsecureRequestWarning
from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils.atos_redfish_utils import AtosRedfishUtils
#from atos_redfish_utils import AtosRedfishUtils

def run_module():
    result = {}
    module = AnsibleModule(
        argument_spec = dict(
            category   = dict(required=True, type='str', default=None),
            command    = dict(required=True, type='str', default=None),
            baseuri    = dict(required=True, type='str', default=None),
            username   = dict(required=False, type='str', default='root'),
            password   = dict(required=False, type='str', default='sdd@atos', no_log=True),
	        technical_state_path = dict(required=False, type='str', default='/tmp/TechnicalState.xml'),
            firmware_inventory_installed = dict(required=False, type='dict', default=None)
        ),
        supports_check_mode=False
    )

    category   = module.params['category']
    command    = module.params['command']

    creds = { 'username': module.params['username'],'password': module.params['password'] }
    # Build root URI
    root_uri = "https://{baseuri}".format(baseuri=module.params['baseuri'])
    atos_rf_utils = AtosRedfishUtils(creds, root_uri)
    # Specific to Atos
    if category == "Update":
        result = { 'ret': False, 'msg': 'Invalid Command'}
        if command == "EvaluateFirmwareUpgrade":
            if not module.params['technical_state_path']:
                return { 'ret': False, 'msg': 'technical_state_path parameter: empty'}
            if not module.params['firmware_inventory_installed']:
                return { 'ret': False, 'msg': 'firmware_inventory_installed parameter empty'}
            result = atos_rf_utils.evaluate_firmware_upgrade(module.params['technical_state_path'], module.params['firmware_inventory_installed'])
    else:
        result = { 'ret': False, 'msg': 'Invalid Category'}

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