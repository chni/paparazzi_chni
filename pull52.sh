#!/bin/bash

if [ $# == 0 ]
then
	echo "usage \"./pull52.sh <targetdir>\" (./pull52.sh ../52/)"
else
	if [ -z `dpkg -l | grep paparazzi-dev | cut -c5-17` ]
	then	
		read -p"It seems like you don't have the build-dependencies for paparazzi installed. Do you want me to fix this (y/n)? " response
	        if [ "$response" == "y" ]; then
        	        echo "installing ..."
			sudo add-apt-repository -y ppa:paparazzi-uav/ppa && sudo add-apt-repository -y ppa:terry.guo/gcc-arm-embedded && sudo apt-get update && sudo apt-get -f -y install paparazzi-dev gcc-arm-none-eabi
			echo ""
			echo "I'm going to update the udev rules, to make the radiomodem and other stuff working, without root permissions."
			echo ""
			echo "Please unplug the radiomodem and your autopilot from the PC!"
			echo ""
			read -p"Press [ENTER]" response
			sudo cp udev/* /etc/udev/rules.d/
			sudo service udev restart
		else
			echo "terminating without installation"
			exit
		fi
	fi

	
	git clone https://github.com/paparazzi/paparazzi.git $1
	origin=`pwd`
	cd $1
	git reset --hard "v5.2.0_stable"	

	read -p"do you want me to patch your Paparazzi (y/n)? " response

	if [ "$response" == "y" ]; then
		cd $origin
		$origin/install.sh $1/
	else
		exit
	fi
	
	read -p"do you want be to compile it for you (should this fail in sw/ext, hit ctrl+c) (y/n)? " response
	
	if [ "$response" == "y" ]; then
	        cd $origin
	        cd $1
		. ENV
		make
	else 
		exit
	fi
fi


#git clone https://github.com/paparazzi/paparazzi.git $1
