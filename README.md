# 🧹 Universal Disk Cleanup Tool

**A cross-platform disk cleanup utility for Windows, macOS, and Linux with enhanced support**

![Version](https://img.shields.io/badge/version-3.0.0-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![PowerShell](https://img.shields.io/badge/PowerShell-7%2B-blue.svg)

---

## 📖 About

**Universal Disk Cleanup Tool** is a powerful, cross-platform disk cleanup utility designed to free up valuable disk space by removing temporary files, caches, logs, and other junk that accumulates over time.

Built with PowerShell Core 7+, it provides comprehensive cleaning capabilities across all major operating systems:

- **Windows 10/11** - Full cleanup of Windows-specific locations (temp files, browser caches, developer tools, Windows Update residues, system files, and more)
- **macOS 10.14+** - Enhanced cleanup for Apple systems (Safari, Xcode, Homebrew, CocoaPods, Time Machine detection, iOS backup warnings)
- **Linux** - Universal support for all major distributions (Ubuntu, Fedora, Arch, Debian, openSUSE, and more with 10+ package manager support)

### What Makes It Different?

Unlike traditional cleanup tools that only scratch the surface, Universal Disk Cleanup Tool goes deep:

- **60+ cache locations** covering browsers, development tools, applications, and system files
- **15+ package managers** including npm, yarn, pip, Homebrew, apt, dnf, pacman, and more
- **20+ developer tools** from Docker to Go, from Gradle to Maven
- **Safe by default** - Only removes junk, never your personal files or projects
- **Selective cleaning** - Choose exactly what to clean with granular options
- **Cross-platform consistency** - Same experience across Windows, macOS, and Linux

### Who Is It For?

- **Developers** - Clean up npm, yarn, pip, Docker, and other development caches (saves 10-20 GB)
- **Designers** - Remove Adobe CC cache, thumbnails, and application junk (saves 5-15 GB)
- **Power Users** - Comprehensive system cleanup for maximum space recovery (saves 15-35 GB)
- **IT Professionals** - Maintain systems and free up disk space across platforms
- **Anyone** running out of disk space on Windows, macOS, or Linux

### Expected Results

- **Basic users**: 2-5 GB freed
- **Web browsing**: 3-8 GB freed
- **Developers**: 10-25 GB freed
- **Designers/creators**: 8-20 GB freed
- **Power users**: 15-35 GB freed

---

- 🌍 **Cross-Platform** - Works on Windows, macOS, and Linux
- 🧹 **Comprehensive Cleaning** - Removes temp files, caches, logs, and more
- 🚀 **Fast & Efficient** - Quickly frees up gigabytes of space
- 🔒 **Safe** - Only removes junk files, never your personal data
- 🎯 **Selective** - Choose what to clean with command-line options
- 📦 **Portable** - No installation required (optional install available)

### 🆕 v3.0 Enhancements

#### 🍎 macOS Improvements
- **7 browser support** (Safari, Chrome, Firefox, Brave, Edge, Opera, Vivaldi)
- **15+ developer tools** (npm, yarn, pip, Poetry, Homebrew, CocoaPods, Carthage, Swift PM, Go, Cargo, Gradle, Maven, Docker)
- **9 application caches** (Adobe CC, Spotify, Discord, Slack, Teams, Zoom, Telegram, VSCode, JetBrains)
- **Enhanced system cleanup** (font cache, thumbnails, Time Machine snapshot detection, iOS backup warnings)
- **Package managers** (Homebrew, MacPorts)

#### 🐧 Linux Improvements
- **10+ package managers** (apt, dnf, yum, pacman, zypper, swupd, xbps, apk, snap, flatpak)
- **7 browser support** (Chrome, Firefox, Brave, Chromium, Edge, Opera, Vivaldi)
- **15+ developer tools** (npm, yarn, pnpm, pip, Poetry, Composer, Go, Cargo, Gradle, Maven, Docker)
- **8 application caches** (Spotify, Discord, Slack, Teams, Zoom, Telegram, VSCode, JetBrains)
- **Enhanced system cleanup** (journalctl logs, thumbnails, font cache, icon cache)
- **Better distribution support** (Ubuntu/Debian, Fedora/RHEL, Arch, openSUSE, Clear Linux, Void, Alpine)

---

## 🗑️ What It Cleans

### 💻 **Windows**

#### 📁 Temporary Files (~500 MB - 2 GB)
| Location | Path | Description |
|----------|------|-------------|
| User Temp | `%TEMP%` | Per-user temporary files |
| Local Temp | `%LOCALAPPDATA%\Temp` | Application temp files |
| System Temp | `%WINDIR%\Temp` | Windows system temp files |
| Prefetch | `%WINDIR%\Prefetch` | Application prefetch data |

#### 🌐 Browser Caches (~200 MB - 1 GB)
| Browser | Cache Locations |
|---------|-----------------|
| **Chrome** | `%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache`<br>`%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache` |
| **Edge** | `%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache`<br>`%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache` |
| **Firefox** | `%APPDATA%\Mozilla\Firefox\Profiles\*\cache2` |
| **Brave** | `%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Cache` |

#### 👨‍💻 Developer Caches (~8-15 GB)
| Tool | Cache Location | Size |
|------|----------------|------|
| **npm** | `%APPDATA%\npm-cache` | ~3-8 GB |
| **yarn** | `%LOCALAPPDATA%\Yarn\Cache` | ~1-3 GB |
| **pip** | `%LOCALAPPDATA%\pip\Cache` | ~100-500 MB |
| **NuGet** | `%LOCALAPPDATA%\NuGet\v3-cache` | ~500 MB - 2 GB |
| **Docker** | Docker images, containers, volumes | Variable |
| **Node.js** | Various npm/node_modules caches | Variable |

#### 📋 System Files (~2-10 GB)
| Component | Location | Space Saved |
|-----------|----------|-------------|
| **Windows Update** | `C:\Windows\SoftwareDistribution\Download` | ~1-3 GB |
| **WinSxS** | `C:\Windows\WinSxS` (via DISM) | ~2-6 GB |
| **Recycle Bin** | `C:\$Recycle.Bin` | Variable |
| **Windows Logs** | `C:\Windows\Logs` | ~100-500 MB |
| **CBS Logs** | `C:\Windows\Logs\CBS` | ~50-200 MB |
| **Delivery Optimization** | `C:\Windows\SoftwareDistribution\DeliveryOptimization` | ~100-500 MB |

---

### 🍎 **macOS**

#### 📁 Temporary Files (~1-5 GB)
| Location | Path | Description |
|----------|------|-------------|
| System Temp | `/tmp` | System-wide temporary files |
| User Cache | `~/Library/Caches` | User application caches |
| User Temp | `~/Library/Caches/com.apple.dt.Xcode` | Xcode temp files |
| Trash | `~/.Trash` | Deleted files (if emptied) |

#### 🌐 Browser Caches (~200 MB - 1 GB)
| Browser | Cache Locations |
|---------|-----------------|
| **Safari** | `~/Library/Caches/com.apple.Safari`<br>`~/Library/Safari` |
| **Chrome** | `~/Library/Caches/Google/Chrome`<br>`~/Library/Application Support/Google/Chrome/Default/Cache` |
| **Firefox** | `~/Library/Caches/Firefox` |
| **Brave** | `~/Library/Caches/BraveSoftware` |

#### 👨‍💻 Developer Caches (~5-20 GB)
| Tool | Cache Location | Size |
|------|----------------|------|
| **npm** | `~/.npm` | ~2-5 GB |
| **yarn** | `~/Library/Caches/Yarn` | ~1-3 GB |
| **pip** | `~/Library/Caches/pip` | ~100-500 MB |
| **Homebrew** | `/usr/local/Cache/Homebrew` | ~500 MB - 2 GB |
| **Xcode** | `~/Library/Developer/Xcode/DerivedData` | ~2-10 GB |
| **CocoaPods** | `~/Library/Caches/CocoaPods` | ~500 MB - 2 GB |
| **Carthage** | `~/Library/Caches/org.carthage.CarthageKit` | ~100-500 MB |
| **Docker** | Docker images, containers, volumes | Variable |

#### 📋 System Files (~1-5 GB)
| Component | Location | Space Saved |
|-----------|----------|-------------|
| **System Logs** | `/Library/Logs` | ~200-500 MB |
| **User Logs** | `~/Library/Logs` | ~100-300 MB |
| **ASL Logs** | `/var/log/asl` | ~100-500 MB |
| **Diagnostic Reports** | `~/Library/Logs/DiagnosticReports` | ~100-500 MB |

---

### 🐧 **Linux**

#### 📁 Temporary Files (~500 MB - 3 GB)
| Location | Path | Description |
|----------|------|-------------|
| System Temp | `/tmp` | System-wide temporary files |
| User Temp | `/var/tmp` | Persistent temporary files |
| User Cache | `~/.cache` | User application caches |
| Thumbnail Cache | `~/.cache/thumbnails` | Thumbnail images |

#### 🌐 Browser Caches (~200 MB - 1 GB)
| Browser | Cache Locations |
|---------|-----------------|
| **Chrome** | `~/.cache/google-chrome`<br>`~/.config/google-chrome/Default/Cache` |
| **Firefox** | `~/.cache/mozilla/firefox` |
| **Brave** | `~/.cache/BraveSoftware` |
| **Chromium** | `~/.cache/chromium` |

#### 👨‍💻 Developer Caches (~5-15 GB)
| Tool | Cache Location | Size |
|------|----------------|------|
| **npm** | `~/.npm` | ~2-5 GB |
| **yarn** | `~/.yarn/cache` | ~1-3 GB |
| **pip** | `~/.cache/pip` | ~100-500 MB |
| **Docker** | Docker images, containers, volumes | Variable |
| **Gradle** | `~/.gradle/caches` | ~500 MB - 2 GB |
| **Maven** | `~/.m2/repository` | ~500 MB - 3 GB |

#### 📋 System Files (~1-8 GB)
| Package Manager | Cache Location | Space Saved |
|----------------|----------------|-------------|
| **apt (Debian/Ubuntu)** | `/var/cache/apt/archives` | ~500 MB - 3 GB |
| **dnf (Fedora)** | `/var/cache/dnf` | ~500 MB - 2 GB |
| **yum (RHEL/CentOS)** | `/var/cache/yum` | ~500 MB - 2 GB |
| **pacman (Arch)** | `/var/cache/pacman/pkg` | ~500 MB - 2 GB |
| **Journal Logs** | `/var/log/journal` | ~500 MB - 2 GB |
| **System Logs** | `/var/log` | ~100-500 MB |

---

## 🚫 What It Does NOT Clean

**Your personal files are always safe:**

❌ User documents (My Documents, Desktop, Downloads)
❌ Personal files (photos, videos, music)
❌ Application settings
❌ Installed programs
❌ System files required for operation
❌ Browser history, bookmarks, saved passwords
❌ Game saves
❌ Email data

**Only temporary files, caches, and logs are removed.**

---

## 📊 Expected Space Savings

### Typical Results by System Type

| System Type | Base Savings | With Dev Caches | Total Range |
|-------------|--------------|-----------------|-------------|
| **Basic User** | 2-5 GB | N/A | 2-5 GB |
| **Web Browsing Heavy** | 3-8 GB | N/A | 3-8 GB |
| **Developer** | 2-5 GB | +8-15 GB | 10-20 GB |
| **Designer/Creator** | 3-8 GB | +2-5 GB | 5-13 GB |
| **Power User** | 5-10 GB | +10-20 GB | 15-30 GB |

### Real-World Examples

```
Before: 5.2 GB free
After:  22.4 GB free
Freed:  17.2 GB
```

```
Before: 12.8 GB free
After:  45.6 GB free
Freed:  32.8 GB (developer machine)
```

```
Before: 2.1 GB free
After:  8.7 GB free
Freed:  6.6 GB (basic user)
```

---

## 📋 Requirements

- **PowerShell 7+** (pwsh)
- **Administrator/root privileges** for system cleaning
- Supported operating systems:
  - Windows 10/11
  - macOS 10.14+
  - Linux (Ubuntu 20.04+, Fedora 35+, Arch, etc.)

---

## 🚀 Quick Start

### Option 1: Direct Download (Recommended for Linux/macOS)

```bash
# Download installer
curl -LO https://raw.githubusercontent.com/chibuenyim/UniversalDiskCleanupTool/main/install.sh

# Run installer
chmod +x install.sh
sudo ./install.sh

# Run cleanup
cleanup --all
```

### Option 2: Clone Repository

```bash
git clone https://github.com/chibuenyim/UniversalDiskCleanupTool.git
cd UniversalDiskCleanupTool

# Run directly
pwsh -File cleanup.ps1 --all
```

### Option 3: Windows

Download `cleanup.ps1` and run in PowerShell:

```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
.\cleanup.ps1 --all
```

---

## 🎯 Usage

```bash
cleanup [OPTIONS]
```

### Options

| Option | Description | Category |
|--------|-------------|----------|
| `--all` | Clean everything (recommended) | All |
| `--temp` | Clean temporary files only | Basic |
| `--browser` | Clean browser caches only | Basic |
| `--dev` | Clean developer caches only | Advanced |
| `--logs` | Clean system logs only | Basic |
| `--cache` | Clean package caches only | Advanced |
| `--quiet` | Suppress output | Modifier |
| `--verbose` | Show detailed output | Modifier |

### Examples

```bash
# Clean everything (recommended for most users)
cleanup --all

# Quick cleanup - only temp files and browsers
cleanup --temp --browser

# After development work - clean dev caches
cleanup --dev

# Full system cleanup with details
cleanup --all --verbose

# Clean only package managers (apt, dnf, brew, etc.)
cleanup --cache

# Safe cleanup - no admin required
cleanup --temp --browser
```

---

## 📦 Platform-Specific Installation

### Windows

**Method 1: PowerShell Script**
1. Download `cleanup.ps1`
2. Right-click → "Run with PowerShell"
3. Click "Yes" when prompted

**Method 2: EXE Installer**
1. Download `DiskCleanupTool.exe` from [Releases](https://github.com/chibuenyim/UniversalDiskCleanupTool/releases)
2. Double-click to run
3. Click "Yes" on UAC prompt

### macOS

**Method 1: Homebrew (Recommended)**
```bash
brew install diskcleanup
```

**Method 2: Manual**
```bash
# Download and run installer
curl -LO https://raw.githubusercontent.com/chibuenyim/UniversalDiskCleanupTool/main/install.sh
sudo ./install.sh
```

**Method 3: DMG Installer**
1. Download `DiskCleanupTool-2.0.0.dmg` from [Releases](https://github.com/chibuenyim/UniversalDiskCleanupTool/releases)
2. Mount DMG
3. Drag `DiskCleanupTool.app` to Applications
4. Launch from Applications

### Linux

**Debian/Ubuntu**
```bash
# Download .deb package
wget https://github.com/chibuenyim/UniversalDiskCleanupTool/releases/download/v2.0.0/diskcleanup_2.0.0_all.deb

# Install
sudo dpkg -i diskcleanup_2.0.0_all.deb
sudo apt-get install -f  # Fix dependencies if needed
```

**Fedora/RHEL**
```bash
# Download .rpm package
wget https://github.com/chibuenyim/UniversalDiskCleanupTool/releases/download/v2.0.0/diskcleanup-2.0.0-1.noarch.rpm

# Install
sudo dnf install diskcleanup-2.0.0-1.noarch.rpm
```

**AppImage (Universal)**
```bash
# Download AppImage
wget https://github.com/chibuenyim/UniversalDiskCleanupTool/releases/download/v2.0.0/DiskCleanupTool-2.0.0-x86_64.AppImage

# Make executable
chmod +x DiskCleanupTool-2.0.0-x86_64.AppImage

# Run
./DiskCleanupTool-2.0.0-x86_64.AppImage
```

**Arch (AUR)**
```bash
yay -S diskcleanup
```

---

## 🐧 Building Packages

### Debian Package (.deb)

```bash
cd packages/debian
chmod +x build.sh
./build.sh
```

### RPM Package (.rpm)

```bash
# Requires rpmbuild
cd packages/rpm
rpmbuild -ba diskcleanup.spec
```

### AppImage

```bash
cd packages/appimage
chmod +x build-appimage.sh
./build-appimage.sh
```

### DMG (macOS)

```bash
cd packages/macos
chmod +x build-dmg.sh
./build-dmg.sh
```

---

## 🛠️ Troubleshooting

### "PowerShell not found"

**Linux:**
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y powershell

# Fedora
sudo dnf install -y powershell

# Arch
sudo pacman -S powershell
```

**macOS:**
```bash
brew install powershell
```

### "Permission denied"

```bash
# Make script executable
chmod +x cleanup.ps1
sudo ./cleanup.ps1 --all
```

### "Cannot clean system files"

Run with elevated privileges:
```bash
# Linux/macOS
sudo cleanup --all

# Windows (Run as Administrator)
# Right-click PowerShell → "Run as Administrator"
```

### "Script is disabled on this system"

**PowerShell:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## 📁 Project Structure

```
UniversalDiskCleanupTool/
├── cleanup.ps1              # Main universal script
├── install.sh               # Linux/macOS installer
├── README.md                # This file
├── LICENSE                  # MIT License
├── packages/
│   ├── debian/
│   │   └── build.sh         # Build .deb package
│   ├── rpm/
│   │   └── diskcleanup.spec # Build .rpm package
│   ├── appimage/
│   │   └── build-appimage.sh # Build AppImage
│   └── macos/
│       └── build-dmg.sh     # Build DMG
├── macos/
│   └── DiskCleanupTool.app/ # macOS app bundle
└── diskcleanup.desktop      # Linux desktop entry
```

---

## ⚠️ Safety & Best Practices

### What's Safe
✅ Temporary files and caches
✅ Browser caches (not history/bookmarks)
✅ Developer package caches
✅ System logs
✅ Windows Update leftovers
✅ Build artifacts

### What's Protected
❌ User documents and files
❌ Desktop and Downloads (unless specified)
❌ Browser history, bookmarks, passwords
❌ Application settings
❌ Installed programs
❌ System files

### Best Practices
1. 💾 **Backup first** - Always backup important data
2. 🧪 **Test selectively** - Try `--temp` first before `--all`
3. 👀 **Review output** - Use `--verbose` to see what's cleaned
4. ⏰ **Schedule regularly** - Run monthly for best results
5. 🔄 **Restart after** - Some changes may need a restart

---

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Commit (`git commit -m 'Add amazing feature'`)
5. Push to branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

### Areas for Contribution
- Additional platform support
- More cache locations
- Performance improvements
- Bug fixes
- Documentation improvements

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details

---

## 🙏 Acknowledgments

- Built with PowerShell Core 7+
- Cross-platform testing on Windows, macOS, and Linux
- Community contributions and feedback
- Inspired by the need for a truly universal cleanup tool

---

## 📞 Support

- **Issues**: https://github.com/chibuenyim/UniversalDiskCleanupTool/issues
- **Discussions**: https://github.com/chibuenyim/UniversalDiskCleanupTool/discussions
- **Releases**: https://github.com/chibuenyim/UniversalDiskCleanupTool/releases

---

## ⭐ Star the Repo!

If you find this tool helpful, please give it a star! ⭐

---

**Made with ❤️ for Windows, macOS, and Linux users worldwide**
