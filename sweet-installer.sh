
#!/usr/bin/env bash
#
# Sweet Edition 6.0 - Modular Installer
# Uses: config.conf, lib/*.sh, modules/*.sh

set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# -------------------------------
# Load config
# -------------------------------
if [ ! -f "$ROOT_DIR/config.conf" ]; then
    echo "config.conf not found in $ROOT_DIR"
    exit 1
fi
# shellcheck source=/dev/null
source "$ROOT_DIR/config.conf"

# -------------------------------
# Load helper libraries
# -------------------------------
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/logging.sh"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/backup.sh"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/utils.sh"
# shellcheck source=/dev/null
source "$ROOT_DIR/lib/apply.sh"

log "Sweet Edition Installer started"# Auto-update
if [ "$ENABLE_AUTO_UPDATE" = true ]; then
    source "$ROOT_DIR/modules/auto_update.sh"
    auto_update
else
    log "Auto-update disabled"
fi



log "Using theme: $THEME_NAME"
log "Assets root: $ASSETS_ROOT"

# -------------------------------
# Sanity checks
# -------------------------------
if [ ! -d "$ASSETS_ROOT" ]; then
    log "ERROR: Assets root not found: $ASSETS_ROOT"
    exit 1
fi

ensure_dir "$PLASMA_DIR"
ensure_dir "$KVANTUM_DIR"
ensure_dir "$GTK_DIR"
ensure_dir "$GTK4_DIR"
ensure_dir "$ICONS_DIR"
ensure_dir "$COLOR_SCHEMES_DIR"
ensure_dir "$AURORAE_DIR"
ensure_dir "$WALLPAPER_DIR"
ensure_dir "$BACKUP_DIR"

# -------------------------------
# Plasma
# -------------------------------
if [ "$ENABLE_PLASMA" = true ]; then
    # shellcheck source=/dev/null
    source "$ROOT_DIR/modules/plasma.sh"
    install_plasma_theme
else
    log "Plasma module disabled"
fi

# -------------------------------
# Kvantum
# -------------------------------
if [ "$ENABLE_KVANTUM" = true ]; then
    # shellcheck source=/dev/null
    source "$ROOT_DIR/modules/kvantum.sh"
    install_kvantum_theme
else
    log "Kvantum module disabled"
fi

# -------------------------------
# GTK
# -------------------------------
if [ "$ENABLE_GTK" = true ]; then
    # shellcheck source=/dev/null
    source "$ROOT_DIR/modules/gtk.sh"
    install_gtk_theme
else
    log "GTK module disabled"
fi

# -------------------------------
# Icons
# -------------------------------
if [ "$ENABLE_ICONS" = true ]; then
    # shellcheck source=/dev/null
    source "$ROOT_DIR/modules/icons.sh"
    install_icon_theme
else
    log "Icons module disabled"
fi

# -------------------------------
# Cursors
# -------------------------------
if [ "$ENABLE_CURSORS" = true ]; then
    # shellcheck source=/dev/null
    source "$ROOT_DIR/modules/cursors.sh"
    install_cursor_theme
else
    log "Cursors module disabled"
fi

# -------------------------------
# SDDM
# -------------------------------
if [ "$ENABLE_SDDM" = true ]; then
    # shellcheck source=/dev/null
    source "$ROOT_DIR/modules/sddm.sh"
    install_sddm_theme
else
    log "SDDM module disabled"
fi

# -------------------------------
# Wallpapers
# -------------------------------
if [ "$ENABLE_WALLPAPERS" = true ]; then
    # shellcheck source=/dev/null
    source "$ROOT_DIR/modules/wallpapers.sh"
    install_wallpapers
else
    log "Wallpapers module disabled"
fi

# -------------------------------
# Color schemes
# -------------------------------
if [ "$ENABLE_COLORS" = true ]; then
    # shellcheck source=/dev/null
    source "$ROOT_DIR/modules/colors.sh"
    install_color_scheme
else
    log "Color schemes module disabled"
fi

# -------------------------------
# Aurorae
# -------------------------------
if [ "$ENABLE_AURORAE" = true ]; then
    # shellcheck source=/dev/null
    source "$ROOT_DIR/modules/aurorae.sh"
    install_aurorae_theme
else
    log "Aurorae module disabled"
fi

# -------------------------------
# Extras
# -------------------------------
if [ "$ENABLE_EXTRAS" = true ]; then
    # shellcheck source=/dev/null
    source "$ROOT_DIR/modules/extras.sh"
    install_extras
else
    log "Extras module disabled"
fi

log "Sweet Edition Installer finished"

exit 0
