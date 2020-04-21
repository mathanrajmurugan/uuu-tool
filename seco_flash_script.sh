#!/bin/bash

####################################################################################
# -Description:
# 
#  Run this script to flash imx8mq through emmc.    
#  "./uuu" executable run the command list described in "seco_cmd.lst" file. 
#  Download image in Ram and write it eMMC's board, dimension of writing block size
#  it is dependent on the size of the image.(Uboot block size = const [512 byte])
#
#  block_number = image / 512 (dec) ---> (convert hex) hex_block_number
#
######################################################################################
# -Usage: 
#
#  ./seco_flash_script.sh seco_cmd.lst
#   
######################################################################################

#DEFINE

CMD_FILENAME="./seco_cmd.lst"  
CHANGE="BLOCK_NUMBER"
CHANGE0='FLASH.BIN'
CHANGE1="FILE"
CHANGE2="ADDRESS"
CHANGE3="MMCDEV_NUMBER"
COPY_NAME=".seco_flashing_cmd.lst"
ADDRESS_BIN="0X42"
ADDRESS_YOC="0X00"
BOARD_FILE=""
#BOARD=$2
#IMAGE=$4
#FILESIZE=$(stat -c%s "$IMAGE")
BLOCK_SIZE=512
#Z=$(((FILESIZE / BLOCK_SIZE) + 100 )) ## Block number
#HEX=$(printf "%x\n" $Z)
# C12 
C12_BOARD_FILE="./images/seco_imx8mq_c12/flash_c12.bin";
MMCDEV_C12=0;
# C20 
C20_BOARD_FILE="./images/seco_imx8mq_c20/flash_c20.bin";
MMCDEV_C20=0
# C25
C25_BOARD_FILE="./images/seco_imx8mq_c25/flash_c25.bin";
MMCDEV_C25=0
# C61
C61_BOARD_FILE="./images/seco_imx8mm_c61/flash_c61.bin";
MMCDEV_C61=1
# C72
C72_BOARD_FILE="./images/seco_imx8mm_c72/flash_c72.bin";
MMCDEV_C72=1
# C26
C26_2GB_BOARD_FILE="./images/seco_imx8qm_c26/flash_c26_2gb.bin";
C26_4GB_BOARD_FILE="./images/seco_imx8qm_c26/flash_c26_4gb.bin";
C26_8GB_BOARD_FILE="./images/seco_imx8qm_c26/flash_c26_8gb.bin";
MMCDEV_C26=0



#IMPLEMENTATION
function wia(){
    if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 
    exit 1
    fi
}






