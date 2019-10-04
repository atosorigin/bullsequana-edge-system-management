# coding: utf-8
#
# Atos BullSequana Edge Ansible Modules
# Version 2.0
# Copyright (C) 2019 Atos or its subsidiaries. All Rights Reserved.

# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
#
# See : https://github.com/ansible/ansible/blob/devel/lib/ansible/plugins/inventory/nmap.py

from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

ANSIBLE_METADATA = {'status': ['production'],
                    'supported_by': 'Bull Atos R&D',
                    'metadata_version': '2.0.0'}

DOCUMENTATION = '''
    name: redfish_plugin_ansible_inventory
    plugin_type: inventory
    version_added: "2.7"
    short_description: Uses python-nmap to find hosts to target
    description:
        - Uses a YAML configuration file with a valid YAML extension.
    extends_documentation_fragment:
      - inventory_cache
    requirements:
      - python-nmap CLI installed
    options:
        plugin:
            description: token that ensures this is a source file for the 'nmap' plugin.
            required: True
            choices: ['redfish_plugin_ansible_inventory']
        address:
            description: Network IP or range of IPs to scan, like simple range (10.2.2.15-25) or CIDR notation, in redfish_plugin_ansible_inventory.yml file.
            required: True
        port:
            description: port to scan
            default: 443
        exclude:
            description: list of addresses to exclude
            type: list
'''
EXAMPLES = '''
    # inventory.config file in YAML format
    plugin: redfish_plugin_inventory
    address: "192.168.31.[20-30]"
    port: "443"

    usage : from your playbook directory
    "ansible-playbook power/power_on.yml -i /usr/share/ansible/plugins/inventory/redfish_plugin_ansible_inventory.yml"
'''

import os
import re

import nmap
import requests
import json
import urllib3
from requests.packages.urllib3.exceptions import InsecureRequestWarning

from ansible import constants as C
from ansible.errors import AnsibleParserError
from ansible.module_utils._text import to_native
from ansible.plugins.inventory import BaseInventoryPlugin, Constructable, Cacheable

class InventoryModule(BaseInventoryPlugin, Constructable, Cacheable):

    NAME = 'redfish_plugin_ansible_inventory'

    def verify_file(self, path):
        # Check Yaml extension           
        valid = False
        if super(InventoryModule, self).verify_file(path):
            _, ext = os.path.splitext(path)
            if not ext or ext in C.YAML_FILENAME_EXTENSIONS:
                valid = True
        return valid

    def parse(self, inventory, loader, path, cache=True):
        try:
            urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
            super(InventoryModule, self).parse(inventory, loader, path, cache=cache)
            cache_key = self.get_cache_key(path)
            self._read_config_data(path)
            source_data = None
            if cache:
                cache = self.get_option('cache')

            update_cache = False
            if cache:
                try:
                    source_data = self._cache[cache_key]
                except KeyError:
                    update_cache = True             
            using_current_cache = cache and not update_cache
            cacheable_results = self._populate_from_source(source_data, using_current_cache)

            if update_cache:
                self._cache[cache_key] = cacheable_results            
        except Exception as e:
            raise AnsibleParserError("failed to parse %s: %s " % (to_native(path), to_native(e)))            
            
    def _populate_from_source(self, source_data, using_current_cache):
        """
        Populate inventory data from direct source
        """
        if using_current_cache:
            self._populate_from_cache(source_data)
            return source_data

        cacheable_results = [] 
        hostvars = {}
        nmap_port_scanner = nmap.PortScanner()
        result = nmap_port_scanner.scan('{address}'.format(address = self.get_option('address')), '{port}'.format(port = self.get_option('port')))  # Careful : address / port type=AnsibleUnicode, so do NOT use option directly as a string 
        for ip_address in result['scan']:
            try:
                requests.get('https://{ip_address}/redfish/v1'.format(ip_address=ip_address), verify=False)
                self.inventory.add_host(ip_address)
                self.inventory.add_group("mipocket")
                self.inventory.set_variable(ip_address, 'baseuri', ip_address)
                self.inventory.set_variable(ip_address, 'username', '<here is a user>')
                self.inventory.set_variable(ip_address, 'password', '<here is a password>')
                cacheable_results.append(ip_address)
                hostvars[ip_address] = { "baseuri": ip_address, "username": "<here your username>", "password": "<here your password>" } 
            except:
                pass # Nothing : just not a redfish url
        return { "mipocket": { "hosts": cacheable_results }, "_meta": { "hostvars": hostvars } ,"all": { "children": [ "mipocket" ]}, } 

    def _populate_from_cache(self, source_data):
        """
        Populate inventory from cache
        """
        hosts = source_data["mipocket"]["hosts"]
        for host in hosts:
            self.inventory.add_host(host)
	
        self.inventory.add_group("mipocket")

        hostvars = source_data["_meta"]["hostvars"]
        for host_ip, variables in hostvars.items():
            for key, variable in variables.items():
                self.inventory.set_variable(host_ip, key, variable)
