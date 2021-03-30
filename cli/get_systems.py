#!/usr/bin/python3
#-*- coding: utf-8 -*-

import requests
import json
import sys
import re
import time
from sushy_conf import args, log
import sushy
from sushy import auth

#from datetime import datetime

sushy_auth = auth.SessionAuth(username=args.username, password=args.password)
s = sushy.Sushy('https://{ip}:{port}/redfish/v1/'.format(ip=args.ip, port=args.port), 
        auth=sushy_auth, verify=args.verify, noproxy=args.noproxy)

### Run code

if __name__ == "__main__":
    server = s.get_system('/redfish/v1/Systems/Server')
    print(server)
