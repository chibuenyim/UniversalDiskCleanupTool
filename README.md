# 🧹 Universal Disk Cleanup Tool

**A cross-platform disk cleanup utility for Windows, macOS, and Linux**

![Version](https://img.shields.io/badge/version-3.0.0-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![PowerShell](https://img.shields.io/badge/PowerShell-7%2B-blue.svg)

---

## 📖 About

**Universal Disk Cleanup Tool** is a powerful, cross-platform disk cleanup utility designed to free up valuable disk space by removing temporary files, caches, logs, and other junk that accumulates over time.

Built with PowerShell Core 7+, it provides comprehensive cleaning capabilities across all major operating systems:

- **Windows 10/11** - Full cleanup of Windows-specific locations
- **macOS 10.14+** - Enhanced cleanup for Apple systems
- **Linux** - Universal support for all major distributions

### What Makes It Different?

Unlike traditional cleanup tools that only scratch the surface, Universal Disk Cleanup Tool goes deep:

- **60+ cache locations** covering browsers, development tools, applications, and system files
- **15+ package managers** including npm, yarn, pip, Homebrew, apt, dnf, pacman, and more
- **20+ developer tools** from Docker to Go, from Gradle to Maven
- **Safe by default** - Only removes junk, never your personal files or projects
- **Selective cleaning** - Choose exactly what to clean with granular options
- **Cross-platform consistency** - Same experience across all platforms

### Who Is It For?

- **Developers** - Clean up npm, yarn, pip, Docker, and other development caches (saves 10-20 GB)
- **Designers** - Remove Adobe CC cache, thumbnails, and application junk (saves 5-15 GB)
- **Power Users** - Comprehensive system cleanup for maximum space recovery (saves 15-35 GB)
- **IT Professionals** - Maintain systems and free up disk space across platforms
- **Anyone** running out of disk space on any platform

### Expected Results

- **Basic users**: 2-5 GB freed
- **Web browsing**: 3-8 GB freed
- **Developers**: 10-25 GB freed
- **Designers/creators**: 8-20 GB freed
- **Power users**: 15-35 GB freed

---

## ✨ Features

- 🌍 **Cross-Platform** - Works on Windows, macOS, and Linux
- 🧹 **Comprehensive Cleaning** - Removes temp files, caches, logs, and more
- 🚀 **Fast & Efficient** - Quickly frees up gigabytes of space
- 🔒 **Safe** - Only removes junk files, never your personal data
- 🎯 **Selective** - Choose what to clean with command-line options
- 📦 **Portable** - No installation required (optional install available)

### 🆕 v3.0 Highlights

#### 🍎 macOS
- **7 browsers**: Safari, Chrome, Firefox, Brave, Edge, Opera, Vivaldi
- **15+ dev tools**: npm, yarn, pip, Poetry, Homebrew, CocoaPods, Carthage, Swift PM, Go, Cargo, Gradle, Maven, Docker
- **9 apps**: Adobe CC, Spotify, Discord, Slack, Teams, Zoom, Telegram, VSCode, JetBrains
- **Enhanced system**: Font cache, thumbnails, Time Machine detection, iOS backup warnings

#### 🐧 Linux
- **10+ package managers**: apt, dnf, yum, pacman, zypper, swupd, xbps, apk, snap, flatpak
- **7 browsers**: Chrome, Firefox, Brave, Chromium, Edge, Opera, Vivaldi
- **15+ dev tools**: npm, yarn, pnpm, pip, Poetry, Composer, Go, Cargo, Gradle, Maven, Docker
- **8 apps**: Spotify, Discord, Slack, Teams, Zoom, Telegram, VSCode, JetBrains
- **Enhanced system**: journalctl logs, thumbnails, font cache, icon cache

#### 💻 Windows
- **6 browsers**: Chrome, Edge, Firefox, Brave, Opera, Vivaldi
- **15+ dev tools**: npm, yarn, pnpm, pip, Poetry, Composer, NuGet, Maven, Gradle, Go, Cargo, Flutter, Docker
- **9 apps**: Adobe CC, Spotify, Discord, Slack, Teams, Zoom, Telegram, Steam, Epic Games
- **Enhanced system**: WER, logs, Defender, thumbnails, Recycle Bin, Windows Update cleanup

---

## 🚀 Quick Start

### 🍎 macOS

```bash
# Using Homebrew (recommended)
brew install diskcleanup

# Or download and run directly
curl -LO https://raw.githubusercontent.com/chibuenyim/UniversalDiskCleanupTool/main/cleanup.ps1
pwsh -File cleanup.ps1 --all
```

### 🐧 Linux

```bash
# Ubuntu/Debian
wget https://github.com/chibuenyim/UniversalDiskCleanupTool/releases/download/v3.0.0/diskcleanup_3.0.0_all.deb
sudo dpkg -i diskcleanup_3.0.0_all.deb

# Fedora/RHEL
wget https://github.com/chibuenyim/UniversalDiskCleanupTool/releases/download/v3.0.0/diskcleanup-3.0.0-1.noarch.rpm
sudo dnf install diskcleanup-3.0.0-1.noarch.rpm

# Or run directly with PowerShell
curl -LO https://raw.githubusercontent.com/chibuenyim/UniversalDiskCleanupTool/main/cleanup.ps1
pwsh -File cleanup.ps1 --all
```

### 💻 Windows

```powershell
# Download and run
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/chibuenyim/UniversalDiskCleanupTool/main/cleanup.ps1" -OutFile "cleanup.ps1"
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
.\cleanup.ps1 --all
```

### 📦 Clone Repository

```bash
git clone https://github.com/chibuenyim/UniversalDiskCleanupTool.git
cd UniversalDiskCleanupTool
pwsh -File cleanup.ps1 --all
```

---

## 🎯 Usage

```bash
cleanup [OPTIONS]
```

### Options

| Option | Description | Category |
|--------|-------------|----------|
| `--All` | Clean everything (recommended) | All |
| `--Temp` | Clean temporary files only | Basic |
| `--Browser` | Clean browser caches only | Basic |
| `--Dev` | Clean developer caches only | Advanced |
| `--Logs` | Clean system logs only | Basic |
| `--Cache` | Clean package caches only | Advanced |
| `--Apps` | Clean application caches only | Advanced |
| `--System` | Clean system files only | Advanced |
| `--Quiet` | Suppress output | Modifier |
| `--Verbose` | Show detailed output | Modifier |
| `--Help` | Show help message | Info |

### Examples

```bash
# Clean everything (recommended)
cleanup --all

# Quick cleanup - only temp files and browsers
cleanup --temp --browser

# After development work - clean dev caches
cleanup --dev --cache

# Full system cleanup with details
cleanup --all --verbose

# Clean only package managers
cleanup --cache

# Safe cleanup - no admin required
cleanup --temp --browser
```

---

## 🗑️ What It Cleans

### 📁 Temporary Files (~500 MB - 5 GB)

**All Platforms:**
- System temp directories (`/tmp`, `/var/tmp`, `%TEMP%`)
- User temp folders (`~/.cache`, `$HOME/Library/Caches`, `%LOCALAPPDATA%\Temp`)
- Application-specific temp files
- Prefetch data (Windows)
- Thumbnail caches

### 🌐 Browser Caches (~200 MB - 2 GB)

**Supported Browsers:**
| Browser | Windows | macOS | Linux |
|---------|---------|-------|-------|
| Chrome | ✅ | ✅ | ✅ |
| Firefox | ✅ | ✅ | ✅ |
| Safari | ❌ | ✅ | ❌ |
| Edge | ✅ | ✅ | ✅ |
| Brave | ✅ | ✅ | ✅ |
| Opera | ✅ | ✅ | ✅ |
| Vivaldi | ✅ | ✅ | ✅ |
| Chromium | ❌ | ❌ | ✅ |

**What Gets Cleaned:**
- Browser cache
- Code cache
- Image cache
- Temporary internet files
- Session restore data

**What's SAFE:**
- History, bookmarks, saved passwords
- Cookies, extensions, settings
- User preferences and themes

### 👨‍💻 Developer Caches (~8-25 GB)

**Package Managers:**
| Tool | Windows | macOS | Linux | Size |
|------|---------|-------|-------|------|
| npm | ✅ | ✅ | ✅ | ~3-8 GB |
| yarn | ✅ | ✅ | ✅ | ~1-3 GB |
| pnpm | ✅ | ✅ | ✅ | ~500 MB - 2 GB |
| pip | ✅ | ✅ | ✅ | ~100-500 MB |
| Poetry | ✅ | ✅ | ✅ | ~100-500 MB |
| Composer | ✅ | ❌ | ✅ | ~1-4 GB |
| NuGet | ✅ | ❌ | ❌ | ~500 MB - 2 GB |
| Homebrew | ❌ | ✅ | ❌ | ~500 MB - 2 GB |
| MacPorts | ❌ | ✅ | ❌ | ~100-500 MB |
| apt | ❌ | ❌ | ✅ | ~500 MB - 3 GB |
| dnf | ❌ | ❌ | ✅ | ~500 MB - 2 GB |
| yum | ❌ | ❌ | ✅ | ~500 MB - 2 GB |
| pacman | ❌ | ❌ | ✅ | ~500 MB - 2 GB |
| zypper | ❌ | ❌ | ✅ | ~100-500 MB |
| snap | ❌ | ❌ | ✅ | Variable |
| flatpak | ❌ | ❌ | ✅ | Variable |

**Development Tools:**
| Tool | Windows | macOS | Linux | Cache Location |
|------|---------|-------|-------|----------------|
| Go | ✅ | ✅ | ✅ | `~/go/pkg/mod` |
| Cargo (Rust) | ✅ | ✅ | ✅ | `~/.cargo/registry` |
| Maven | ✅ | ✅ | ✅ | `~/.m2/repository` |
| Gradle | ✅ | ✅ | ✅ | `~/.gradle/caches` |
| Docker | ✅ | ✅ | ✅ | Images, containers, volumes |
| Xcode | ❌ | ✅ | ❌ | `~/Library/Developer/Xcode/DerivedData` |
| CocoaPods | ❌ | ✅ | ❌ | `~/Library/Caches/CocoaPods` |
| Carthage | ❌ | ✅ | ❌ | `~/Library/Caches/org.carthage.CarthageKit` |
| VS Code | ✅ | ✅ | ✅ | Extension cache data |
| JetBrains | ✅ | ✅ | ✅ | IDE caches |
| Playwright | ✅ | ❌ | ❌ | `~/AppData/Local/ms-playwright` |
| Cypress | ✅ | ❌ | ❌ | `~/AppData/Local/Cypress` |
| Selenium | ✅ | ❌ | ❌ | `~/AppData/Local/selenium` |
| Flutter | ✅ | ✅ | ❌ | `~/AppData/Local/Pub/Cache` |
| Android SDK | ✅ | ❌ | ❌ | `~/AppData/Local/Android/Sdk/.cache` |

### 🎮 Application Caches (~1-8 GB)

**Productivity & Communication:**
| Application | Windows | macOS | Linux | Size |
|------------|---------|-------|-------|------|
| Adobe CC | ✅ | ✅ | ❌ | ~500 MB - 2 GB |
| Spotify | ✅ | ✅ | ✅ | ~500 MB - 2 GB |
| Discord | ✅ | ✅ | ✅ | ~200-500 MB |
| Slack | ✅ | ✅ | ✅ | ~100-300 MB |
| Teams | ✅ | ✅ | ✅ | ~200-500 MB |
| Zoom | ✅ | ✅ | ✅ | ~100-300 MB |
| Telegram | ✅ | ✅ | ✅ | ~100-500 MB |

**Development & Gaming:**
| Application | Windows | macOS | Linux | Size |
|------------|---------|-------|-------|------|
| Steam | ✅ | ❌ | ❌ | ~500 MB - 2 GB |
| Epic Games | ✅ | ❌ | ❌ | ~200-500 MB |
| VS Code | ✅ | ✅ | ✅ | ~100-500 MB |
| JetBrains IDEs | ✅ | ✅ | ✅ | ~200-500 MB |

**Creative Tools:**
| Application | Windows | macOS | Linux | Size |
|------------|---------|-------|-------|------|
| Blender | ✅ | ❌ | ✅ | ~100-300 MB |
| GIMP | ✅ | ❌ | ✅ | ~50-200 MB |
| Inkscape | ✅ | ❌ | ✅ | ~50-200 MB |
| VLC | ✅ | ❌ | ✅ | ~50-200 MB |

### 📋 System Files (~1-15 GB)

**Windows:**
| Component | Location | Space Saved |
|-----------|----------|-------------|
| Windows Update | `C:\Windows\SoftwareDistribution\Download` | ~1-3 GB |
| WinSxS | `C:\Windows\WinSxS` (via DISM) | ~2-6 GB |
| Recycle Bin | `C:\$Recycle.Bin` | Variable |
| Windows Error Reporting | `C:\ProgramData\Microsoft\Windows\WER` | ~100-500 MB |
| Windows Logs | `C:\Windows\Logs` | ~100-500 MB |
| CBS Logs | `C:\Windows\Logs\CBS` | ~50-200 MB |
| Defender | `C:\ProgramData\Microsoft\Windows Defender\Scans\History\Store` | ~200-500 MB |
| Search | `C:\ProgramData\Microsoft\Search\Data` | ~100-300 MB |
| Thumbnails | `%LOCALAPPDATA%\Microsoft\Windows\Explorer` | ~100-500 MB |
| Font Cache | `C:\Windows\ServiceProfiles\LocalService\AppData\Local\FontCache` | ~100-300 MB |

**macOS:**
| Component | Location | Space Saved |
|-----------|----------|-------------|
| System Logs | `/Library/Logs`, `~/Library/Logs` | ~200-500 MB |
| ASL Logs | `/var/log/asl` | ~100-500 MB |
| Diagnostic Reports | `~/Library/Logs/DiagnosticReports` | ~100-500 MB |
| Font Cache | System and user font caches | ~100-300 MB |
| Thumbnails | Various thumbnail caches | ~50-200 MB |
| Time Machine | Snapshots (detected, requires manual action) | Variable |

**Linux:**
| Component | Location | Space Saved |
|-----------|----------|-------------|
| Journal Logs | `/var/log/journal` | ~500 MB - 2 GB |
| System Logs | `/var/log` | ~100-500 MB |
| Package Cache | Varies by package manager | ~500 MB - 3 GB |
| Thumbnails | `~/.cache/thumbnails`, `~/.thumbnails` | ~100-300 MB |
| Font Cache | `~/.cache/fontconfig` | ~50-200 MB |
| Icon Cache | `~/.cache/icons` | ~50-200 MB |

---

## 🚫 What It Does NOT Clean

**Your personal files are always safe:**

❌ User documents (Documents, Desktop, Downloads)
❌ Personal files (photos, videos, music, documents)
❌ Application settings and preferences
❌ Installed programs and applications
❌ System files required for operation
❌ Browser history, bookmarks, saved passwords
❌ Game saves and progress
❌ Email data and messages
❌ Database files
❌ Your project files and source code
❌ Configuration files (.bashrc, .zshrc, etc.)

**Only temporary files, caches, and safe-to-remove system files are cleaned.**

---

## 📊 Expected Space Savings

### By User Type

| User Type | Base Savings | With Dev Caches | Total Range |
|-----------|--------------|-----------------|-------------|
| **Basic User** | 2-5 GB | N/A | 2-5 GB |
| **Web Browsing** | 3-8 GB | N/A | 3-8 GB |
| **Developer** | 2-5 GB | +8-20 GB | 10-25 GB |
| **Designer/Creator** | 3-8 GB | +5-12 GB | 8-20 GB |
| **Power User** | 5-10 GB | +10-25 GB | 15-35 GB |

### Real-World Examples

```
# macOS Developer Machine
Before: 5.2 GB free
After:  22.4 GB free
Freed:  17.2 GB

Breakdown:
- Browser caches: 850 MB
- Developer caches: 12.3 GB
- System temp: 1.2 GB
- System logs: 2.85 GB
```

```
# Linux Power User
Before: 12.8 GB free
After:  45.6 GB free
Freed:  32.8 GB

Breakdown:
- npm cache: 6.2 GB
- Docker: 8.1 GB
- Package managers: 4.5 GB
- System: 14.05 GB
```

```
# Windows Basic User
Before: 2.1 GB free
After:  8.7 GB free
Freed:  6.6 GB

Breakdown:
- Browser caches: 1.8 GB
- Temp files: 2.4 GB
- Windows Update: 2.4 GB
```

---

## 📋 Requirements

- **PowerShell 7+** (pwsh)
- **Administrator/root privileges** for system cleaning
- **Supported Operating Systems:**
  - Windows 10/11
  - macOS 10.14+ (Mojave or later)
  - Linux (Ubuntu 20.04+, Fedora 35+, Arch Linux, Debian, openSUSE, etc.)

### Installing PowerShell 7+

**macOS:**
```bash
brew install powershell
```

**Linux (Ubuntu/Debian):**
```bash
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y powershell
```

**Linux (Fedora):**
```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo dnf install -y powershell
```

**Linux (Arch):**
```bash
yay -S powershell
```

**Windows:**
PowerShell 7+ is included with Windows 10/11 or can be installed from the Microsoft Store.

---

## 🛠️ Troubleshooting

### "PowerShell not found"

**Install PowerShell 7+** using the instructions above.

### "Permission denied"

```bash
# Make script executable
chmod +x cleanup.ps1
pwsh -File cleanup.ps1 --all
```

### "Cannot clean system files"

Run with elevated privileges:

```bash
# Linux/macOS
sudo pwsh -File cleanup.ps1 --all

# Windows (Run as Administrator)
# Right-click PowerShell → "Run as Administrator"
```

### "Script is disabled on this system"

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### DISM cleanup takes too long (Windows)

This is normal! DISM cleanup of WinSxS can take 10-30 minutes. You can skip this by using `--no-update` flag or unchecking "Clean Windows Update Residues" in GUI versions.

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
✅ Build artifacts
✅ Package manager downloads

### What's Protected

❌ User documents and files
❌ Desktop and Downloads
❌ Browser history, bookmarks, passwords
❌ Application settings
❌ Installed programs
❌ System files
❌ Configuration files
❌ Source code and projects

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

- Additional platform support (BSD, Solaris, etc.)
- More cache locations
- Performance improvements
- Bug fixes
- Documentation improvements
- Localization/i18n

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
