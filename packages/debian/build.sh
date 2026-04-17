#!/bin/bash
# Build deb package for Universal Disk Cleanup Tool

set -e

VERSION="3.0.0"
NAME="diskcleanup"
PKG_DIR="deb-package"
BUILD_DIR="${PKG_DIR}/opt/${NAME}"
SRC_DIR=$(pwd)/../..

echo "Building ${NAME} ${VERSION} deb package..."

# Clean previous builds
rm -rf ${PKG_DIR}

# Create package directory structure
mkdir -p ${BUILD_DIR}
mkdir -p ${PKG_DIR}/DEBIAN
mkdir -p ${PKG_DIR}/usr/local/bin
mkdir -p ${PKG_DIR}/usr/share/man/man1
mkdir -p ${PKG_DIR}/usr/share/doc/${NAME}

# Copy files
cp ${SRC_DIR}/cleanup.ps1 ${BUILD_DIR}/
cp ${SRC_DIR}/README.md ${PKG_DIR}/usr/share/doc/${NAME}/
cp ${SRC_DIR}/LICENSE ${PKG_DIR}/usr/share/doc/${NAME}/

# Create wrapper script
cat > ${PKG_DIR}/usr/local/bin/${NAME} << 'WRAPPER'
#!/bin/bash
# Wrapper script for diskcleanup

SCRIPT_DIR="/opt/diskcleanup"
pwsh -File "${SCRIPT_DIR}/cleanup.ps1" "$@"
WRAPPER

chmod +x ${PKG_DIR}/usr/local/bin/${NAME}

# Create control file
cat > ${PKG_DIR}/DEBIAN/control << EOF
Package: ${NAME}
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: all
Depends: powershell (>= 7.0)
Maintainer: chibuenyim <chibuenyim@users.noreply.github.com>
Description: Cross-platform disk cleanup utility
 Universal Disk Cleanup Tool is a powerful utility designed to free up
 valuable disk space by removing temporary files, caches, logs, and
 other junk that accumulates over time.
 .
 It supports cleaning:
  - Temporary files and caches
  - Browser caches (Chrome, Firefox, Brave, etc.)
  - Developer tool caches (npm, yarn, pip, Docker, etc.)
  - Package manager caches (apt, dnf, yum, etc.)
  - Application caches (Spotify, Discord, Slack, etc.)
  - System files and logs
 .
 This package works on Debian, Ubuntu, and other deb-based distributions.
