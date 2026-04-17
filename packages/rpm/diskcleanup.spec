Name:           diskcleanup
Version:        3.0.0
Release:        1%{?dist}
Summary:        Cross-platform disk cleanup utility

License:        MIT
URL:            https://github.com/chibuenyim/UniversalDiskCleanupTool
Source0:        %{name}-%{version}.tar.gz

Requires:       pwsh >= 7.0

BuildArch:      noarch

%description
Universal Disk Cleanup Tool is a powerful utility designed to free up
valuable disk space by removing temporary files, caches, logs, and
other junk that accumulates over time.

It supports cleaning:
 - Temporary files and caches
 - Browser caches (Chrome, Firefox, Brave, etc.)
 - Developer tool caches (npm, yarn, pip, Docker, etc.)
 - Package manager caches (apt, dnf, yum, etc.)
 - Application caches (Spotify, Discord, Slack, etc.)
 - System files and logs

%prep
%autosetup

%install
mkdir -p %{buildroot}%{_datadir}/%{name}
mkdir -p %{buildroot}%{_bindir}

install -m 644 cleanup.ps1 %{buildroot}%{_datadir}/%{name}/
install -m 644 README.md %{buildroot}%{_datadir}/%{name}/
install -m 644 LICENSE %{buildroot}%{_datadir}/%{name}/

# Create wrapper script
cat > %{buildroot}%{_bindir}/%{name} << 'WRAPPER'
#!/bin/bash
pwsh -File "%{_datadir}/%{name}/cleanup.ps1" "$@"
WRAPPER

chmod +x %{buildroot}%{_bindir}/%{name}

%files
%{_bindir}/%{name}
%{_datadir}/%{name}/*

%doc README.md
%license LICENSE

%changelog
* $(date +'%a %b %d %Y') chibuenyim <chibuenyim@users.noreply.github.com> - 3.0.0-1
- Initial package release