####SE .BIN UNA COSA SE .SDCARD SOSTITUISCI ADDRESS 0X42 O 0X0
function f_address(){
    #echo "Usage: sudo ./seco_flash_script.sh -b <Board> -f <Image>"
    #read -p "Press enter to continue"

    local var=""
    var=$(cp ./seco_cmd.lst $COPY_NAME)

    if  [ $BOARD == "c12" ]; then
        
        var=$(sed -i 's|'$CHANGE0'|'$C12_BOARD_FILE'|g' $COPY_NAME);
	var=$(sed -i 's|'$CHANGE3'|'$MMCDEV_C12'|g' $COPY_NAME);
#	echo "FB: done" >> $COPY_NAME
        echo c12

    elif [ $BOARD == "c20" ]; then
        var=$(sed -i 's|'$CHANGE0'|'$C20_BOARD_FILE'|g' $COPY_NAME);
	var=$(sed -i 's|'$CHANGE3'|'$MMCDEV_C20'|g' $COPY_NAME);
#	echo 'FB: ucmd setenv fastboot_buffer ${kernel_loadaddr}' >> $COPY_NAME
#	echo 'FB: download -f ./image.bin' >> $COPY_NAME
#	echo 'FB: ucmd mmc write ${fastboot_buffer} 0x0 0x14000' >> $COPY_NAME
	
#	echo "FB: done" >> $COPY_NAME
        echo c20

    elif [ $BOARD == "c25" ]; then
        var=$(sed -i 's|'$CHANGE0'|'$C25_BOARD_FILE'|g' $COPY_NAME);
	var=$(sed -i 's|'$CHANGE3'|'$MMCDEV_C25'|g' $COPY_NAME);
#	echo "FB: done" >> $COPY_NAME
        echo c25
    elif [ $BOARD == "c61" ]; then
        var=$(sed -i 's|'$CHANGE0'|'$C61_BOARD_FILE'|g' $COPY_NAME);
	var=$(sed -i 's|'$CHANGE3'|'$MMCDEV_C61'|g' $COPY_NAME);
#	echo "FB: done" >> $COPY_NAME
        echo c61
    
    elif [ $BOARD == "c72" ]; then
        var=$(sed -i 's|'$CHANGE0'|'$C72_BOARD_FILE'|g' $COPY_NAME);
	var=$(sed -i 's|'$CHANGE3'|'$MMCDEV_C72'|g' $COPY_NAME);
#	echo "FB: done" >> $COPY_NAME
        echo c72
    
    elif [ $BOARD == "c26" ]; then
        echo "Board selected is c26"
	if [ ! -z $RAMSIZE ]; then	
		if [ $RAMSIZE == "2gb" ]; then
			echo "with 2GB RAM"
			var=$(sed -i 's|'$CHANGE0'|'$C26_2GB_BOARD_FILE'|g' $COPY_NAME);
		elif [ $RAMSIZE == "4gb" ]; then
			echo "with 4GB RAM"
			var=$(sed -i 's|'$CHANGE0'|'$C26_4GB_BOARD_FILE'|g' $COPY_NAME);
		elif [ $RAMSIZE == "8gb" ]; then
			echo "with 8GB RAM"
			var=$(sed -i 's|'$CHANGE0'|'$C26_8GB_BOARD_FILE'|g' $COPY_NAME);
		else
			echo "No RAM size selected: pass ramsize with -s parameter, possibile choice are 2gb/4gb/8gb"
			exit 1
		fi
	else
		echo "No RAM size selected: pass ramsize with -s parameter, possibile choice are 2gb/4gb/8gb"
                        exit 1
	fi
	var=$(sed -i 's|'$CHANGE3'|'$MMCDEV_C26'|g' $COPY_NAME);
#	echo "FB: done" >> $COPY_NAME
	ADDRESS_BIN="0x40"
    fi
    
    if [[ "${IMAGE: -4}" == '.bin' ]]; then
        echo 'Have selected ".bin" Image  ['$IMAGE']'
        var=$(sed -i 's/'$CHANGE'/'$HEX'/g' $COPY_NAME);
        var=$(sed -i 's|'$CHANGE1'|'$IMAGE'|g' $COPY_NAME);
        var=$(sed -i 's|'$CHANGE2'|'$ADDRESS_BIN'|g' $COPY_NAME);
        echo "Load eMMC address --> $ADDRESS_BIN"
        echo "Connect to Board OTG to PC and Press Board Reset Button"
        sudo ./uuu  -V $COPY_NAME

    else
        echo 'Have selected another Image file extension'
        echo 'Load eMMC address --> 0x0'
        var=$(sed -i 's/'$CHANGE'/'$HEX'/g' $COPY_NAME);
	if [ ! -z $RAMSIZE ]; then
               if [ $RAMSIZE == "2gb" ]; then
                       echo "flashing flash.bin with 2GB RAM in $IMAGE"
                       dd if=$C26_2GB_BOARD_FILE of=$IMAGE bs=1k count=32 conv=notrunc
               elif [ $RAMSIZE == "4gb" ]; then
                       echo "flashing flash.bin with 4GB RAM in $IMAGE"
                       dd if=$C26_4GB_BOARD_FILE of=$IMAGE bs=1k count=32 conv=notrunc
               elif [ $RAMSIZE == "8gb" ]; then
                       echo "flashing flash.bin with 8GB RAM in $IMAGE"
                       dd if=$C26_8GB_BOARD_FILE of=$IMAGE bs=1k count=32 conv=notrunc
               else
                       echo "No RAM size selected: image $IMAGE will be flashed without changing uboot"
               fi
        else
                echo "No RAM size selected: image $IMAGE will be flashed without changing uboot"
        fi

        var=$(sed -i 's|'$CHANGE1'|'$IMAGE'|g' $COPY_NAME);
        var=$(sed -i 's|'$CHANGE2'|'$ADDRESS_YOC'|g' $COPY_NAME);
        echo "Connect to Board OTG to PC and Press Board Reset Button"
        sudo ./uuu -V  $COPY_NAME
    fi
    echo done!;
}

function cleanup(){
    local var=""
    var = $(rm -r ./sed*) 
}

#########################################################
#							#
#		Seco Boards Flashing script		#
#							#
#########################################################

#Check if this script is laucnhed as root

wia

# Command Line Parsing

POSITIONAL=()
while [[ $# -gt 0 ]]
do
	key="$1"

	case $key in
	    -b|--board)
	    BOARD="$2"
	    shift # past argument
	    shift # past value
	    ;;
	    -s|--ramsize)
	    RAMSIZE="$2"
	    shift # past argument
	    shift # past value
	    ;;
	    -f|--file)
	    IMAGE="$2"
	    shift # past argument
	    shift # past value
	    ;;
	    *)
	    POSITIONAL+=("$1") # save it in an array for later
	    shift # past argument
	    ;;
	esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

# Check if launched with correct parameters

if [[ -z $BOARD ]] || [[ -z $IMAGE ]]; then
	
	echo "Usage: sudo ./seco_flash_script.sh -b <Board> -f <Image>"
	exit 1
fi

FILESIZE=$(stat -c%s "$IMAGE")
Z=$(((FILESIZE / BLOCK_SIZE) + 100 )) ## Block number
HEX=$(printf "%x\n" $Z)

echo "BOARD=$BOARD"
echo "FLASH IMAGE=$IMAGE"

f_address
#clear

