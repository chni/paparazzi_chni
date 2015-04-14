files="
conf/control_panel.xml
conf/simulator/jsbsim/aircraft/reset_ristedt.xml
conf/radios/mc15_CHNI.xml
conf/radios/TGY9x_jeti.xml
conf/radios/TGY9x_jeti_christoph.xml
conf/radios/TGY9x_jeti_lothar.xml
conf/radios/dx6iCHNI.xml
conf/radios/Spektrum_DX6.xml
conf/joystick/saitek_p1500.xml
conf/joystick/dx6i_CHNI.xml
conf/settings/control/ctl_airspeed.xml
conf/flight_plans/rotorcraft_stieglitz.xml
conf/flight_plans/rotorcraft_scharbeutz.xml
conf/flight_plans/rotorcraft_finkenwerder.xml
conf/flight_plans/versatile_stieglitz.xml
conf/flight_plans/versatile_stieglitz_ftc.xml
conf/flight_plans/versatile_hainmuehlen_ftc.xml
conf/flight_plans/rotorcraft_hainmuehlen.xml
conf/flight_plans/kutenholz.xml
conf/flight_plans/rotorcraft_cch.xml
conf/airframes/hbmini_chni.xml
conf/airframes/Up2You.xml
conf/airframes/Up2You_test.xml
conf/airframes/katana.xml
conf/airframes/x8_chni.xml
conf/airframes/ardrone2_chni.xml
conf/airframes/X580_CHNI.xml
conf/gcs/horizontal.xml
conf/settings/fixedwing_basic.xml
conf/settings/control/ctl_basic.xml
conf/settings/estimation/ins_neutrals.xml
conf/settings/control/ctl_airspeed.xml
conf/telemetry/default_fixedwing_imu.xml
ENV
conf/simulator/nps/nps_sensors_params_hbmini.h
"

filesfor52="
sw/airborne/boards/twog_1.0.h
sw/airborne/boards/tiny_2.1.h
sw/airborne/boards/hbmini/baro_board.c
sw/airborne/boards/hbmini/baro_board.h
sw/airborne/boards/hbmini/imu_hbmini.c
sw/airborne/boards/hbmini/imu_hbmini.h
sw/airborne/boards/hbmini_1.0.h
conf/boards/hbmini_1.0.makefile
conf/firmwares/subsystems/shared/imu_hbmini.makefile
conf/firmwares/subsystems/shared/baro_board.makefile
"

echo "######################################################"
echo "# Welcome to the config-install-script!              #"
echo "#                                                    #"
echo "# usage is ./install.sh <PPRZ-DIR> [-r]              #"
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
		# Add the HBMini-Stuff in 5.2
                if [ `$1/paparazzi_version | cut -c1-4` == "v5.2" ]
                then 
		    mkdir -p $1/sw/airborne/boards/hbmini/
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
                fi
		# fi specific stuff for 5.2

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
			mkdir $1var
			ln -sf /home/christoph/Seafile/paparazzi_chni/var/maps $1var/maps
                        ln -sf /home/christoph/Seafile/paparazzi_chni/var/logs $1var/logs
			echo "requesting password for installing fgfs symlinks and fgfs scripts"
			sudo ln -s /home/christoph/Seafile/paparazzi_chni/conf/simulator/flightgear/ /usr/share/games/flightgear/Models/Aircraft/paparazzi
			sudo cp scripts/fgfs_mkk /usr/bin
			sudo cp scripts/create_symlinks_for_conf /usr/bin
		else
			echo 
			echo "Since you don't have access to the Seafile directory for logs and conf, I won't symlink maps and logs and give you a generic conf.xml"
		fi
                if [ `$1/paparazzi_version | cut -c1-4` == "v5.2" ]
                then
                         echo "it seems to be a Paparazzi 5.2 => installing according conf.xml"
                         cp -rf conf/conf.xml.52 $1/conf/conf.xml
                fi
	
        	read -p"Is this your default paparazzi-installation and do you want me to change or create the desktop-icons for you (y/n)? " response

		origin=`pwd`
		cd $1
		pprzdir=`pwd`
		cd $origin
	
	        if [ "$response" == "y" ]; then
        		echo "installing.." 
			echo "export PAPARAZZI_HOME="$pprzdir>startpaparazzi
			echo "PAPARAZZI_SRC="$pprzdir >> startpaparazzi
                        echo $pprzdir"/paparazzi" >> startpaparazzi
			chmod +x startpaparazzi
			sudo mv startpaparazzi /usr/bin/
			cat paparazzi.desktop.template > paparazzi.desktop
			cp penguin_icon.png $pprzdir/data/pictures/
			echo "Icon=$pprzdir/data/pictures/penguin_icon.png" >> paparazzi.desktop
			sudo mv paparazzi.desktop /usr/share/applications/

			echo ""
			echo "Install of the icon complete. You can (if compiled) start your paparazzi in your terminal, running \"startpaparazzi\". To place your quicklaunch-icon, click on the ubuntu-icon, enter paparazzi and drag and drop the icon"
			echo ""
			read -p"Press [ENTER]" response
        	fi

	fi
	echo
else
	echo "you gave one argument, but that doens't seem to be a pprz dir! (directory was $1)"
	echo
	exit 255
fi






