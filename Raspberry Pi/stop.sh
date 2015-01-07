#!/bin/sh
. ./ibeacon.conf
echo "Disabling virtual iBeacon..."
sudo hciconfig $BLUETOOTH_DEVICE noleadv
sudo hciconfig $BLUETOOTH_DEVICE down
echo "Complete"

