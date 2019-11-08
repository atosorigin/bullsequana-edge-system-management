#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import tarfile

def get_manifest(path):
    manifest_keys = {} 
    if path.endswith('.tar'):
        with tarfile.open(name=path, mode='r') as tarf:
            fmanifest = tarf.extractfile("MANIFEST")
            manifest = fmanifest.readlines()
            type_manif =  type(manifest)
            for item in manifest:
                item = item
                print(item)
                key, val = item.decode("utf-8").split("=", 1)
                manifest_keys[key] = val.replace('\n','')
    
    if path.endswith('.tar.gz'):
        with tarfile.open(name=path, mode='r') as tarf:
            fmanifest = tarf.extractfile("MANIFEST")
            manifest = fmanifest.readlines()
            type_manif =  type(manifest)
            for item in manifest:
                item = item
                print(item)
                key, val = item.decode("utf-8").split("=", 1)
                manifest_keys[key] = val.replace('\n','')

#    if path.endswith('.gz'):
#        with ZipFile(path) as zipf:            
#            fmanifest = zipf.extract("MANIFEST")
#            manifest = fmanifest.readlines()
#            for item in manifest:
#                key, val = item.split("=", 1)
#                manifest_keys[key] = val
    return manifest_keys

def main():
    get_manifest('/mnt/BIOS_SKD080.13.06.007.tar.gz')
    get_manifest('/mnt/OMF_MIPCS_1400_0162.tar')

if __name__ == '__main__':
    main()
