#!/bin/sh 
. ./ibeacon.conf
echo "Launching virtual iBeacon..."
sudo hciconfig
sudo hciconfig $BLUETOOTH_DEVICE up
# sudo hciconfig $BLUETOOTH_DEVICE noleadv
sudo hcitool -i hci0 cmd 0x08 0x0008 1e 02 01 1a 1a ff 4c 00 02 15 $UUID $MAJOR $MINOR $POWER 00 00 00 00 00 00 00 00 00 00 00 00 00
# Fix taken from
# http://stackoverflow.com/questions/20252587/raspberry-pi-ibeacon-connection-timing-out
sudo hciconfig $BLUETOOTH_DEVICE leadv 3
echo "Complete"

