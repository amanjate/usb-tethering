#!/bin/bash

# This script is intended to install USB tethering service in the target machine.
# The service detects when an USB tethering is attached do the system
# Then, it sets up the connection and then it notifies the user.
# During the installation, we are going to copy some files to specific paths in the target system.

if [ -f "./usb-tethering.sh" ]; then
	sudo cp ./usb-tethering.sh /usr/local/bin/
	sudo chmod +x /usr/local/bin/usb-tethering.sh
else
	echo "The main script usb-tethering.sh was not found!"
	exit 1
fi

if [ -f "./start-usb-tethering.sh" ]; then
	sudo cp ./start-usb-tethering.sh /usr/local/bin/
	sudo chmod +x /usr/local/bin/start-usb-tethering.sh
else
	echo "The srcipt start-usb-tethering.sh was not found!"
	exit 2
fi

if [ -f "./usb-tethering.service" ]; then
        sudo cp ./usb-tethering.service /etc/systemd/system/
	sudo systemctl daemon-reload
else
        echo "The srcipt start-usb-tethering.sh was not found!"
        exit 3
fi

if [ -f "./99-usb-tethering.rules" ]; then
        sudo cp ./99-usb-tethering.rules /etc/udev/rules.d/
	sudo udevadm control --reload
	sudo udevadm control --reload-rules
else
        echo "The 99-usb-tethering.rules with the UDEV rules was not found!"
        exit 4
fi

if [ -f "./usb-tethering.jpg" ]; then
        sudo cp ./usb-tethering.jpg /usr/share/themes/Default/
else
        echo "The icon file usb-tethering.jpg was not found!"
        exit 5
fi

echo "Installation completed successfully!" 
