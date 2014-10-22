files="
conf/conf.xml
conf/simulator/jsbsim/aircraft/reset_ristedt.xml
conf/radios/mc15_CHNI.xml
conf/joystick/saitek_p1500.xml
conf/flight_plans/rotorcraft_stieglitz.xml
conf/flight_plans/versatile_stieglitz.xml
conf/airframes/x8_chni.xml
ENV
sw/airborne/boards/twog_1.0.h
sw/airborne/boards/tiny_2.1.h
"

for file in $files;
do

  ls $file

done
