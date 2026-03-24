#!/bin/bash
# del_gcode uninstall script for ZMOD
# https://github.com/iamt4nk/del_gcode

# Remove the Moonraker component symlink
for candidate in \
	/root/moonraker/moonraker/components \
	/home/pi/moonraker/moonraker/components \
	/home/mks/moonraker/moonraker/components; do
	if [ -d "${candidate}/del_gcode.py" ]; then
		rm -f "${candidate}/del_gcode.py"
		echo "del_gcode: Removed Moonraker component from ${candidate}"
		break
	fi
done

echo "del_gcode: Uninstallation complete"
echo "del_gcode: Remember to remove [del_gcode] from mod_data/user.moonraker.conf"
echo "del_gcode: Remember to remove REMOVE_GCODE from your slicer start G-code"
