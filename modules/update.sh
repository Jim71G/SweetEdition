#!/bin/bash

# Load config
source "$(dirname "$0")/../config.conf"

UPDATE_URL="$UPDATE_SOURCE_URL"

echo "Checking for updates..."

# Fetch JSON
LATEST_JSON=$(curl -s "$UPDATE_URL")
LATEST_VERSION=$(echo "$LATEST_JSON" | jq -r '.latest_version')
DOWNLOAD_URL=$(echo "$LATEST_JSON" | jq -r '.download_url')
FILE_NAME=$(echo "$LATEST_JSON" | jq -r '.file_name')

echo "Latest version: $LATEST_VERSION"
echo "Installed version: $CURRENT_VERSION"

# Compare versions
if [ "$LATEST_VERSION" = "$CURRENT_VERSION" ]; then
    echo "SweetEdition is up to date."
    exit 0
fi

echo "Update available! Downloading $FILE_NAME..."

curl -L -o "$FILE_NAME" "$DOWNLOAD_URL"

echo "Extracting update..."
tar -xzvf "$FILE_NAME"

echo "Applying update..."
cp -r SweetEdition/* /opt/SweetEdition/

echo "Update complete!"
