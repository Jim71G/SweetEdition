#!/usr/bin/env bash

ensure_dir() {
    local dir="$1"
    mkdir -p "$dir"
    log "Ensured directory: $dir"
}

copy_asset() {
    local src="$1"
    local dest="$2"

    if [ -d "$src" ]; then
        ensure_dir "$dest"
        cp -r "$src"/* "$dest/"
        log "Copied assets: $src → $dest"
    else
        log "Asset source missing: $src"
    fi
}

check_dependency() {
    local dep="$1"

    if ! command -v "$dep" >/dev/null 2>&1; then
        log "Missing dependency: $dep"
        return 1
    fi

    log "Dependency OK: $dep"
    return 0
}
