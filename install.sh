files="
conf/control_panel.xml
conf/simulator/jsbsim/aircraft/reset_ristedt.xml
conf/radios/mc15_CHNI.xml
conf/joystick/saitek_p1500.xml
conf/settings/control/ctl_airspeed.xml
conf/flight_plans/rotorcraft_stieglitz.xml
conf/flight_plans/rotorcraft_scharbeutz.xml
conf/flight_plans/rotorcraft_finkenwerder.xml
conf/flight_plans/versatile_stieglitz.xml
conf/flight_plans/versatile_stieglitz_ftc.xml
conf/flight_plans/versatile_hainmuehlen_ftc.xml
conf/flight_plans/rotorcraft_hainmuehlen.xml
conf/airframes/hbmini_chni.xml
conf/airframes/Up2U_tuhh.xml
conf/airframes/katana_tuhh.xml
conf/airframes/x8_chni.xml
conf/airframes/ardrone2_chni.xml
conf/gcs/horizontal.xml
conf/radios/TGY9x_jeti.xml
ENV
sw/airborne/boards/twog_1.0.h
sw/airborne/boards/tiny_2.1.h
sw/airborne/modules/sonar/sonar_pwm.h
sw/airborne/modules/sonar/sonar_pwm.c
conf/modules/sonar_pwm.xml
"

echo "######################################################"
echo "# Welcome to the config-install-script!              #"
echo "#                                                    #"
echo "# usage is ./install <PPRZ-DIR> [-r]                 #"
echo "#                                                    #"
echo "# where -r means reverse, to get changes back to git #"
echo "#                                                    #"
echo "######################################################"

echo 

if [ $# -eq 0 ] || [ $# -gt 2 ] 
then 
	echo "wrong number of arguments, see usage!"
	echo 
	exit 255
fi

if [ $# -eq 2 ] && [ "$2" != "-r" ]
then
	echo "there is a second argument, but it isn't -r, I'm not sure what you want"
	echo
	exit 255 
fi

if [ -f $1paparazzi_version ]
then
	echo "$1 seems to be a pprz dir!"
	echo
	if [ "$2" == "-r" ]
	then
		echo "I'll try to grep folling files back:"
		echo 
		for file in $files;
		do
		    ls $file
		done
		if [ -f $1conf/simulator/jsbsim/aircraft/reset_ristedt.xml ]
		then
			for file in $files
			do
				echo "cp -rf $1$file $file"
	                        cp -rf $1$file $file
	                        if [ $? -ne 0 ]
	                        then
	                                echo
	                                echo "I wasn't able to copy $file back, exiting!" 
	                                echo
	                        fi
			done
		else
			echo
			echo "I can't do it, you didn't install those files before!"
			echo
			exit 255
		fi
	else
                echo "I'll install the following files to your paparazzi:"
                echo 
                for file in $files;
                do
                    ls $file
                done
                for file in $files;
                do
                	cp -rf $file $1$file
	 		if [ $? -ne 0 ]
			then
				echo
				echo "I wasn't able to copy $file to your installation, exiting!" 
				echo
			fi
		done	
		if [ -d /home/christoph/Seafile/paparazzi_chni/ ]
		then
			echo
			echo "Seafile seems to be installed, linking the folders..."
			echo
			rm -rf $1var/logs
                        rm -rf $1var/maps
			ln -sf /home/christoph/Seafile/paparazzi_chni/var/maps $1var/maps
                        ln -sf /home/christoph/Seafile/paparazzi_chni/var/logs $1var/logs
			echo "requesting password for installing fgfs symlinks and fgfs scripts"
			sudo ln -s /home/christoph/Seafile/paparazzi_chni/conf/simulator/flightgear/ /usr/share/games/flightgear/Models/Aircraft/paparazzi
			if [ "christoph" == `whoami` ]
			then
				echo "You are Christoph. Installing desktop-icon."
				sudo cp paparazzi.desktop /usr/share/applications/
			else 
				echo "You are `whoami`"
			fi
			sudo cp scripts/fgfs_mkk /usr/bin
			sudo cp scripts/create_symlinks_for_conf /usr/bin
		fi
	fi
	echo
else
	echo "you gave one argument, but that doens't seem to be a pprz dir!"
	echo
	exit 255
fi






