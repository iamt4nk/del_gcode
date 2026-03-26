# del_gcode

A [Moonraker](https://github.com/Arksine/moonraker) plugin that automatically deletes G-code files after a successful print. Deletion is triggered on a per-file basis from your slicer's start G-code, so you have full control over which files are cleaned up. This is especially useful for instances such as calibration prints where the file is not needed on the printer afterwards.

## How It Works

1. You add `REMOVE_AFTER_PRINT` to a file's start G-code in your slicer (before `START_PRINT`).
2. When the print starts, the macro calls into the Moonraker component and flags the currently printing file for deletion.
3. Once the print completes, the plugin deletes the file automatically.

If the print is cancelled or errors out, the file is **not** deleted by default.

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

Then enable it with:
```
ENABLE_PLUGIN NAME=del_gcode
```

After installation, reboot your printer.

## Configuration
By default, del_gcode only deletes on complete prints. To make it delete on cancel or error edit the user.moonraker.conf file:
```
[del_gcode]
delete_on: complete, error, cancel
```

## Slicer Setup

Add `REMOVE_AFTER_PRINT` anywhere to your slicer's **start G-code**. For example:

```
REMOVE_AFTER_PRINT
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

Run the following command in the fluidd/mainsail console:
```
DISABLE_PLUGIN NAME=del_gcode
```

## License

Apache License 2.0 - [LICENSE](LICENSE) for details.
