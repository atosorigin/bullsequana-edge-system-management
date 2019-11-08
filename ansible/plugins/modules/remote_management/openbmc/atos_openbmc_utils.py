# -*- coding: utf-8 -*-
#
# Atos BullSequana Edge Ansible Modules
# Version 2.0
# Copyright (C) 2019 Atos or its subsidiaries. All Rights Reserved.

# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
#

import os
import requests
import json
import re
import xml.etree.ElementTree as ET
import tarfile
#from zipfile import ZipFile
from distutils.version import LooseVersion
from datetime import datetime

HEADERS = {'content-type': 'application/json'}

class AtosOpenbmcUtils(object):

    def __init__(self):
        pass

    # This function compares the firmware levels in the system vs. the firmware levels
    # available in the TS file
    def evaluate_firmware_upgrade(self, catalog_file, firmwares ):
        firmware_available = {'ret':True, 'Firmwares':[]}
        # read catalog file
        tree = ET.parse(catalog_file+'/Resources/TechnicalState.xml')
        root = tree.getroot()
        repo = catalog_file + '/' + root.findtext('TS_INFO/FW_REPOSITORY')
        functional = firmwares["/xyz/openbmc_project/software/functional"]
        # type_firmwares = type(firmwares)
        endpoints = functional["endpoints"]
        for firmware_technical_state in root.findall('./FW_LIST/FW'):
            path = firmware_technical_state.find('PATH').text
            available_file = firmware_technical_state.find('FILE').text
            manifest_keys = get_manifest(repo+'/'+path+'/'+available_file)            
            if not manifest_keys:
                continue
            found_purpose = False
            for endpoint in endpoints:
                active_firmware = firmwares[endpoint]
                inventory_purpose = active_firmware["Purpose"] 
                inventory_version = active_firmware["Version"]
                manifest_purpose = manifest_keys['purpose']
                manifest_version = manifest_keys['version']
                # if exclude_if_ready(firmwares, manifest_purpose, manifest_version):
                #    found_purpose = True
                #    continue
                # name = firmware_technical_state.find('NAME').text
                # version = firmware_technical_state.find('VERSION').text
                if manifest_purpose == inventory_purpose:
                    found_purpose = True
                    if manifest_version != inventory_version:
                        # firmware needs to be added : same purpose found and diff version 
                        firmware_available['Firmwares'].append({ 'name': manifest_purpose, 'version': manifest_version, 'path': repo+'/'+path, 'file': available_file })
            if not found_purpose:
                # firmware needs to be added : no purpose found
                firmware_available['Firmwares'].append({ 'name': manifest_purpose, 'version': manifest_version, 'path': repo+'/'+path, 'file': available_file })

        return firmware_available
# not excluded because bad upload could happened => wiser to re-upload it
# def exclude_if_ready(firmwares, purpose, version):
#     for _, firmware  in firmwares.items():
#         entry_activation = firmware.get("Activation", None)
#         if not entry_activation:
#             continue
#         entry_purpose = firmware.get("Purpose", None)
#         entry_version = firmware.get("Version", None)
#         entry_requested_activation = firmware.get("RequestedActivation", None)
#         if entry_purpose == purpose and entry_version == version \
#           and entry_requested_activation == 'xyz.openbmc_project.Software.Activation.RequestedActivations.Active' \
#           and entry_activation == 'xyz.openbmc_project.Software.Activation.Activations.Active' :
#             # The same image already exists and is active
#             # => Exclude it
#             return True
#         if entry_purpose == purpose and entry_version == version \
#           and entry_requested_activation == 'xyz.openbmc_project.Software.Activation.RequestedActivations.None' \
#           and entry_activation == 'xyz.openbmc_project.Software.Activation.Activations.Ready' :
#            # The same image already exists and is active
#             return True
#     return False


def get_manifest(path):
    manifest_keys = {} 
    if path.endswith('.tar') or path.endswith('.tar.gz'):
        with tarfile.open(name=path, mode='r') as tarf:
            fmanifest = tarf.extractfile("MANIFEST")
            manifest = fmanifest.readlines()
            for item in manifest:
                key, val = item.decode("utf-8").split("=", 1)
                manifest_keys[key] = val.replace('\n','')

#    if path.endswith('gz'):
#        with  ZipFile(path) as zipf:            
#            fmanifest = zipf.extract("MANIFEST")
#            manifest = fmanifest.readlines()
#            for item in manifest:
#                key, val = item.split("=", 1)
#                manifest_keys[key] = val
    return manifest_keys

