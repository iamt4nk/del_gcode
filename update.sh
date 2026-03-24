#!/bin/bash
# del_gcode update script for ZMOD
# https://github.com/iamt4nk/del_gcode

# Re-run install to update the symlink
PLUGIN_DIR="$(cd "$(dirname "$0")" && pwd)"
exec "${PLUGIN_DIR}/install.sh"


