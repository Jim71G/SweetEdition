#!/usr/bin/env bash

log() {
    if [ "$ENABLE_LOGGING" = true ]; then
        local timestamp
        timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        echo "$timestamp - $1" | tee -a "$LOG_FILE"
    fi
}
