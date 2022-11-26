Commands
*********

build-mcuboot
-------------

Build your own mcuboot
```docker run --rm -v `pwd`:/app wixet/zephyr build-mcuboot {board}```

For example

```docker run --rm -v `pwd`:/app wixet/zephyr build-mcuboot nrf52840dk_nrf52840```

To use yor custom key:

```docker run --rm -v `pwd`/build:/build wixet/zephyr build-mcuboot -v `pwd`/my-key.pem:/zephyrproject/bootloader/mcuboot/root-rsa-2048.pem nrf52840dk_nrf52840```

Building for a customized board and a custom mcu prj.conf file and flash the bootloader once it is compiled
```docker run --rm --device=/dev/bus/usb/ -v /home/maxpowel/zephyr/smart_wrist/nrf52840dk_nrf52840:/zephyrproject/zephyr/boards/arm/nrf52840dk_nrf52840 -v /home/maxpowel/zephyr/smart_wrist/mcuboot_prj.conf:/zephyrproject/bootloader/mcuboot/boot/zephyr/prj.conf wixet/zephyr build-mcuboot nrf52840dk_nrf52840 flash```

build
-----

Build your zephyr project
```docker run --rm -v `pwd`:/app wixet/zephyr build nrf52840dk_nrf52840```

sign
----

Build and sign an image
```docker run --rm -v `pwd`:/app wixet/zephyr build -v `pwd`/my-key.pem:/zephyrproject/bootloader/mcuboot/root-rsa-2048.pem nrf52840dk_nrf52840 sign```

build sign and flash
---------------------
Build an image, sign it and flash while using a customized board

```docker run --rm --device=/dev/bus/usb/ -v /home/maxpowel/zephyr/smart_wrist:/app -v /home/maxpowel/zephyr/smart_wrist/nrf52840dk_nrf52840:/zephyrproject/zephyr/boards/arm/nrf52840dk_nrf52840 -v /home/maxpowel/zephyr/smart_wrist/smart_wrist_key.pem:/zephyrproject/bootloader/mcuboot/root-rsa-2048.pem zephyr build nrf52840dk_nrf52840 build sign flash
```

`--device=/dev/bus/usb/` to allow access to the USB flasher
`-v /home/maxpowel/zephyr/smart_wrist:/app` mounting my zephyr aplication
`-v /home/maxpowel/zephyr/smart_wrist/nrf52840dk_nrf52840:/zephyrproject/zephyr/boards/arm/nrf52840dk_nrf52840` overriding the board nrf52840dk_nrf52840 with my own config
`-v /home/maxpowel/zephyr/smart_wrist/smart_wrist_key.pem:/zephyrproject/bootloader/mcuboot/root-rsa-2048.pem` overriding the key
`zephyr build nrf52840dk_nrf52840 build sign flash` run the zephyr container, build command and the board, sign, flash parameters


Flashing
********

The idea is to flash from your host machine, but if you want to do if from docker you will need to provide your USB device to the container by adding
`--device=/dev/bus/usb/` parameters to docker.

For example, to run the `openscd` with `stlink` for `nrf52` you can do this:

```
docker run --rm --device=/dev/bus/usb/ -p 4444:4444 zephyr openscd-stlink-nrf52
```

and then from your host

```
telnet 4444
program /my_app/path/zephyr.signed.bin 0x0000C000 verify
```



Simplify  usage
******************

Maybe you are not comfortable with all these long commands. Just use alias to shorten them
```
alias zephyr-build="docker run --rm -v `pwd`:/app -v `pwd`/my-key.pem:/zephyrproject/bootloader/mcuboot/root-rsa-2048.pem nrf52840dk_nrf52840 zephyr sign"
```

With this alias you only have to type `zephyr-build` and the signed build will be done using your own key


Boards
*****

/zephyrproject/zephyr/boards/arm