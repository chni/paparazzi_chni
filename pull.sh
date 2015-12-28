#!/bin/bash

if [ $# == 0 ]
then
	echo "usage \"./pull.sh <targetdir>\" (./pull.sh ../paparazzi_dir/)"
else
	if [ -z `dpkg -l | grep paparazzi-dev | cut -c5-17` ]
	then	
		read -p"It seems like you don't have the build-dependencies for paparazzi installed. Do you want me to fix this (y/n)? " response
	        if [ "$response" == "y" ]; then
        	        echo "installing ..."
			sudo add-apt-repository -y ppa:paparazzi-uav/ppa && sudo add-apt-repository -y ppa:terry.guo/gcc-arm-embedded && sudo apt-get update && sudo apt-get -f -y install paparazzi-dev gcc-arm-none-eabi paparazzi-jsbsim joystick jstest-gtk
			echo ""
			echo "I'm going to update the udev rules, to make the radiomodem and other stuff working, without root permissions."
			echo ""
			echo "Please unplug the radiomodem and your autopilot from the PC!"
			echo ""
			read -p"Press [ENTER]" response
			sudo cp udev/* /etc/udev/rules.d/
			sudo service udev restart
			sudo cp joystick.state /var/lib/joystick/joystick.state
			echo "installed joystick-mapping, you might have to run \"sudo jstest-gtk\" once to make the joystick work."
			echo "configuring git shortcuts..."
			git config --global color.ui auto     # colors for all
			git config --global alias.st status   # make `git st` work
			git config --global alias.co checkout # make `git co` work
			git config --global alias.ci commit   # make `git ci` work
			git config --global alias.br branch   # make `git br` work
			git config --global alias.up "pull --rebase"   # make `git up` work similar to svn up
			git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
		else
			echo "terminating without installation"
			exit
		fi
	fi

        read -p "Do you want to install Paparazzi 5.2 stable (1) or 5.4.2 stable (2)? or 5.6 stable (3) or 5.8 stable (4)" response

        if [ "$response" == "1" ]; then
                version="52"
        elif [ "$response" == "2" ]; then
		version="54"
        elif [ "$response" == "3" ]; then
                version="56"
        elif [ "$response" == "4" ]; then
                version="58"
	else
                exit
        fi

	if [ "$version" == "52" ]; then
	
		git clone https://github.com/paparazzi/paparazzi.git $1
		origin=`pwd`
		cd $1
		git reset --hard "v5.2.0_stable"	
	fi

        if [ "$version" == "54" ]; then
        
                git clone https://github.com/paparazzi/paparazzi.git $1
                origin=`pwd`
                cd $1
                git reset --hard "v5.4.2_stable"
        fi

        if [ "$version" == "56" ]; then

                git clone https://github.com/paparazzi/paparazzi.git $1
                origin=`pwd`
                cd $1
                git reset --hard "v5.6_stable"
        fi

        if [ "$version" == "58" ]; then

                git clone https://github.com/paparazzi/paparazzi.git $1
                origin=`pwd`
                cd $1
                git reset --hard "v5.8_stable"
        fi

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
		cd sw/ground_segment/lpc21iap
		make
		cd $origin 
		cd $1
		. ENV
		make
	else 
		exit
	fi
fi


#git clone https://github.com/paparazzi/paparazzi.git $1
