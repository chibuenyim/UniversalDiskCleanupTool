╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║         🧹 UNIVERSAL DISK CLEANUP TOOL v5.0                ║
║         ===============================                      ║
║                                                              ║
║         For macOS and Linux                                 ║
║         Free up to 40 GB of disk space!                    ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝


QUICK START
════════════

1. Install PowerShell 7+
2. Run: ./start.sh
3. Choose what to clean
4. Wait for it to finish
5. Enjoy your free space!


INSTALL POWERSHELL
═════════════════

macOS:
  brew install powershell

Linux (Ubuntu/Debian):
  sudo apt-get install -y powershell

Linux (Fedora):
  sudo dnf install -y powershell


WHAT IT CLEANS
═════════════

✓ Temporary files          → 500 MB - 3 GB
✓ Browser caches           → 300 MB - 2 GB
✓ Developer caches         → 8-25 GB
✓ Package caches           → 1-5 GB
✓ Application caches       → 1-5 GB
✓ System files             → 2-8 GB

Total: 20-40 GB of space freed!


IS IT SAFE?
══════════

YES! It only cleans:
  • Temporary files
  • Cache files
  • Package downloads
  • Build artifacts
  • System logs

It NEVER deletes:
  • Your documents
  • Your photos/videos
  • Your source code
  • Your settings


USAGE
═════

./start.sh              → Quick cleanup (everything)

Or use options:
pwsh -File cleanup.ps1 --Browser    → Clean browsers
pwsh -File cleanup.ps1 --Dev        → Clean dev tools
pwsh -File cleanup.ps1 --All        → Clean everything


PRESETS
═══════

⚡ Quick Cleanup    → Everything in one go
🔧 Custom Cleanup   → Choose specific categories
💪 Deep Cleanup     → Maximum space savings


TIPS
════

• First time? Just run ./start.sh
• Developer? Add --Dev for extra cleanup
• Run monthly for best results
• Safe to run anytime


TROUBLESHOOTING
═══════════════

Permission denied?
  → chmod +x start.sh

PowerShell not found?
  → Install PowerShell 7+ (see above)

Need more space?
  → pwsh -File cleanup.ps1 --All


EXPECTED RESULTS
═══════════════

macOS:
  Before:  8 GB free
  After:   28 GB free
  Freed:   20 GB

Linux:
  Before:  5 GB free
  After:   35 GB free
  Freed:   30 GB


SUPPORT
═══════

Website: https://github.com/chibuenyim/UniversalDiskCleanupTool
Issues:  https://github.com/chibuenyim/UniversalDiskCleanupTool/issues


VERSION 5.0.0
═════════════

✓ Cleaner interface
✓ Faster cleanup
✓ Better progress tracking
✓ More safety features
✓ Easier than ever


Thank you for using Universal Disk Cleanup Tool! 🎉
