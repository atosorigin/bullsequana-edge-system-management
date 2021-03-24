#!/bin/bash

unset $mism_version 

echo "------------------------------------------------------------------------------------------------"
echo "Use this script only if you have NO connnection to internet and python 2.7.5+> already installed"
echo -e "\033[31mIt is delivered as is and has NO WARRANTY\033[0m"
echo "------------------------------------------------------------------------------------------------"

read -p "Would you like to install BullSequana Edge ansible prerequisites [y/n] ? " yn

if [ ! "$yn" == "y" ]
then
  exit -1
fi

#cd prerequisites
#unzip setuptools-44.0.0.zip
#cd setuptools-44.0.0
#python setup.py install
#cd ../..
#rm -rf prerequisites/setuptools-44.0.0

cd prerequisites
tar -xzvf tzlocal-2.0.0.tar.gz
cd tzlocal-2.0.0
python setup.py install
cd ../..
rm -rf prerequisites/tzlocal-2.0.0

cd prerequisites
tar -xzvf pip-19.3.1.tar.gz
cd pip-19.3.1
python setup.py install
cd ../..
rm -rf prerequisites/pip-19.3.1

cd prerequisites
tar -xzvf Jinja2-2.10.3.tar.gz
cd Jinja2-2.10.3
python setup.py install
cd ../..
rm -rf prerequisites/Jinja2-2.10.3

cd prerequisites
tar -xzvf MarkupSafe-1.1.1.tar.gz
cd MarkupSafe-1.1.1
python setup.py install
cd ../..
rm -rf prerequisites/MarkupSafe-1.1.1

cd prerequisites
tar -xvzf ansible-2.9.2.tar.gz
cd ansible-2.9.2
python setup.py install
cd ../..
rm -rf prerequisites/ansible-2.9.2

cd prerequisites
tar -xvzf ansible-vault-1.2.0.tar.gz
cd ansible-vault-1.2.0
python setup.py install
cd ../..
rm -rf prerequisites/ansible-vault-1.2.0

echo "prerequisites successfully installed"