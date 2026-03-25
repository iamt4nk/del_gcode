# del_gcode - Delete G-Code After Print
#
# Moonraker component that deletes G-code files after print completion.
# Triggered per-file from slicer end G-code via a Klipper macro.
#
# Copyright (C) 2026 iamt4nk
#
# This file may be distributed under the terms of the Apache License 2.0.

from __future__ import annotations

import logging

from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from moonraker.confighelper import ConfigHelper

logger = logging.getLogger(__name__)


class DelGcode:
    def __init__(self, config: ConfigHelper) -> None:
        self.server = config.get_server()
        self.name = config.get_name()
        self.pending_delete: str | None = None

        self.delete_on_operation = config.getlist("delete_on", ["complete", "standby"])

        # Register remote method callable from Klipper macros
        self.server.register_remote_method("del_gcode_mark", self._mark_for_deletion)

        # Listen for print state changes to perform the actual deletion
        self.server.register_event_handler(
            "server:status_update", self._on_status_update
        )

        # Register API endpoint for status/debugging
        self.server.register_endpoint(
            "/server/del_gcode/status",
            ["GET"],
            self._handle_status_request,
        )

        logger.info("del_gcode: Component loaded")

    def _mark_for_deletion(self) -> None:
        """Call this to flag a file for deletion"""
        event_loop = self.server.get_event_loop()
        event_loop.register_callback(self._async_mark_for_deletion)

    async def _async_mark_for_deletion(self) -> None:
        """Async handler to query print_stats and store filename."""
        try:
            klippy_apis = self.server.lookup_component("klippy_apis")
            result = await klippy_apis.query_objects({"print_stats": None})
            filename = result.get("print_stats", {}).get("filename", "")
            if filename:
                self.pending_delete = filename
                logger.info(f"del_gcode: Marked for deletion: {filename}")
            else:
                logger.warning("del_gcode: No filename found in print_stats")
        except Exception as e:
            logger.error(f"del_gcode: Error marking file: {e}")

    async def _on_status_update(self, status: dict) -> None:
        """Watch for print completion to perform deletion"""
        if self.pending_delete is None:
            return

        print_stats = status.get("print_stats", {})
        state = print_stats.get("state")

        if state is None:
            return

        # The file is released by virtual_sdcard once the state transitions to "complete" or "standby"
        if state in ("complete", "standby", "cancelled", "error"):
            filename = self.pending_delete
            self.pending_delete = None
            if state in self.delete_on_operation:
                await self._delete_file(filename)
            else:
                logger.info(
                    f"del_gcode: Print {state}, skipping deletion of: {filename}"
                )

    async def _delete_file(self, filename: str) -> None:
        """Delete the gcode file via Moonraker's file manager"""
        try:
            file_manager = self.server.lookup_component("file_manager")
            await file_manager.delete_file(f"gcodes/{filename}")
            logger.info(f"del_gcode: Deleted: {filename}")
        except Exception as e:
            logger.error(f"del_gcode: Failed to delete {filename}: {e}")

    async def _handle_status_request(self, web_request) -> dict:
        """API endpoint to check the current state."""
        return {
            "pending_delete": self.pending_delete,
        }


def load_component(config: ConfigHelper) -> DelGcode:
    return DelGcode(config)
