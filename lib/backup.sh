#!/usr/bin/env bash

backup_item() {
    local item="$1"

    if [ "$ENABLE_BACKUP" = true ]; then
        mkdir -p "$BACKUP_DIR"

        if [ -e "$item" ]; then
            cp -r "$item" "$BACKUP_DIR/"
            log "Backed up: $item → $BACKUP_DIR"
        else
            log "Backup skipped (not found): $item"
        fi
    fi
}
