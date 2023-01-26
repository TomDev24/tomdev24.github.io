#!/bin/bash

read -p '(You can run wihout sudo)Make sure that you are running this command in sudo? [y/n] :' ans
if [ "$ans" != "y" ]; then exit 1 ; fi

echo "Installing python3-pip if its not installed"; echo;
sudo apt install python3-pip
sudo pip3 install virtualenvwrapper

echo >> $HOME/.bashrc
echo 'export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3' >> $HOME/.bashrc
echo 'export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv' >> $HOME/.bashrc
echo 'source /usr/local/bin/virtualenvwrapper.sh' >> $HOME/.bashrc

