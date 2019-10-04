#
# Atos BullSequana Edge Zabbix Template
# Version 2.0
# Copyright (C) 2019 Atos or its subsidiaries. All Rights Reserved.

# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
#
# 
# from distutils.core import setup

def readme():
    with open('README.md') as f:
        return f.read()

setup(name='atos BullSequana Edge for zabbix template',
      version='1.0',
      description='atos BullSequana Edge for zabbix template',
      long_description=readme(),
      classifiers=[
        'Development Status :: 1 - Release',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 3.6',
        'Topic :: Text Processing :: Linguistic',
      ],
      keywords='atos BullSequana Edge for zabbix template',
      url='http://atos.net',
      author='Francine Sauvage',
      author_email='francine.sauvage@atos.net',
      license='Copyright Atos',
      scripts=['openbmc_collect']
      )