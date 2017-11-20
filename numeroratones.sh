#!/bin/bash
# Un script simple
# Cuento los ratones que tengo actualmente instalados
# Por defecto mi equipo portátil tiene 2 ratones
v=$(grep mouse /proc/bus/input/devices | grep Handler | wc -l)
# Comprobamos si tenemos activado o desactivado el touchpad
# Valos: 1 Desactivado y 0 Activado
activado=$(/usr/bin/synclient | grep Touch | cut -d "=" -f 2 | cut -d " " -f 2)
if [ $activado -eq 1 ];
then
	echo "El Touchpad está desactivado"
elif [ $v -gt 2 ];
then
	echo "Tengo al menos un ratón USB. Desactivo mi superfice de ratón táctil"
	/usr/bin/synclient TouchpadOff=1
else
	echo "El Touchpad está activado y no hay ratones usb conectados a la máquina"
fi
