#!/bin/bash

if [ $# == 0 ]
then
	echo "usage \"./pull52.sh <targetdir>\" (./pull52.sh ../52/)"
else
	git clone https://github.com/paparazzi/paparazzi.git $1
	origin=`pwd`
	cd $1
	git reset --hard "v5.2.0_stable"	
fi

read -p"do you want be to patch your Paparazzi (y/n)? " response

if [ "$response" == "y" ]; then
	cd $origin
	$origin/install.sh $1
fi

read -p"do you want be to compile it for you (y/n)? " response

if [ "$response" == "y" ]; then
        cd $origin
        cd $1
	. ENV
	make
fi


#git clone https://github.com/paparazzi/paparazzi.git $1
