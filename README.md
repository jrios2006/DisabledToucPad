# DisabledTouchPad
Desactivar touchpad al conectar un ratón externo al ordenador

Tengo un ordeandor portátil Thinkpad que tiene dos ratones integrados, un TouchPad y trackball.

En las últimas versiones de las diferentes distribuciones se puede desactivar el Touchpad cuando se escribe, pero es molesto cuando se pone las manos en el teclado el ratón es posible que se mueva y despiste.

Además cada vez se hacen más grande el espacio del ratón táctil con lo cual se me hace más complicado usar el teclado sin interferencias con el ratón.

Por esto no quiero usar el ratón así dispuesto en el portátil y prefiero usar un ratón externo. Así cuando conecto un ratón quiero desactivar esa zona del ratón Touchpad y colocar corectamente mis manos sobre el teclado.

Con apenas cuatro líneas podemos consegur el resultado esperado.

## ¿Qué necesito?

Voy a necesitar ser usuario administrador porque quiero escribir una regla en el sistema para cuadno conecte o desconecte un ratón externo.

Evidentemente necesito un ratón externo para probar

## ¿Cuántos ratones tiene mi ordeandor?

Lo primero es saber cuantos ratones tiene mi ordenador. Para esto nos basta con ejecuatr el siguiente comando:
<code>
grep mouse /proc/bus/input/devices | grep Handler | wc -l
</code>
En mi caso me da 2 por defecto.

Observar que el comando wc cuanta las líneas de texto que son enviadas por los otros comandos, en este caso el comando grep

Cuando conecto un tercer ratón el resultado es 3

## Driver de Touchpad

Si tenemos un driver instalado de Touchpad ejecutando el comando
<code>
/usr/bin/synclient | grep Touch | cut -d "=" -f 2 | cut -d " " -f 2
</code>

nos saldrá un 1 o un 0 si está activado y se puede usar o si está desactivado y aunque se pulse este harware no responde.

Para activar o desactivar basta ejecutar el siguiente comando
<code>
/usr/bin/synclient TouchpadOff=0
</code>
o
<code>
/usr/bin/synclient TouchpadOff=1
</code>

Escribir esto es sencillo pero es engorrorso acordarse del coamndo a ejecutar y desde luego no es operativo. Nos bastaría con conectar el dispositivo y ejecuat esta orden desde una consola y ya dejaría de responder el touchpad del ratón.

Para evitar hacer esto conviene programar a nuestro sistema y decirle que lo haga por nosotros de manera automática.

## Regla UDEV

Por fortuna GNU/Linux cuenta con un sistema que nos permite automatizar muchas tareas cuando conectamos o desconectamos dispositivos a nuestro sistema. Este sistema se llama UDEV.

Nos basta con saber escribir las reglas necesarias en unos ficheros de texto para que el sistema ejecute lo que le escribamos en ellas.

Debemos crear un fichero de texto con nombre por ejemplo 01-touchpad.rules

### 01-touchpad.rules

El sistema UDEV nos dice como debemos escribir el nombre del fichero y su sintaxis.

Aquí debemos especificar tres cosas:

* De que hardware estamos hablando
* Donde lo vamos a ejecutar
* Que programa vamos a ejecutar cuando se produzca el evento

Con el código 
<code>
SUBSYSTEM=="input", KERNEL=="mouse[0-9]*", ACTION=="add", 
</code>
especificamos que queremos hacar algo cuando conectemos un ratón o mouse
Con el código
<code>
ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/[Usuario]/.Xauthority", RUN+="/usr/bin/synclient TouchpadOff=1"
</code>
le decimos donde se a ejecutar el programa, y que programa vamos a ejecutar.

Una vez puesto el fichero es su ruta, que es /etc/udev/rules.d/ y recargamos la reglas udev o reiniciamos la máquina, cuando conectemos o desconectamos un dispositivo mouse se ejecutarán el programa que le decimos.

## Casos no conteplados

Cuando creamos una regla udev se ejecuta cuando se produce un evento, en este caso al conectar o desconectar un dispositivo. Cuando el ordenador está apagado y hay un ratón conectado USB este evento no se produce y el resultado es que el touchpad funciona, porque por defecto funciona.

Esto se arregla quitando y poniendo el ratón USB o diciendo a nuestro ordeandor que cuando ejecutemos sesión ejecute otro programa que cuente el número de ratones que hay en el sistema y si hay más de dos y está activado el touchpad lo desactive.

Puede ocurrir que haya más de dos ratones usb conectados sin darnos cuenta y quitemos uno, esto hará que funcione el touchpad y haya 3 ratones. este caso es más dificil de darse porque los portátiles cuentan con pocos puestos libres.

## Instalación

* Modificar el fichero 01-touchpad.rules y sustituir [Usuario] por el usuario de nuestro equipo
* Copiar el fichero a /etc/udev/rules.d/
* Copiar el fichero numeroratones.sh a /usr/bin y hacerlo ejecutable (chmod +x /usr/bin/numeroratones.sh)
* Programar la ejecución de este programa al incio de sesión. Dejo unos ficheros gráficos con patallazo en el entorno de escritorio Mate en la carpeta Pantallazo

## Agradecimmientos

[http://www.rafamartorell.com/](https://rafamartorell.wordpress.com/2013/05/01/desactivar-el-panel-tactil-cuando-se-detecta-un-raton-externo/)
