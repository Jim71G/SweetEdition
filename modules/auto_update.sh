#!/usr/bin/env bash

auto_update() {
    log "Starting Sweet Edition auto-update"

    TMP_JSON="/tmp/sweet_versions.json"

    # Fetch remote version list
    if curl -fsSL "$UPDATE_SOURCE_URL" -o "$TMP_JSON"; then
        log "Fetched remote version list"
    else
        log "ERROR: Could not fetch remote version list"
        return
    fi

    # Loop through all variants in assets
    for variant in "$ASSETS_ROOT/plasma/"*/; do
        variant_name=$(basename "$variant")

        log "Checking updates for: $variant_name"

        LOCAL_VERSION_FILE="$ASSETS_ROOT/plasma/$variant_name/version.txt"
        local_version="0"

        if [ -f "$LOCAL_VERSION_FILE" ]; then
            local_version=$(cat "$LOCAL_VERSION_FILE")
        else
            log "Local version missing for $variant_name"
        fi

        remote_version=$(jq -r --arg v "$variant_name" '.[$v].version' "$TMP_JSON")

        if [ "$remote_version" = "null" ]; then
            log "No remote version info for $variant_name"
            continue
        fi

        if [ "$local_version" = "$remote_version" ]; then
            log "Up to date: $variant_name (v$local_version)"
            continue
        fi

        log "UPDATE FOUND: $variant_name (local v$local_version → remote v$remote_version)"

        # Download URL
        download_url=$(jq -r --arg v "$variant_name" '.[$v].download' "$TMP_JSON")

        if [ "$download_url" = "null" ]; then
            log "ERROR: No download URL for $variant_name"
            continue
        fi

        TMP_ZIP="/tmp/${variant_name}.zip"

        log "Downloading update for $variant_name"
        if curl -fsSL "$download_url" -o "$TMP_ZIP"; then
            log "Download complete"
        else
            log "ERROR: Failed to download $variant_name"
            continue
        fi

        # Extract to temp
        TMP_EXTRACT="/tmp/${variant_name}_extract"
        rm -rf "$TMP_EXTRACT"
        mkdir -p "$TMP_EXTRACT"
        unzip -q "$TMP_ZIP" -d "$TMP_EXTRACT"

        # Backup old variant
        backup_item "$ASSETS_ROOT/plasma/$variant_name"
        backup_item "$ASSETS_ROOT/gtk/$variant_name"
        backup_item "$ASSETS_ROOT/icons/$variant_name"
        backup_item "$ASSETS_ROOT/cursors/$variant_name"
        backup_item "$ASSETS_ROOT/aurorae/$variant_name"
        backup_item "$ASSETS_ROOT/extras/variants/$variant_name"

        # Replace assets
        copy_asset "$TMP_EXTRACT/plasma" "$ASSETS_ROOT/plasma/$variant_name"
        copy_asset "$TMP_EXTRACT/gtk" "$ASSETS_ROOT/gtk/$variant_name"
        copy_asset "$TMP_EXTRACT/icons" "$ASSETS_ROOT/icons/$variant_name"
        copy_asset "$TMP_EXTRACT/cursors" "$ASSETS_ROOT/cursors/$variant_name"
        copy_asset "$TMP_EXTRACT/aurorae" "$ASSETS_ROOT/aurorae/$variant_name"
        copy_asset "$TMP_EXTRACT/extras" "$ASSETS_ROOT/extras/variants/$variant_name"

        # Update version file
        echo "$remote_version" > "$LOCAL_VERSION_FILE"
        log "Updated version file for $variant_name → v$remote_version"

        log "Update complete for $variant_name"
    done

    log "Auto-update finished"
}
