#!/bin/bash
# coded by NeOxXx rev 0.1 07/2017
# Sample bash script to control MacBook fan dinamically by cpu temperature

printf '\e[8;6;33t' # set terminal window @ 33x6

trap "echo 0 > /sys/devices/platform/applesmc.768/fan1_manual && clear && echo byebye!! && exit" INT

FANSPEED=1300 # Default rpm

function set_fan() {
  if [ "$FANSPEED" != "$CPUFANSET" ]
    then
      echo $FANSPEED > /sys/devices/platform/applesmc.768/fan1_output
  fi
}

echo "Avvio gestione ventola CPU automatizzato.."
echo 1 > /sys/devices/platform/applesmc.768/fan1_manual

while :
do
   sleep 5
   clear

   CPUTEMP="$(cat /sys/class/thermal/thermal_zone2/temp)"
   CPUTEMP=$((CPUTEMP / 1000))

   CPUFAN="$(cat /sys/devices/platform/applesmc.768/fan1_input)"
   CPUFANSET="$(cat /sys/devices/platform/applesmc.768/fan1_output)"

   echo "| CPU Temp | FanSpeed |"
   echo "-----------------------"
   tput rev
   echo "|   $((CPUTEMP))°C   |  $((CPUFAN))rpm |"
   tput sgr0

   case $CPUTEMP in                     # cpuTemp:
     [0-9]|[1-4][0-8]) FANSPEED=1500 ;; # 0-48°   @ 1500rmp
     49|5[0-4]) FANSPEED=2000 ;;        # 49°-54° @ 2000rmp
     5[5-9]|60) FANSPEED=3000 ;;        # 55°-60° @ 3000rmp
     6[1-9]|70) FANSPEED=4000 ;;        # 61°-70° @ 4000rmp
     7[1-9]|80) FANSPEED=5000 ;;        # 71°-80° @ 5000rmp
     8[1-9]|9[0-9]) FANSPEED=6000 ;;    # 81°-99° @ 6000rmp
   esac
   
   set_fan #set fan rpm

   echo "-----------------------"   
   echo "> Speed set @ $((CPUFANSET))rpm <"

done
