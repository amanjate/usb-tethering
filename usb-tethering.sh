#!/bin/bash

# This script is supposed to automatically setup USB tethering and notify the user.

# First, we check weather the last interface  is of type ethernet, else we exit.
IFACE=`ip link show | tail -2 | head -n 1 | awk -F": " '{print $2}'`
DTYPE=`nmcli device show $IFACE | grep TYPE | awk '{print $2}'`
test "$DTYPE" != "ethernet" && exit 0

# Then, we set an address to the interface and we set up the interface. If any error occurs, we exit.
ADDR=80:AB:CD:A4:75:25
sudo ip link set $IFACE down && sudo ip link set $IFACE address $ADDR && sudo ip link set $IFACE up
test $? -ne 0 && exit 0

# Now we check for internet connection as sooner ther service is available.
XCDG=2

while [ $XCDG -eq 2 ]
do
        ping -4qc 1 8.8.8.8 &> /dev/null; XCDG=$?
done

# If the exit code is equal to 1, it means that we don't have internet access.
test $XCDG -eq 1 && CNNT=" no"
NOTIF="USB Tethering with$CNNT internet connection!"

# Now we catch the first normal user to help us to notify the current user.
USER=$(getent passwd | awk -F: '$6 ~ /^\/home/ {print $1}' | head -n 1)
ICON=/usr/share/themes/Default/usb-tethering.jpg

su $USER -c "zenity --notification --window-icon=$ICON --text='$NOTIF'"
RESLT=$?

# If the an error occurs, we wait for a while until the desktop is ready.
while [ $RESLT -eq 1 ]
do
	sleep 25
	su $USER -c "zenity --notification --window-icon=$ICON --text='$NOTIF'"
	RESLT=$?
done
