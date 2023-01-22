#!/bin/bash

#wget are not preinstalled on Mac

read -p '(You can run wihout sudo)Make sure that you are running this command in sudo? [y/n] :' ans
if [ "$ans" != "y" ]; then exit 1 ; fi

sudo apt-get install curl keepass2 vim-runtime vim-gui-common tree

#https://github.com/cli/cli/blob/trunk/docs/install_linux.md
read -p 'Do you want to install Git Cli? [y/n] :' ans
if [ "$ans" = "y" ]; then
	type -p curl >/dev/null || sudo apt install curl -y
	curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
	&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y
fi

read -p 'would you like to create TOMDEV var which points to website on github? [y/n] :' ans
if [ "$ans" = "y" ]; then
	echo 'TOMDEV="https://tomdev24.github.io"' >> $HOME/.bashrc 
fi

read -p 'would you like to set vimrc from git? [y/n] :' ans

if [ "$ans" = "y" ]; then
	curl https://tomdev24.github.io/newdist/vimrc --output $HOME/.vimrc
	#vim-plug installation
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim	
fi

read -p 'would you like to add snippets, ftplugin, plugin from git? [y/n] :' ans

if [ "$ans" = "y" ]; then
	curl https://tomdev24.github.io/newdist/ftplugin.tar --output ftplugin.tar
	curl https://tomdev24.github.io/newdist/plugin.tar --output plugin.tar
	curl https://tomdev24.github.io/newdist/snippets.tar --output snippets.tar
	
	tar -xvf ftplugin.tar -C $HOME/.vim
	tar -xvf plugin.tar -C $HOME/.vim
	tar -xvf snippets.tar -C $HOME/.vim
	rm ftplugin.tar plugin.tar snippets.tar
fi

echo '-------------'
echo 'Do not forget to get/generate token in github'
echo 'You can then run git config credential.helper store'
echo 'And after push repo with username and token'
echo 'But it will store your credentials in ~/.git-credentials so be careful!!!'
echo '-------------'

read -p 'add sh_scripts folder and add it to PATH variable? [y/n] :' ans

if [ "$ans" = "y" ]; then
	mkdir $HOME/sh_scripts
	echo 'export PATH=$PATH:~/sh_scripts' >> $HOME/.bashrc
fi

echo '\n-------------'
echo 'Install Vscode dont forget to add Vim plugin to it!'
echo '~/.config/Code/User  such a wonderful path by the way'
echo '-------------'

read -p 'add settings.json and keybindings.json to VSCode config? [y/n] :' ans
if [ "$ans" = "y" ]; then
	curl https://tomdev24.github.io/newdist/keybindings.json --output ~/.config/Code/User/keybindings.json 
	curl https://tomdev24.github.io/newdist/settings.json --output ~/.config/Code/User/settings.json 
fi

read -p 'Do you want to install and configure DropBox ? [y/n] :' ans
if [ "$ans" = "y" ]; then
	cd $HOME && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
	~/.dropbox-dist/dropboxd
	#wget https://linux.dropbox.com/packages/dropbox.py
fi

echo; echo;
echo 'Instal vimuim plugin to firefox'
echo 'Bookmarks in firefox Telegram/Google/Notion/Github'

#wajig large
#apt-get remove --purge package
#aptitude search '~i!~M'
#//How to run postgress
#sudo -u postgres -i
