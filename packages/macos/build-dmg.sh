#!/bin/bash
# Build DMG for Universal Disk Cleanup Tool (macOS)

set -e

VERSION="2.0.0"
APP_NAME="DiskCleanupTool"
VOLUME_NAME="Disk Cleanup Tool"
DMG_NAME="${APP_NAME}-${VERSION}.dmg"
WORK_DIR="build"

echo "=========================================="
echo "  Building macOS DMG"
echo "=========================================="
echo ""

# Clean previous builds
rm -rf "$WORK_DIR"
rm -f "$DMG_NAME"

# Create working directory
mkdir -p "$WORK_DIR/dmg"

# Copy app bundle
cp -R "macos/$APP_NAME.app" "$WORK_DIR/dmg/"

# Create symlink to Applications
ln -s /Applications "$WORK_DIR/dmg/Applications"

# Create DMG
echo "Creating DMG..."
hdiutil create -volname "$VOLUME_NAME" \
               -srcfolder "$WORK_DIR/dmg" \
               -ov \
               -format UDZO \
               "$DMG_NAME"

echo ""
echo "=========================================="
echo "  Build Complete!"
echo "=========================================="
echo ""
echo "DMG: $DMG_NAME"
echo ""
echo "To install:"
echo "  1. Mount $DMG_NAME"
echo "  2. Drag $APP_NAME.app to Applications"
echo "  3. Launch from Applications"
echo ""
