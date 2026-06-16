#!/usr/bin/env bash

apply_plasma_theme() {
    if command -v lookandfeeltool >/dev/null 2>&1; then
        lookandfeeltool -a "$THEME_NAME"
        log "Applied Plasma theme: $THEME_NAME"
    else
        log "lookandfeeltool not found — Plasma theme not applied"
    fi
}

apply_gtk_theme() {
    gsettings set org.gnome.desktop.interface gtk-theme "$THEME_NAME"
    gsettings set org.gnome.desktop.wm.preferences theme "$THEME_NAME"
    log "Applied GTK theme: $THEME_NAME"
}

apply_icon_theme() {
    gsettings set org.gnome.desktop.interface icon-theme "$THEME_NAME"
    log "Applied icon theme: $THEME_NAME"
}

apply_cursor_theme() {
    gsettings set org.gnome.desktop.interface cursor-theme "$THEME_NAME"
    log "Applied cursor theme: $THEME_NAME"
}
