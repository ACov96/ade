#!/bin/bash

echo "This script will proceed to install ADE. This could remove or overwrite existing files, such as ~/.local/scripts/, ~/.xinitrc, ~/.bashrc, and other files that can affect your system's functionality."

read -r -p "Do you want to continue? (y/n) " answer
case "$answer" in
	[Yy]* )
		echo "Proceeding with install..."
		;;
	* )
		echo "Aborting..."
		exit 0
		;;
esac

if [ -e "$HOME/.local/scripts" ]; then
	rm -rf $HOME/.local/scripts
fi

ln -s $(pwd)/src $HOME/.local/scripts

sudo ./src/build_external.sh
