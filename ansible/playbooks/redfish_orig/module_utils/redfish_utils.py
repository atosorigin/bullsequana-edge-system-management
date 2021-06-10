#!/usr/bin/env python
# _*_ coding: utf-8 _*_

# Copyright © 2017-2018 Dell Inc.
#
# This script installs the Ansible modules to their default location.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import os
import sys
import json

try:
    import ansible
except ImportError:
    print ("Error: Ansible is not installed")
    sys.exit(1)

def main():
    result = {} 
    result['hello'] = 'Hello World'
    result['twice'] = 'Hello World'
    print(result)

if __name__ == '__main__':
    main()