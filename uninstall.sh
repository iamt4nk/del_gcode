#!/bin/sh

source /opt/config/mod/.shell/0.sh

FILE="/opt/config/mod_data/plugins.moonraker.conf"

sed -i "\|plugins/del_gcode/${ZLANG}/notify\.moonraker\.cfg|d" "$FILE"

rm -f /opt/config/mod/.shell/root/moonraker/components/del_gcode.py
rm -rf /root/printer_data/gcodes/del_gcode

echo "Moonraker Del-Gcode uninstalled"
echo "REBOOT" >/tmp/printer
