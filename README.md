# SECO MFGTOOLS

## Description

-Flashing tool for Uboot or Yocto image in i.MX8m, from OTG/TYPE C port.


## Build

-Install necessary packages:

    $ sudo apt-get install libusb-1.0.0-dev libzip-dev libbz2-dev pkg-config

-Download mfgtools sources:

    $ git clone https://github.com/NXPmicro/mfgtools

-Go inside the folder:

    $ cd seco_mfgtools

-Setting up permissions for "seco_flash_script.sh" bash script:

    $ sudo chmod 777 seco_flash_script.sh

-Now we are ready to flash the board just run the script against "Image" (Bootloader.bin/yocto.rootfs.sdcard) command list:

    $ sudo ./seco_flash_script.sh <IMAGE>


-Eg:

    $ sudo ./seco_flash_script.sh -b c26 -r 2gb -f < image to flash in the eMMC > 
    $ sudo ./seco_flash_script.sh -b c26 -r 2gb -f ./yocto.rootfs.sdcard


-Follow the commands that appear on the Terminal.

