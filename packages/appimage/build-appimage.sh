#!/bin/bash
# Build AppImage for Universal Disk Cleanup Tool

set -e

VERSION="3.0.0"
NAME="diskcleanup"
APP_DIR="${NAME}.AppDir"
SRC_DIR=$(pwd)/../..

echo "Building ${NAME} ${VERSION} AppImage..."

# Clean previous builds
rm -rf ${APP_DIR}
rm -rf ${NAME}*.AppImage

# Create AppDir structure
mkdir -p ${APP_DIR}/usr/bin
mkdir -p ${APP_DIR}/usr/share/applications
mkdir -p ${APP_DIR}/usr/share/icons/hicolor/256x256/apps

# Copy PowerShell script
cp ${SRC_DIR}/cleanup.ps1 ${APP_DIR}/usr/bin/

# Create wrapper script
cat > ${APP_DIR}/usr/bin/${NAME} << 'WRAPPER'
#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
pwsh -File "${SCRIPT_DIR}/cleanup.ps1" "$@"
WRAPPER

chmod +x ${APP_DIR}/usr/bin/${NAME}

# Create desktop file
cat > ${APP_DIR}/${NAME}.desktop << EOF
[Desktop Entry]
Name=Disk Cleanup Tool
Comment=Cross-platform disk cleanup utility
Exec=${NAME}
Icon=${NAME}
Terminal=true
Type=Application
Categories=System;Utility;
