from distutils.core import setup

def readme():
    with open('README.md') as f:
        return f.read()

setup(name='atos mipm openbmc for zabbix template',
      version='1.0',
      description='atos mipm openbmc for zabbix template',
      long_description=readme(),
      classifiers=[
        'Development Status :: 1 - Release',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 3.6',
        'Topic :: Text Processing :: Linguistic',
      ],
      keywords='atos mipm openbmc for zabbix template',
      url='http://atos.net',
      author='Francine Sauvage',
      author_email='francine.sauvage@atos.net',
      license='Copyright Atos',
      scripts=['openbmc_collect']
      )