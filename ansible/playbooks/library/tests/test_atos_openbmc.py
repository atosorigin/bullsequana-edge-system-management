# This test is based around pytest's features for individual test functions
import pytest
import json
import atos_openbmc as atos_openbmc_module
from ansible.module_utils import basic
from ansible.module_utils._text import to_bytes

def test_main_function(monkeypatch):
    monkeypatch.setattr(atos_openbmc_module.AnsibleModule, "exit_json", fake_exit_json)
    set_module_args({
        'category': 'Update',
        'command': 'EvaluateFirmwareUpdate',
        'technical_state_path': '/tmp',
        'firmwares': {  
            "/xyz/openbmc_project/software/282c4ba7": {
                "Activation": "xyz.openbmc_project.Software.Activation.Activations.Active",
                "Path": "/tmp/images/282c4ba7",
                "Priority": 0,
                "Purpose": "xyz.openbmc_project.Software.Version.VersionPurpose.BMC",
                "RequestedActivation": "xyz.openbmc_project.Software.Activation.RequestedActivations.None",
                "Version": "09.00.0078",
                "associations": [
                    [
                        "inventory",
                        "activation",
                        ""
                    ]
                ]
            },
            "/xyz/openbmc_project/software/282c4ba7/inventory": {
                "endpoints": [
                    ""
                ]
            },
            "/xyz/openbmc_project/software/282c4ba7/software_version": {
                "endpoints": [
                    "/xyz/openbmc_project/software"
                ]
            },
            "/xyz/openbmc_project/software/3d7c13ec": {
                "Activation": "xyz.openbmc_project.Software.Activation.Activations.Active",
                "Path": "/tmp/images/3d7c13ec",
                "Purpose": "xyz.openbmc_project.Software.Version.VersionPurpose.Host",
                "RequestedActivation": "xyz.openbmc_project.Software.Activation.RequestedActivations.None",
                "Version": "BIOS_SKD080.13.01.001",
                "associations": [
                    [
                        "inventory",
                        "activation",
                    ]
                ]
            },
            "/xyz/openbmc_project/software/3d7c13ec/inventory": {
                "endpoints": [
                    "/xyz/openbmc_project/inventory/system/chassis"
                ]
            },
            "/xyz/openbmc_project/software/active": {
                "endpoints": [
                    "/xyz/openbmc_project/software/282c4ba7",
                    "/xyz/openbmc_project/software/3d7c13ec"
                ]
            },
            "/xyz/openbmc_project/software/functional": {
                "endpoints": [
                    "/xyz/openbmc_project/software/282c4ba7"
                ]
            }
        }
    })
    atos_openbmc_module.main()

def set_module_args(args):
    if '_ansible_remote_tmp' not in args:
        args['_ansible_remote_tmp'] = '/tmp'
    if '_ansible_keep_remote_files' not in args:
        args['_ansible_keep_remote_files'] = False

    args = json.dumps({'ANSIBLE_MODULE_ARGS': args})
    basic._ANSIBLE_ARGS = to_bytes(args)


def fake_exit_json(*args, **kwargs):
    """function to patch over exit_json; package return data into an exception"""
    if 'changed' not in kwargs:
        kwargs['changed'] = False
