╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║         🧹 UNIVERSAL DISK CLEANUP TOOL v7.0.2              ║
║         ================================                       ║
║                                                              ║
║         For Windows, macOS, and Linux                       ║
║         Safe cleanup with real space measurement            ║
║         Browsers, Dev Tools, System Files, Caches           ║
║         Actual results verified after cleanup               ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝


QUICK START
══════════════

Windows:
  1. Double-click START.bat
  2. Choose what to clean in the GUI
  3. Click Start
  4. Done!

macOS/Linux:
  1. Install PowerShell 7+
  2. Run: ./start.sh --All
  3. Wait for cleanup
  4. Done!


INSTALL POWERSHELL
═════════════════

Windows:
  PowerShell 7+ included with Windows 10/11
  Or download from: https://github.com/PowerShell/PowerShell/releases

macOS:
  brew install powershell

Linux (Ubuntu/Debian):
  wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
  sudo dpkg -i packages-microsoft-prod.deb
  sudo apt-get update
  sudo apt-get install -y powershell

Linux (Fedora):
  sudo dnf install -y powershell


WHAT IT CLEANS
═════════════

Windows (60+ locations, 17-50GB potential):
  ✓ Temporary files          → 500 MB - 3 GB
  ✓ Browser caches           → 300 MB - 2 GB
  ✓ Developer caches         → 8-25 GB
  ✓ System files            → 5-20 GB
    • Windows Store Cache
    • Delivery Optimization Cache
    • Windows Defender Quarantine
    • System Restore Points (keeps 3 most recent)
    • Memory Dump Files
    • DirectX Shader Cache
    • Windows Ink Workspace
    • Retail Demo Content
    • Windows.old (with prompt)
    • Hiberfil.sys (with --DisableHibernation flag)
  ✓ Package caches          → 1-5 GB
  ✓ Application caches      → 1-5 GB

macOS (50+ locations, 2-17GB potential):
  ✓ Temporary files          → 500 MB - 3 GB
  ✓ Browser caches           → 300 MB - 2 GB
  ✓ Developer caches         → 8-25 GB
  ✓ System files            → 1-10 GB
    • Spotlight Index
    • QuickLook Cache
    • Mail Downloads (with prompt)
  ✓ Application caches      → 1-5 GB

Linux (45+ locations, 500MB-8GB potential):
  ✓ Package managers         → 2-8 GB
  ✓ Temporary files          → 200 MB - 2 GB
  ✓ Browser caches           → 200 MB - 1 GB
  ✓ Developer caches         → 5-15 GB
  ✓ Desktop environment caches → 100 MB - 5 GB
    • GNOME (dconf, GVFS, Evince)
    • KDE (Baloo index, thumbnails, Okular)
    • XFCE (Thunar thumbnails, config)
  ✓ Application caches      → 200 MB - 2 GB
  ✓ System files            → 100 MB - 1 GB

Actual space freed varies based on system usage and is shown after cleanup.


IS IT SAFE?
══════════

YES! We only clean:
  ✓ Temporary files
  ✓ Cache files
  ✓ Package downloads
  ✓ Build artifacts
  ✓ System logs
  ✓ Application caches

We NEVER touch:
  ✗ Your documents
  ✗ Your photos/videos
  ✗ Your source code
  ✗ Your settings
  ✗ Browser history
  ✗ Your passwords


USAGE EXAMPLES
═════════════

Windows:
  ./cleanup.ps1 --All                      # Clean everything
  ./cleanup.ps1 --All --DisableHibernation # Also remove hiberfil.sys
  ./cleanup.ps1 --DryRun --All             # Preview first
  ./cleanup.ps1 --ScanOnly --Dev           # Scan dev tools only

macOS/Linux:
  ./start.sh --All                         # Clean everything
  ./cleanup.ps1 --All                      # Clean everything
  ./cleanup.ps1 --DryRun --All             # Preview first


NEW IN v7.0.2
═════════════

22 New Safe Disk Space Techniques:
  • Windows Store Cache cleanup
  • Delivery Optimization Cache cleanup
  • Windows Defender Quarantine cleanup
  • System Restore Points cleanup (keeps 3 most recent)
  • Memory Dump Files cleanup
  • DirectX Shader Cache cleanup
  • Windows Ink Workspace cleanup
  • Retail Demo Content removal
  • Windows.old cleanup with interactive prompt
  • Hiberfil.sys removal (--DisableHibernation flag)
  • macOS Spotlight Index cleanup
  • macOS QuickLook Cache cleanup
  • macOS Mail Downloads cleanup
  • GNOME desktop environment caches
  • KDE desktop environment caches
  • XFCE desktop environment caches
  • Fixed config saving bug
  • Real disk space measurement only


FEATURES
═══════

✓ Cleans browsers, dev tools, system files, caches
✓ Real disk space measurement with filesystem sync
✓ Beautiful GUI for Windows
✓ Cross-platform (Windows, macOS, Linux)
✓ Desktop environment support (GNOME, KDE, XFCE)
✓ Interactive prompts for high-impact operations
✓ Safe - never deletes your documents
✓ Fast - cleans in minutes
✓ Actual space freed shown after cleanup
✓ Auto-installs PowerShell 7+ on Windows


SAFETY FEATURES
═════════════════

✓ Windows.old: Interactive prompt each time
✓ Hiberfil.sys: Requires --DisableHibernation flag + confirmation
✓ Mail Downloads: Interactive prompt each time (macOS)
✓ System Restore: Always keeps 3 most recent points
✓ All operations respect --DryRun and --ScanOnly modes


TIPS
═════

• First time? Just run START.bat or ./start.sh
• Windows user? Double-click START.bat for the GUI
• Developer? Choose "Developer Tools" in the GUI
• Maximum cleanup? Use --DisableHibernation on Windows
• Run monthly for best results
• Safe to run anytime
• Use --DryRun first to see what would be cleaned


LINKS
═════

Website:   https://github.com/chibuenyim/UniversalDiskCleanupTool
Releases:  https://github.com/chibuenyim/UniversalDiskCleanupTool/releases
Issues:    https://github.com/chibuenyim/UniversalDiskCleanupTool/issues


LICENSE
═══════

MIT License - Free to use, modify, and distribute


Version: 7.0.2 (Stable)
Date:    April 2026
Made with ❤️ for Windows, macOS, and Linux users worldwide
