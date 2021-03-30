#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import requests
import json
import re
import xml.etree.ElementTree as ET
from distutils.version import LooseVersion
from datetime import datetime

HEADERS = {'content-type': 'application/json'}

class AtosRedfishUtils(object):

    def __init__(self, creds, root_uri):
        self.root_uri = root_uri
        self.creds = creds
        self._init_session()
        self.default_system_id = None
        self.default_chassis_id = None
        self.default_manager_id = None
        return

    def send_get_request(self, uri):
        headers = {}
        if 'token' in self.creds:
            headers = {"X-Auth-Token": self.creds['token']}
        try:
            response = requests.get(uri, headers, verify=False, auth=(self.creds['user'], self.creds['pswd']))
        except:
            raise
        return response
 
    def send_post_request(self, uri, pyld, hdrs, fileName=None):
        headers = {}
        if 'token' in self.creds:
            headers = {"X-Auth-Token": self.creds['token']}
        try:
            response = requests.post(uri, data=json.dumps(pyld), headers=hdrs, files=fileName,
                               verify=False, auth=(self.creds['user'], self.creds['pswd']))
        except:
            raise
        return response

    def send_patch_request(self, uri, pyld, hdrs):
        headers = {}
        if 'token' in self.creds:
            headers = {"X-Auth-Token": self.creds['token']}
        try:
            response = requests.patch(uri, data=json.dumps(pyld), headers=hdrs,
                               verify=False, auth=(self.creds['user'], self.creds['pswd']))
        except:
            raise
        return response

    def send_delete_request(self, uri, pyld, hdrs):
        headers = {}
        if 'token' in self.creds:
            headers = {"X-Auth-Token": self.creds['token']}
        try:
            response = requests.delete(uri, verify=False, auth=(self.creds['user'], self.creds['pswd']))
        except:
            raise
        return response

    def _init_session(self):
        pass
  
    # This function compares the firmware levels in the system vs. the firmware levels
    # available in the Catalog.gz file that it downloaded from ftp.dell.com
    def evaluate_firmware_upgrade(self, catalog_file, model):
        fw = []
        fw_list = {'ret':True, 'Firmwares':[]}
 
        response = self.send_get_request(self.root_uri + "UpdateService/FirmwareInventory/")
        if response.status_code == 400:
            return { 'ret': False, 'msg': 'Not supported on this platform'}
 
        elif response.status_code == 200:
            data = response.json()
 
            for i in data['Members']:
                if 'Installed' in i['@odata.id']:
                    fw.append(i['@odata.id'])
 
            # read catalog file
            tree = ET.parse(catalog_file)
            root = tree.getroot()
            for inv in fw:
                ver = inv.split('-')[1]
                version = '0'
                path = ""
                for i in root.findall('.//Category/..'):
                    for m in i.findall('.//SupportedDevices/Device'):
                        if m.attrib['componentID'] == ver:
                            for nx in i.findall('.//SupportedSystems/Brand/Model/Display'):
                                if nx.text == model:
                                    if LooseVersion(i.attrib['vendorVersion']) > LooseVersion(version):
                                        version = i.attrib['vendorVersion']
                                        path = i.attrib['path']
 
                if path != "":
                    fw_list['Firmwares'].append({ 'curr':'%s' % os.path.basename(inv).replace('Installed-%s-'%ver,''), 'latest':'%s' % version, 'path':'%s' % path })
        else:
            fw_list['ret'] = False
        return fw_list

    def upload_firmware(self, FWPath):
        result = {}
        response = self.send_get_request(self.root_uri + "UpdateService/FirmwareInventory/")

        if response.status_code == 400:
            return { 'ret': False, 'msg': 'Not supported on this platform'}
        elif response.status_code == 200:
            ETag = response.headers['ETag']
        else:
            result = { 'ret': False, 'msg': 'Failed to get update service etag %s' % str(self.root_uri)}
            return result

        files = {'file': (os.path.basename(FWPath), open(FWPath, 'rb'), 'multipart/form-data')}
        headers = {"if-match": ETag}

        # Calling POST directly
        response = requests.post(self.root_uri + "UpdateService/FirmwareInventory/", files=files, auth=(self.creds['user'], self.creds['pswd']), headers=headers, verify=False)
        if response.status_code == 201:
            result = { 'ret': True, 'msg': 'Firmare uploaded successfully', 'Version': '%s' % str(response.json()['Version']), 'Location':'%s' % response.headers['Location']}
        else:
            result = { 'ret': False, 'msg': 'Error uploading firmware; status_code=%s' % response.status_code }
        return result
 
    def schedule_firmware_update(self, uri, InstallOption):
        fw = []
        response = self.send_get_request(self.root_uri + "UpdateService/FirmwareInventory/")
 
        if response.status_code == 200:
            data = response.json()
            for i in data[u'Members']:
                if 'Available' in i[u'@odata.id']:
                    fw.append(i[u'@odata.id'])
        else:
            return { 'ret': False, 'msg': 'Error getting firmware inventory; Error code %s' % response.status_code }

        payload = { "SoftwareIdentityURIs":fw, "InstallUpon":InstallOption }
        #return { 'ret': False, 'msg': payload }
        response = self.send_post_request(self.root_uri + "UpdateService/" + uri, payload, HEADERS)
 
        if response.status_code == 202:
            result = { 'ret': True, 'msg': 'Firmware install job accepted' }
        else:
            result = { 'ret': False, 'msg': "Error code %s" % response.status_code }
        return result
    def get_server_model(self):
        result = {}
        response = self.send_get_request(self.root_uri + "Systems/")
        if response.status_code == 200:		# success
            result['ret'] = True
            data = response.json()
            return data[u'Model']
        else:
            return "Error"
