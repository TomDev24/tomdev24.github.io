#!/bin/bash

#wget are not preinstalled on Mac

read -p 'would you like to create TOMDEV var which points to website on github? [y/n] :' ans
if [ "$ans" = "y" ]; then
	echo 'TOMDEV="https://tomdev24.github.io"' >> $HOME/.bashrc 
fi

read -p 'would you like to set vimrc from git? [y/n] :' ans

if [ "$ans" = "y" ]; then
	curl https://tomdev24.github.io/media/newdist/vimrc --output $HOME/.vimrc
	#vim-plug installation
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim	
fi

read -p 'would you like to add snippets, ftplugin, plugin from git? [y/n] :' ans

if [ "$ans" = "y" ]; then
	curl https://tomdev24.github.io/media/newdist/ftplugin.tar --output ftplugin.tar
	curl https://tomdev24.github.io/media/newdist/plugin.tar --output plugin.tar
	curl https://tomdev24.github.io/media/newdist/snippets.tar --output snippets.tar
	
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
echo 'Now i will put settigns.json and keybindings.json, for better terminal in vscode'
echo; echo; 
curl https://tomdev24.github.io/media/newdist/keybindings.json --output ~/.config/Code/User/keybindings.json 
curl https://tomdev24.github.io/media/newdist/settings.json --output ~/.config/Code/User/settings.json 
echo '-------------'

#wajig large
#apt-get remove --purge package
#aptitude search '~i!~M'
#//How to run postgress
#sudo -u postgres -i
