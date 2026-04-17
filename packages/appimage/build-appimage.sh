#!/bin/bash
# Build AppImage for Universal Disk Cleanup Tool

set -e

VERSION="2.0.0"
APP_NAME="DiskCleanupTool"
WORK_DIR="build"
APP_DIR="$WORK_DIR/$APP_NAME.AppDir"

echo "=========================================="
echo "  Building AppImage"
echo "=========================================="
echo ""

# Clean previous builds
rm -rf "$WORK_DIR"

# Create AppDir structure
mkdir -p "$APP_DIR/usr/bin"
mkdir -p "$APP_DIR/usr/share/applications"
mkdir -p "$APP_DIR/usr/share/icons/hicolor/256x256/apps"

# Copy files
cp cleanup.ps1 "$APP_DIR/usr/bin/"
cp diskcleanup.desktop "$APP_DIR/$APP_NAME.desktop"

# Create AppRun
cat > "$APP_DIR/AppRun" << 'EOF'
#!/bin/bash
SELF=$(readlink -f "$0")
HERE=${SELF%/*}
export PATH="${HERE}/usr/bin:${PATH}"
pwsh -NoProfile -ExecutionPolicy Bypass -File "${HERE}/usr/bin/cleanup.ps1" "$@"
EOF
chmod +x "$APP_DIR/AppRun"

# Create .desktop file
cat > "$APP_DIR/$APP_NAME.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Disk Cleanup Tool
Comment=Universal disk cleanup utility
Exec=cleanup
Icon=diskcleanup
Terminal=true
Categories=System;Utility;
EOF

# Download appimagetool
if [ ! -f "appimagetool-x86_64.AppImage" ]; then
    echo "Downloading appimagetool..."
    wget -q "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
    chmod +x appimagetool-x86_64.AppImage
fi

# Build AppImage
echo "Building AppImage..."
./appimagetool-x86_64.AppImage "$APP_DIR" "${APP_NAME}-${VERSION}-x86_64.AppImage"

echo ""
echo "=========================================="
echo "  Build Complete!"
echo "=========================================="
echo ""
echo "AppImage: ${APP_NAME}-${VERSION}-x86_64.AppImage"
echo ""
echo "To run:"
echo "  ./${APP_NAME}-${VERSION}-x86_64.AppImage"
echo ""
