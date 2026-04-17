Name:           diskcleanup
Version:        2.0.0
Release:        1%{?dist}
Summary:        Universal disk cleanup utility
License:        MIT
URL:            https://github.com/chibuenyim/DiskCleanupTool
Source0:        %{name}-%{version}.tar.gz

Requires:       powershell >= 7.0

%description
A cross-platform disk cleanup utility for Windows, macOS, and Linux.
Cleans temporary files, browser caches, developer caches, and more.

%prep
%autosetup

%build
# No build required

%install
rm -rf %{buildroot}

# Create directories
mkdir -p %{buildroot}/usr/local/bin
mkdir -p %{buildroot}/usr/share/applications
mkdir -p %{buildroot}/usr/share/doc/%{name}

# Install files
install -m 644 cleanup.ps1 %{buildroot}/usr/local/bin/
install -m 755 install.sh %{buildroot}/usr/local/bin/diskcleanup-installer.sh
install -m 644 diskcleanup.desktop %{buildroot}/usr/share/applications/
install -m 644 README.md %{buildroot}/usr/share/doc/%{name}/
install -m 644 LICENSE %{buildroot}/usr/share/doc/%{name}/

# Create wrapper script
cat > %{buildroot}/usr/local/bin/cleanup << 'EOF'
#!/bin/bash
pwsh -NoProfile -ExecutionPolicy Bypass -File /usr/local/bin/cleanup.ps1 "$@"
EOF
chmod +x %{buildroot}/usr/local/bin/cleanup

%files
/usr/local/bin/cleanup.ps1
/usr/local/bin/cleanup
/usr/local/bin/diskcleanup-installer.sh
/usr/share/applications/diskcleanup.desktop
/usr/share/doc/%{name}/*
%license LICENSE

%post
# Create symlink
ln -sf /usr/local/bin/cleanup /usr/local/bin/diskcleanup 2>/dev/null || true

echo "Disk Cleanup Tool installed successfully!"
echo "Run 'cleanup --help' for usage information."

%preun
# Remove symlink
rm -f /usr/local/bin/diskcleanup 2>/dev/null || true

%changelog
* $(date +'%a %b %d %Y') chibuenyim <chibuenyim@users.noreply.github.com> - 2.0.0-1
- Initial package release
