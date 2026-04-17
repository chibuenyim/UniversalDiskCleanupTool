#!/bin/bash
# Build Debian Package for Universal Disk Cleanup Tool

set -e

VERSION="2.0.0"
PACKAGE_NAME="diskcleanup"
WORK_DIR="build"
DEBIAN_DIR="$WORK_DIR/debian"

echo "=========================================="
echo "  Building Debian Package"
echo "=========================================="
echo ""

# Clean previous builds
rm -rf "$WORK_DIR"

# Create directory structure
mkdir -p "$DEBIAN_DIR/DEBIAN"
mkdir -p "$DEBIAN_DIR/usr/local/bin"
mkdir -p "$DEBIAN_DIR/usr/share/applications"
mkdir -p "$DEBIAN_DIR/usr/share/pixmaps"

# Copy files
cp cleanup.ps1 "$DEBIAN_DIR/usr/local/bin/cleanup.ps1"
cp install.sh "$DEBIAN_DIR/usr/local/bin/diskcleanup-installer.sh"
cp diskcleanup.desktop "$DEBIAN_DIR/usr/share/applications/"

# Create control file
cat > "$DEBIAN_DIR/DEBIAN/control" << EOF
Package: $PACKAGE_NAME
Version: $VERSION
Section: utils
Priority: optional
Architecture: all
Depends: powershell (>= 7.0)
Maintainer: chibuenyim <chibuenyim@users.noreply.github.com>
Description: Universal disk cleanup utility
 A cross-platform disk cleanup utility for Windows, macOS, and Linux.
 Cleans temporary files, browser caches, developer caches, and more.
Homepage: https://github.com/chibuenyim/DiskCleanupTool
EOF

# Create postinst script
cat > "$DEBIAN_DIR/DEBIAN/postinst" << 'EOF'
#!/bin/bash
set -e

# Create wrapper script
cat > /usr/local/bin/cleanup << 'WRAPPER'
#!/bin/bash
pwsh -NoProfile -ExecutionPolicy Bypass -File /usr/local/bin/cleanup.ps1 "$@"
WRAPPER

chmod +x /usr/local/bin/cleanup

# Create symlink
ln -sf /usr/local/bin/cleanup /usr/local/bin/diskcleanup

echo "Disk Cleanup Tool installed successfully!"
echo "Run 'cleanup --help' for usage information."

#DEBHELPER#

exit 0
EOF

chmod +x "$DEBIAN_DIR/DEBIAN/postinst"

# Create prerm script
cat > "$DEBIAN_DIR/DEBIAN/prerm" << 'EOF'
#!/bin/bash
set -e

# Remove symlinks
rm -f /usr/local/bin/diskcleanup

#DEBHELPER#

exit 0
EOF

chmod +x "$DEBIAN_DIR/DEBIAN/prerm"

# Calculate installed size
INSTALLED_SIZE=$(du -sk "$DEBIAN_DIR" | cut -f1)
echo "Installed-Size: $INSTALLED_SIZE" >> "$DEBIAN_DIR/DEBIAN/control"

# Build the package
dpkg-deb --build "$DEBIAN_DIR" "${PACKAGE_NAME}_${VERSION}_all.deb"

echo ""
echo "=========================================="
echo "  Build Complete!"
echo "=========================================="
echo ""
echo "Package: ${PACKAGE_NAME}_${VERSION}_all.deb"
echo "Size: $(stat -f%z "${PACKAGE_NAME}_${VERSION}_all.deb" 2>/dev/null || stat -c%s "${PACKAGE_NAME}_${VERSION}_all.deb") bytes"
echo ""
echo "To install:"
echo "  sudo dpkg -i ${PACKAGE_NAME}_${VERSION}_all.deb"
echo ""
