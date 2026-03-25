# del_gcode

A [Moonraker](https://github.com/Arksine/moonraker) plugin that automatically deletes G-code files after a successful print. Deletion is triggered on a per-file basis from your slicer's start G-code, so you have full control over which files are cleaned up.

## How It Works

1. You add `REMOVE_GCODE` to a file's start G-code in your slicer (before `START_PRINT`).
2. When the print starts, the macro calls into the Moonraker component and flags the currently printing file for deletion.
3. Once the print completes, the plugin deletes the file automatically.

If the print is cancelled or errors out, the file is **not** deleted — so you can retry without reslicing.

## Installation (ZMOD)

Edit your `mod_data/user.moonraker.conf` file and add the following:
```
[update_manager del_gcode]
type: git_repo
channel: dev
path: /root/printer_data/config/mod_data/plugins/del_gcode
origin: https://github.com/iamt4nk/del_gcode.git
is_system_service: False
primary_branch: master
```

After installation, reboot your printer.

## Slicer Setup

Add `REMOVE_GCODE` to your slicer's **start G-code**, before `START_PRINT`. For example:

```gcode
REMOVE_GCODE
START_PRINT ...
```

Any file sliced with this line will be automatically deleted after a successful print. Files sliced without it are left untouched.

## API

The plugin exposes a status endpoint for debugging:

```
GET /server/del_gcode/status
```

Returns the filename currently pending deletion, or `null` if none.

## Uninstalling

```sh
cd /opt/config/mod/plugins/del_gcode
./uninstall.sh
```

Remove the `REMOVE_GCODE` macro from your Klipper config and reboot.

## License

Apache License 2.0 — see [LICENSE](LICENSE) for details.
