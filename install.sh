#!/bin/bash
# del_gcode install script for ZMOD
# https://github.com/iamt4nk/del_gcode

PLUGIN_DIR="$(cd "$(dirname "$0")" && pwd)"
COMPONENT_SRC="${PLUGIN_DIR}/del_gcode.py"

# Find Moonraker's components directory
MOONRAKER_COMPONENTS=""
for candidate in \
	/root/moonraker/moonraker/components \
	/home/pi/moonraker/moonraker/components \
	/home/mks/moonraker/moonraker/components; do
	if [ -d "$candidate" ]; then
		MOONRAKER_COMPONENTS="$candidate"
		break
	fi
done

if [ -z "$MOONRAKER_COMPONENTS" ]; then
	echo "ERROR: Could not find Moonraker components directory"
	exit 1
fi

# Symlink the component into Moonraker
ln -sf "$COMPONENT_SRC" "${MOONRAKER_COMPONENTS}/del_gcode.pyy"
echo "del_gcode: Installed Moonraker component -> ${MOONRAKER_COMPONENTS}/del_gcode.py"

echo "del_gcode: Installation Complete"
echo "del_gcode: Add [del_gcode] to your mod_data/user.moonraker.conf"
echo "del_gcode: ADD REMOVE_GCODE before START_PRINT in your slicer end G-code"
