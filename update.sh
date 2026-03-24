#!/bin/sh
# del_gcode install script for ZMOD
# https://github.com/iamt4nk/del_gcode

set -e

source /opt/config/mod/.shell/0.sh

cp del_gcode.py ${MOD}/usr/data/config/base/moonraker/components/

INC="[include plugins/del_gcode/moonraker.cfg]"
FILE="/opt/config/mod_data/plugins.moonraker.conf"

grep -qF "${INC}" "${FILE}" || echo "${INC}" >> "${FILE}"
