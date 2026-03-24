#!/bin/sh

source /opt/config/mod/.shell/0.sh

FILE="/opt/config/mod_data/plugins.moonraker.cfg"

sed -i "\|plugins/del_gcode/del_gcode\.moonraker\.cfg|d" "$FILE"

rm /opt/conifg/mod/.shell/del_gcode.py

echo "Moonraker Del-Gcode uninstalled"
echo "REBOOT" >/tmp/printer
