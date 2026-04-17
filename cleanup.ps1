#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Universal Disk Cleanup Tool v3.0 - Cross-platform disk cleanup utility
.DESCRIPTION
    Comprehensive cleanup for Windows, macOS, and Linux with enhanced support for:
    - 60+ application cache locations
    - 15+ package managers
    - 20+ developer tools
    - System-level cleanup (logs, caches, thumbnails, etc.)
.VERSION
    3.0.0
#>

#Requires -PSEdition Core
#Requires -Version 7

param(
    [switch]$All,
    [switch]$Temp,
    [switch]$Browser,
    [switch]$Dev,
    [switch]$Logs,
    [switch]$Cache,
    [switch]$Apps,
    [switch]$System,
    [switch]$Quiet,
    [switch]$Verbose,
    [switch]$Help
)

# Show help
if ($Help) {
    Write-Host @"
Universal Disk Cleanup Tool v3.0
===============================

USAGE:
    cleanup.ps1 [OPTIONS]

OPTIONS:
    --All       Clean everything (recommended)
    --Temp      Clean temporary files
    --Browser   Clean browser caches
    --Dev       Clean developer tool caches
    --Logs      Clean system logs
    --Cache     Clean package manager caches
    --Apps      Clean application caches
    --System    Clean system files (thumbnails, fonts, etc.)
    --Quiet     Suppress output
    --Verbose   Show detailed output
    --Help      Show this help message

EXAMPLES:
    ./cleanup.ps1 --All              # Clean everything
    ./cleanup.ps1 --Temp --Browser    # Quick cleanup
    ./cleanup.ps1 --Dev --Cache       # Clean development tools
    ./cleanup.ps1 --All --Verbose     # Full cleanup with details

PLATFORM SUPPORT:
    - Windows 10/11
    - macOS 10.14+
    - Linux (Ubuntu, Fedora, Arch, Debian, etc.)

For more info: https://github.com/chibuenyim/UniversalDiskCleanupTool
"@
    exit 0
}

# Detect OS
$OS = $null
if ($IsWindows) {
    $OS = "Windows"
} elseif ($IsMacOS) {
    $OS = "macOS"
} elseif ($IsLinux) {
    $OS = "Linux"
} else {
    Write-Error "Unsupported operating system"
    exit 1
}

# Color support
function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    if ($Host.UI.RawUI.ForegroundColor) {
        Write-Host $Message -ForegroundColor $Color
    } else {
        Write-Host $Message
    }
}

function Write-Success { Write-ColorOutput @args -Color "Green" }
function Write-Warning { Write-ColorOutput @args -Color "Yellow" }
function Write-Error-Msg { Write-ColorOutput @args -Color "Red" }
function Write-Info { Write-ColorOutput @args -Color "Cyan" }

function Get-FolderSize {
    param([string]$Path)
    if (Test-Path $Path) {
        try {
            $size = (Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue |
                     Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
            return $size
        } catch {
            return 0
        }
    }
    return 0
}

function Format-Bytes {
    param([long]$Bytes)
    if ($Bytes -ge 1GB) { return "{0:N2} GB" -f ($Bytes / 1GB) }
    if ($Bytes -ge 1MB) { return "{0:N2} MB" -f ($Bytes / 1MB) }
    if ($Bytes -ge 1KB) { return "{0:N2} KB" -f ($Bytes / 1KB) }
    return "$Bytes Bytes"
}

function Remove-Safe {
    param([string]$Path, [string]$Sudo = $false)
    if (-not (Test-Path $Path)) { return 0 }

    try {
        $before = Get-FolderSize $Path
        if ($Sudo -and $OS -ne "Windows") {
            sudo rm -rf "$Path/*" 2>$null
        } else {
            Remove-Item -Path "$Path/*" -Recurse -Force -ErrorAction SilentlyContinue
        }
        $after = Get-FolderSize $Path
        return ($before - $after)
    } catch {
        return 0
    }
}

$totalFreed = 0
$VerboseMode = $Verbose

# =============================================
# WINDOWS CLEANERS
# =============================================
function Invoke-WindowsCleanup {
    Write-Info "=== Windows Disk Cleanup ==="

    # Temp files
    if ($All -or $Temp) {
        Write-Host "Cleaning Windows temp files..." -ForegroundColor Cyan
        $tempPaths = @(
            "$env:LOCALAPPDATA\Temp",
            "$env:TEMP",
            "$env:WINDIR\Temp",
            "$env:WINDIR\Prefetch"
        )

        foreach ($path in $tempPaths) {
            $freed = Remove-Safe $path
            $totalFreed += $freed
            if ($freed -gt 0 -or $VerboseMode) {
                Write-Success "  Cleaned $path - Freed $(Format-Bytes $freed)"
            }
        }
    }

    # Browser caches
    if ($All -or $Browser) {
        Write-Host "Cleaning browser caches..." -ForegroundColor Cyan
        $browsers = @{
            "Chrome" = @("$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache",
                        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Code Cache")
            "Edge" = @("$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache",
                      "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Code Cache")
            "Firefox" = @("$env:APPDATA\Mozilla\Firefox\Profiles")
            "Brave" = @("$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Cache")
            "Opera" = @("$env:APPDATA\Opera Software\Opera Stable\Cache")
            "Vivaldi" = @("$env:LOCALAPPDATA\Vivaldi\User Data\Default\Cache")
        }

        foreach ($browser in $browsers.Keys) {
            foreach ($path in $browsers[$browser]) {
                if (Test-Path $path) {
                    $freed = Remove-Safe $path
                    $totalFreed += $freed
                    if ($freed -gt 0 -or $VerboseMode) {
                        Write-Success "  Cleaned $browser - Freed $(Format-Bytes $freed)"
                    }
                }
            }
        }
    }

    # Developer caches
    if ($All -or $Dev) {
        Write-Host "Cleaning developer caches..." -ForegroundColor Cyan

        # Package managers
        $devPaths = @{
            "npm" = "$env:APPDATA\npm-cache"
            "yarn" = "$env:LOCALAPPDATA\Yarn\Cache"
            "pnpm" = "$env:LOCALAPPDATA\pnpm-store"
            "pip" = "$env:LOCALAPPDATA\pip\Cache"
            "Poetry" = "$env:LOCALAPPDATA\pypoetry\Cache"
            "Composer" = "$env:LOCALAPPDATA\Composer"
            "NuGet" = "$env:LOCALAPPDATA\NuGet\v3-cache"
            "DotNet" = "$env:USERPROFILE\.nuget\packages"
            "Maven" = "$env:USERPROFILE\.m2\repository"
            "Gradle" = "$env:USERPROFILE\.gradle\caches"
            "Go" = "$env:USERPROFILE\go\pkg\mod"
            "Cargo" = "$env:USERPROFILE\.cargo\registry"
            "Flutter" = "$env:LOCALAPPDATA\Pub\Cache"
        }

        foreach ($tool in $devPaths.Keys) {
            $path = $devPaths[$tool]
            if ($tool -eq "npm" -and (Get-Command npm -ErrorAction SilentlyContinue)) {
                try {
                    $before = Get-FolderSize $path
                    npm cache clean --force *> $null
                    Start-Sleep -Milliseconds 500
                    $after = Get-FolderSize $path
                    $freed = $before - $after
                    $totalFreed += $freed
                    if ($VerboseMode) { Write-Success "  Cleaned $tool - Freed $(Format-Bytes $freed)" }
                } catch {}
            } elseif ($tool -eq "pip" -and (Get-Command pip -ErrorAction SilentlyContinue)) {
                try {
                    pip cache purge *> $null
                    if ($VerboseMode) { Write-Success "  Cleaned $tool cache" }
                } catch {}
            } else {
                $freed = Remove-Safe $path
                $totalFreed += $freed
                if ($freed -gt 0 -or $VerboseMode) { Write-Success "  Cleaned $tool - Freed $(Format-Bytes $freed)" }
            }
        }

        # Development tools
        $devTools = @(
            "$env:USERPROFILE\.vscode\extensions\cachedData",
            "$env:LOCALAPPDATA\ms-playwright",
            "$env:LOCALAPPDATA\Cypress",
            "$env:LOCALAPPDATA\selenium"
        )

        foreach ($path in $devTools) {
            $freed = Remove-Safe $path
            $totalFreed += $freed
            if ($freed -gt 0 -or $VerboseMode) { Write-Success "  Cleaned dev tools - Freed $(Format-Bytes $freed)" }
        }

        # Docker
        if (Get-Command docker -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning Docker..."
                docker system prune -f --volumes *> $null
                Write-Success "  Cleaned Docker system"
            } catch {}
        }
    }

    # Application caches
    if ($All -or $Apps) {
        Write-Host "Cleaning application caches..." -ForegroundColor Cyan
        $appPaths = @{
            "AdobeCC" = "$env:APPDATA\Adobe\Cache"
            "Spotify" = "$env:LOCALAPPDATA\Spotify\Storage"
            "Discord" = "$env:APPDATA\discord\Cache"
            "Slack" = "$env:APPDATA\Slack\Cache"
            "Teams" = "$env:APPDATA\Microsoft\Teams\Cache"
            "Zoom" = "$env:APPDATA\zoom\data"
            "Telegram" = "$env:LOCALAPPDATA\Telegram\Desktop\tdata"
            "Steam" = "$env:PROGRAMFILES\Steam\appcache"
            "EpicGames" = "$env:LOCALAPPDATA\EpicGamesLauncher\Saved"
        }

        foreach ($app in $appPaths.Keys) {
            $path = $appPaths[$app]
            $freed = Remove-Safe $path
            $totalFreed += $freed
            if ($freed -gt 0 -or $VerboseMode) { Write-Success "  Cleaned $app - Freed $(Format-Bytes $freed)" }
        }
    }

    # System files
    if ($All -or $System) {
        Write-Host "Cleaning system files..." -ForegroundColor Cyan
        $sysPaths = @(
            "C:\ProgramData\Microsoft\Windows\WER",
            "C:\Windows\Logs",
            "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Store",
            "$env:LOCALAPPDATA\Microsoft\Windows\Explorer"
        )

        foreach ($path in $sysPaths) {
            $freed = Remove-Safe $path
            $totalFreed += $freed
            if ($freed -gt 0 -or $VerboseMode) { Write-Success "  Cleaned system files - Freed $(Format-Bytes $freed)" }
        }

        # Thumbnail cache
        $thumbPath = "$env:LOCALAPPDATA\Microsoft\Windows\Explorer"
        if (Test-Path $thumbPath) {
            Get-ChildItem -Path $thumbPath -Filter "thumbcache*.db" -ErrorAction SilentlyContinue | ForEach-Object {
                try {
                    $totalFreed += $_.Length
                    Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue
                } catch {}
            }
        }

        # Recycle Bin
        try {
            $shell = New-Object -ComObject Shell.Application
            $recycleBin = $shell.Namespace(0xA)
            $items = $recycleBin.Items()
            if ($items.Count -gt 0) {
                Clear-RecycleBin -Force -ErrorAction SilentlyContinue
                Write-Success "  Emptied Recycle Bin ($($items.Count) items)"
            }
        } catch {}
    }

    # Windows Update
    if ($All -or $Cache) {
        Write-Host "Cleaning Windows Update residues..." -ForegroundColor Cyan
        try {
            Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
            $wuPath = "C:\Windows\SoftwareDistribution\Download"
            $freed = Remove-Safe $wuPath
            $totalFreed += $freed
            if ($freed -gt 0 -or $VerboseMode) { Write-Success "  Cleaned Windows Update - Freed $(Format-Bytes $freed)" }
            Start-Service -Name wuauserv -ErrorAction SilentlyContinue

            Write-Info "  Running DISM cleanup (may take 10-30 minutes)..."
            dism /Online /Cleanup-Image /StartComponentCleanup *> $null
        } catch {
            Write-Warning "  Could not clean Windows Update (requires Admin)"
        }
    }
}

# =============================================
# MACOS CLEANERS (ENHANCED)
# =============================================
function Invoke-MacOSCleanup {
    Write-Info "=== macOS Disk Cleanup ==="

    # Temp files
    if ($All -or $Temp) {
        Write-Host "Cleaning temp files..." -ForegroundColor Cyan
        $tempPaths = @(
            "/tmp",
            "$env:HOME/Library/Caches",
            "$env:HOME/.Trash",
            "$env:HOME/.npm/_cacache",
            "$env:HOME/.yarn/cache"
        )

        foreach ($path in $tempPaths) {
            $freed = Remove-Safe $path $true
            $totalFreed += $freed
            if ($freed -gt 0 -or $VerboseMode) { Write-Success "  Cleaned $path - Freed $(Format-Bytes $freed)" }
        }
    }

    # Browser caches (Enhanced)
    if ($All -or $Browser) {
        Write-Host "Cleaning browser caches..." -ForegroundColor Cyan
        $browsers = @{
            "Safari" = @("$env:HOME/Library/Caches/com.apple.Safari",
                         "$env:HOME/Library/Safari")
            "Chrome" = @("$env:HOME/Library/Caches/Google/Chrome",
                        "$env:HOME/Library/Application Support/Google/Chrome/Default/Cache")
            "Firefox" = @("$env:HOME/Library/Caches/Firefox")
            "Brave" = @("$env:HOME/Library/Caches/BraveSoftware")
            "Edge" = @("$env:HOME/Library/Caches/Microsoft Edge")
            "Opera" = @("$env:HOME/Library/Caches/com.operasoftware.Opera")
            "Vivaldi" = @("$env:HOME/Library/Caches/Vivaldi")
        }

        foreach ($browser in $browsers.Keys) {
            foreach ($path in $browsers[$browser]) {
                if (Test-Path $path) {
                    $freed = Remove-Safe $path
                    $totalFreed += $freed
                    if ($freed -gt 0 -or $VerboseMode) { Write-Success "  Cleaned $browser - Freed $(Format-Bytes $freed)" }
                }
            }
        }
    }

    # Developer caches (Enhanced)
    if ($All -or $Dev) {
        Write-Host "Cleaning developer caches..." -ForegroundColor Cyan

        # Package managers
        if (Get-Command npm -ErrorAction SilentlyContinue) {
            try {
                $before = Get-FolderSize "$env:HOME/.npm"
                npm cache clean --force *> $null
                $after = Get-FolderSize "$env:HOME/.npm"
                $freed = $before - $after
                $totalFreed += $freed
                if ($VerboseMode) { Write-Success "  Cleaned npm - Freed $(Format-Bytes $freed)" }
            } catch {}
        }

        if (Get-Command yarn -ErrorAction SilentlyContinue) {
            try {
                yarn cache clean *> $null
                if ($VerboseMode) { Write-Success "  Cleaned yarn cache" }
            } catch {}
        }

        if (Get-Command pip3 -ErrorAction SilentlyContinue) {
            try {
                pip3 cache purge *> $null
                if ($VerboseMode) { Write-Success "  Cleaned pip cache" }
            } catch {}
        }

        if (Get-Command poetry -ErrorAction SilentlyContinue) {
            try {
                poetry cache clear --all -q *> $null
                if ($VerboseMode) { Write-Success "  Cleaned Poetry cache" }
            } catch {}
        }

        # Homebrew
        if (Get-Command brew -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning Homebrew..."
                brew cleanup -s --prune=all *> $null
                Write-Success "  Cleaned Homebrew cache"
            } catch {}
        }

        # CocoaPods
        $cocoaPath = "$env:HOME/Library/Caches/CocoaPods"
        if (Test-Path $cocoaPath) {
            $freed = Remove-Safe $cocoaPath
            $totalFreed += $freed
            if ($freed -gt 0 -or $VerboseMode) { Write-Success "  Cleaned CocoaPods - Freed $(Format-Bytes $freed)" }
        }

        # Carthage
        $carthagePath = "$env:HOME/Library/Caches/org.carthage.CarthageKit"
        if (Test-Path $carthagePath) {
            $freed = Remove-Safe $carthagePath
            $totalFreed += $freed
            if ($freed -gt 0 -or $VerboseMode) { Write-Success "  Cleaned Carthage - Freed $(Format-Bytes $freed)" }
        }

        # Swift Package Manager
        $swiftPath = "$env:HOME/Library/Developer/Xcode/DerivedData"
        if (Test-Path $swiftPath) {
            $freed = Remove-Safe $swiftPath $true
            $totalFreed += $freed
            if ($freed -gt 0 -or $VerboseMode) { Write-Success "  Cleaned Xcode DerivedData - Freed $(Format-Bytes $freed)" }
        }

        # Go modules
        $goPath = "$env:HOME/go/pkg/mod"
        if (Test-Path $goPath) {
            $freed = Remove-Safe $goPath
            $totalFreed += $freed
            if ($freed -gt 0 -or $VerboseMode) { Write-Success "  Cleaned Go modules - Freed $(Format-Bytes $freed)" }
        }

        # Cargo
        $cargoPath = "$env:HOME/.cargo/registry"
        if (Test-Path $cargoPath) {
            $freed = Remove-Safe $cargoPath
            $totalFreed += $freed
            if ($freed -gt 0 -or $VerboseMode) { Write-Success "  Cleaned Cargo - Freed $(Format-Bytes $freed)" }
        }

        # Docker
        if (Get-Command docker -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning Docker..."
                docker system prune -af --volumes *> $null
                Write-Success "  Cleaned Docker system"
            } catch {}
        }

        # Gradle
        $gradlePath = "$env:HOME/.gradle/caches"
        if (Test-Path $gradlePath) {
            $freed = Remove-Safe $gradlePath
            $totalFreed += $freed
            if ($freed -gt 0 -or $VerboseMode) { Write-Success "  Cleaned Gradle - Freed $(Format-Bytes $freed)" }
        }

        # Maven
        $mavenPath = "$env:HOME/.m2/repository"
        if (Test-Path $mavenPath) {
            $freed = Remove-Safe $mavenPath
            $totalFreed += $freed
            if ($freed -gt 0 -or $VerboseMode) { Write-Success "  Cleaned Maven - Freed $(Format-Bytes $freed)" }
        }
    }

    # Application caches (Enhanced)
    if ($All -or $Apps) {
        Write-Host "Cleaning application caches..." -ForegroundColor Cyan
        $appPaths = @{
            "AdobeCC" = "$env:HOME/Library/Application Support/Adobe"
            "Spotify" = "$env:HOME/Library/Caches/com.spotify.client"
            "Discord" = "$env:HOME/Library/Caches/discord"
            "Slack" = "$env:HOME/Library/Caches/com.tinyspeck.slackmacgap"
            "Teams" = "$env:HOME/Library/Application Support/Microsoft/Teams"
            "Zoom" = "$env:HOME/Library/Caches/us.zoom.xos"
            "Telegram" = "$env:HOME/Library/Containers/ru.keepcoder.Telegram/Data/Library/Caches"
            "VSCode" = "$env:HOME/Library/Application Support/Code/Cache"
            "JetBrains" = "$env:HOME/Library/Caches/JetBrains"
        }

        foreach ($app in $appPaths.Keys) {
            $path = $appPaths[$app]
            if (Test-Path $path) {
                $freed = Remove-Safe $path
                $totalFreed += $freed
                if ($freed -gt 0 -or $VerboseMode) { Write-Success "  Cleaned $app - Freed $(Format-Bytes $freed)" }
            }
        }
    }

    # System files (Enhanced)
    if ($All -or $System) {
        Write-Host "Cleaning system files..." -ForegroundColor Cyan

        # System logs
        $logPaths = @(
            "$env:HOME/Library/Logs",
            "/Library/Logs",
            "/var/log",
            "$env:HOME/Library/Logs/DiagnosticReports"
        )

        foreach ($path in $logPaths) {
            $freed = Remove-Safe $path $true
            $totalFreed += $freed
            if ($freed -gt 0 -or $VerboseMode) { Write-Success "  Cleaned logs - Freed $(Format-Bytes $freed)" }
        }

        # Font cache
        try {
            sudo rm -rf /Library/Caches/*/cached.ttf 2>$null
            sudo rm -rf "$env:HOME/Library/Caches/com.apple.ATS/*/fontRegistry" 2>$null
            if ($VerboseMode) { Write-Success "  Cleaned font cache" }
        } catch {}

        # Thumbnail cache
        $thumbPath = "$env:HOME/Library/Caches/com.apple.ichat"
        if (Test-Path $thumbPath) {
            $freed = Remove-Safe $thumbPath
            $totalFreed += $freed
            if ($VerboseMode) { Write-Success "  Cleaned thumbnails - Freed $(Format-Bytes $freed)" }
        }

        # iOS device backups
        $backupPath = "$env:HOME/Library/Application Support/MobileSync/Backup"
        if (Test-Path $backupPath) {
            Write-Warning "  iOS backups found at: $backupPath"
            Write-Warning "  Review and delete old backups manually if needed"
        }

        # Time Machine snapshots (requires user interaction)
        try {
            $snapshots = tmutil listlocalsnapshots / 2>$null
            if ($snapshots) {
                Write-Warning "  Time Machine snapshots found:"
                Write-Warning $snapshots
                Write-Warning "  Run 'sudo tmutil deletelocalsnapshots' to clean"
            }
        } catch {}
    }

    # Package manager caches
    if ($All -or $Cache) {
        Write-Host "Cleaning package manager caches..." -ForegroundColor Cyan

        # Homebrew already handled in Dev section

        # MacPorts
        if (Get-Command port -ErrorAction SilentlyContinue) {
            try {
                sudo port clean --all installed *> $null
                if ($VerboseMode) { Write-Success "  Cleaned MacPorts" }
            } catch {}
        }
    }
}

# =============================================
# LINUX CLEANERS (ENHANCED)
# =============================================
function Invoke-LinuxCleanup {
    Write-Info "=== Linux Disk Cleanup ==="

    # Package manager caches (Enhanced)
    if ($All -or $Cache) {
        Write-Host "Cleaning package manager caches..." -ForegroundColor Cyan

        # apt/debian/ubuntu
        if (Get-Command apt-get -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning apt..."
                sudo apt-get clean *> $null
                sudo apt-get autoclean *> $null
                sudo apt-get autoremove -y *> $null
                sudo rm -rf /var/cache/apt/archives/*.deb 2>$null
                Write-Success "  Cleaned apt cache"
            } catch {}
        }

        # dnf/fedora
        if (Get-Command dnf -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning dnf..."
                sudo dnf clean all *> $null
                sudo dnf autoremove -y *> $null
                Write-Success "  Cleaned dnf cache"
            } catch {}
        }

        # pacman/arch
        if (Get-Command pacman -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning pacman..."
                sudo pacman -Sc --noconfirm *> $null
                sudo pacman -Scc --noconfirm *> $null
                Write-Success "  Cleaned pacman cache"
            } catch {}
        }

        # yum/older rhel
        if (Get-Command yum -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning yum..."
                sudo yum clean all *> $null
                sudo yum autoremove -y *> $null
                Write-Success "  Cleaned yum cache"
            } catch {}
        }

        # zypper/suse
        if (Get-Command zypper -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning zypper..."
                sudo zypper clean --all *> $null
                Write-Success "  Cleaned zypper cache"
            } catch {}
        }

        # swpclr/clear linux
        if (Get-Command swupd -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning swupd..."
                sudo swupd cleanup --all *> $null
                Write-Success "  Cleaned swupd cache"
            } catch {}
        }

        # xbps/void
        if (Get-Command xbps-remove -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning xbps..."
                sudo xbps-remove -O *> $null
                Write-Success "  Cleaned xbps cache"
            } catch {}
        }

        # apk/alpine
        if (Get-Command apk -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning apk..."
                sudo apk cache clean *> $null
                Write-Success "  Cleaned apk cache"
            } catch {}
        }

        # snap
        if (Get-Command snap -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning old snap revisions..."
                sudo snap set system refresh.retain=2
                sudo snap run --shell `sh -c 'set -eu; rm -f /var/lib/snapd/snaps/*_* && snap run --shell /bin/sh'` 2>$null
                if ($VerboseMode) { Write-Success "  Cleaned old snap revisions" }
            } catch {}
        }

        # flatpak
        if (Get-Command flatpak -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning flatpak..."
                flatpak uninstall --unused -y *> $null
                if ($VerboseMode) { Write-Success "  Cleaned unused flatpak runtimes" }
            } catch {}
        }
    }

    # Temp files
    if ($All -or $Temp) {
        Write-Host "Cleaning temp files..." -ForegroundColor Cyan
        $tempPaths = @("/tmp", "/var/tmp", "$env:HOME/.cache", "$env:HOME/.thumbnails")

        foreach ($path in $tempPaths) {
            $freed = Remove-Safe $path $true
            $totalFreed += $freed
            if ($freed -gt 0 -or $VerboseMode) { Write-Success "  Cleaned $path - Freed $(Format-Bytes $freed)" }
        }
    }

    # Browser caches (Enhanced)
    if ($All -or $Browser) {
        Write-Host "Cleaning browser caches..." -ForegroundColor Cyan
        $browsers = @{
            "Chrome" = @("$env:HOME/.cache/google-chrome", "$env:HOME/.config/google-chrome/Default/Cache")
            "Firefox" = @("$env:HOME/.cache/mozilla/firefox")
            "Brave" = @("$env:HOME/.cache/BraveSoftware")
            "Chromium" = @("$env:HOME/.cache/chromium")
            "Edge" = @("$env:HOME/.config/microsoft-edge/Default/Cache")
            "Opera" = @("$env:HOME/.cache/opera")
            "Vivaldi" = @("$env:HOME/.cache/vivaldi")
        }

        foreach ($browser in $browsers.Keys) {
            foreach ($path in $browsers[$browser]) {
                if (Test-Path $path) {
                    $freed = Remove-Safe $path
                    $totalFreed += $freed
                    if ($freed -gt 0 -or $VerboseMode) { Write-Success "  Cleaned $browser - Freed $(Format-Bytes $freed)" }
                }
            }
        }
    }

    # Developer caches (Enhanced)
    if ($All -or $Dev) {
        Write-Host "Cleaning developer caches..." -ForegroundColor Cyan

        # npm
        if (Get-Command npm -ErrorAction SilentlyContinue) {
            try {
                $before = Get-FolderSize "$env:HOME/.npm"
                npm cache clean --force *> $null
                $after = Get-FolderSize "$env:HOME/.npm"
                $freed = $before - $after
                $totalFreed += $freed
                if ($VerboseMode) { Write-Success "  Cleaned npm - Freed $(Format-Bytes $freed)" }
            } catch {}
        }

        # yarn
        if (Get-Command yarn -ErrorAction SilentlyContinue) {
            try {
                $before = Get-FolderSize "$env:HOME/.yarn/cache"
                yarn cache clean *> $null
                $after = Get-FolderSize "$env:HOME/.yarn/cache"
                $freed = $before - $after
                $totalFreed += $freed
                if ($VerboseMode) { Write-Success "  Cleaned yarn - Freed $(Format-Bytes $freed)" }
            } catch {}
        }

        # pnpm
        if (Get-Command pnpm -ErrorAction SilentlyContinue) {
            try {
                pnpm store prune *> $null
                if ($VerboseMode) { Write-Success "  Cleaned pnpm store" }
            } catch {}
        }

        # pip
        if (Get-Command pip3 -ErrorAction SilentlyContinue) {
            try {
                pip3 cache purge *> $null
                if ($VerboseMode) { Write-Success "  Cleaned pip cache" }
            } catch {}
        }

        # Poetry
        if (Get-Command poetry -ErrorAction SilentlyContinue) {
            try {
                poetry cache clear --all -q *> $null
                if ($VerboseMode) { Write-Success "  Cleaned Poetry cache" }
            } catch {}
        }

        # Composer
        if (Get-Command composer -ErrorAction SilentlyContinue) {
            try {
                composer clear-cache -q *> $null
                if ($VerboseMode) { Write-Success "  Cleaned Composer cache" }
            } catch {}
        }

        # Go modules
        $goPath = "$env:HOME/go/pkg/mod"
        if (Test-Path $goPath) {
            $freed = Remove-Safe $goPath
            $totalFreed += $freed
            if ($freed -gt 0 -or $VerboseMode) { Write-Success "  Cleaned Go modules - Freed $(Format-Bytes $freed)" }
        }

        # Cargo
        $cargoPath = "$env:HOME/.cargo/registry"
        if (Test-Path $cargoPath) {
            $freed = Remove-Safe $cargoPath
            $totalFreed += $freed
            if ($freed -gt 0 -or $VerboseMode) { Write-Success "  Cleaned Cargo - Freed $(Format-Bytes $freed)" }
        }

        # Gradle
        $gradlePath = "$env:HOME/.gradle/caches"
        if (Test-Path $gradlePath) {
            $freed = Remove-Safe $gradlePath
            $totalFreed += $freed
            if ($freed -gt 0 -or $VerboseMode) { Write-Success "  Cleaned Gradle - Freed $(Format-Bytes $freed)" }
        }

        # Maven
        $mavenPath = "$env:HOME/.m2/repository"
        if (Test-Path $mavenPath) {
            $freed = Remove-Safe $mavenPath
            $totalFreed += $freed
            if ($freed -gt 0 -or $VerboseMode) { Write-Success "  Cleaned Maven - Freed $(Format-Bytes $freed)" }
        }

        # Docker
        if (Get-Command docker -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning Docker..."
                sudo docker system prune -af --volumes *> $null
                Write-Success "  Cleaned Docker system"
            } catch {}
        }
    }

    # Application caches (Enhanced)
    if ($All -or $Apps) {
        Write-Host "Cleaning application caches..." -ForegroundColor Cyan
        $appPaths = @{
            "Spotify" = "$env:HOME/.cache/spotify"
            "Discord" = "$env:HOME/.config/discord/Cache"
            "Slack" = "$env:HOME/.config/Slack/Cache"
            "Teams" = "$env:HOME/.config/Microsoft/Microsoft Teams/Cache"
            "Zoom" = "$env:HOME/.config/zoom"
            "Telegram" = "$env:HOME/.local/share/TelegramDesktop/tdata"
            "VSCode" = "$env:HOME/.config/Code/Cache"
            "JetBrains" = "$env:HOME/.cache/JetBrains"
        }

        foreach ($app in $appPaths.Keys) {
            $path = $appPaths[$app]
            if (Test-Path $path) {
                $freed = Remove-Safe $path
                $totalFreed += $freed
                if ($freed -gt 0 -or $VerboseMode) { Write-Success "  Cleaned $app - Freed $(Format-Bytes $freed)" }
            }
        }
    }

    # System files (Enhanced)
    if ($All -or $System) {
        Write-Host "Cleaning system files..." -ForegroundColor Cyan

        # System logs
        try {
            Write-Host "  Cleaning journal logs..."
            $before = Get-FolderSize "/var/log/journal"
            sudo journalctl --vacuum-time=7d *> $null
            $after = Get-FolderSize "/var/log/journal"
            $freed = $before - $after
            $totalFreed += $freed
            if ($VerboseMode) { Write-Success "  Cleaned journals - Freed $(Format-Bytes $freed)" }
        } catch {
            Write-Warning "  Could not clean journals (requires sudo)"
        }

        # Thumbnail cache
        $thumbPaths = @("$env:HOME/.cache/thumbnails", "$env:HOME/.thumbnails")
        foreach ($path in $thumbPaths) {
            if (Test-Path $path) {
                $freed = Remove-Safe $path
                $totalFreed += $freed
                if ($VerboseMode) { Write-Success "  Cleaned thumbnails - Freed $(Format-Bytes $freed)" }
            }
        }

        # Font cache
        try {
            sudo rm -rf "$env:HOME/.cache/fontconfig" 2>$null
            if ($VerboseMode) { Write-Success "  Cleaned font cache" }
        } catch {}

        # Icon cache
        try {
            sudo rm -rf "$env:HOME/.cache/icons" 2>$null
            if ($VerboseMode) { Write-Success "  Cleaned icon cache" }
        } catch {}
    }

    # Logs
    if ($All -or $Logs) {
        Write-Host "Cleaning system logs..." -ForegroundColor Cyan
        $logPaths = @("/var/log", "$env:HOME/.local/share/xorg", "$env:HOME/.local/share/sddm")

        foreach ($path in $logPaths) {
            if (Test-Path $path) {
                $freed = Remove-Safe $path $true
                $totalFreed += $freed
                if ($freed -gt 0 -or $VerboseMode) { Write-Success "  Cleaned logs - Freed $(Format-Bytes $freed)" }
            }
        }
    }
}

# =============================================
# MAIN
# =============================================
if (-not $Quiet) {
    Write-Info ""
    Write-Info "╔════════════════════════════════════════╗"
    Write-Info "║  Universal Disk Cleanup Tool v3.0     ║"
    Write-Info "║  Enhanced macOS & Linux Support       ║"
    Write-Info "╚════════════════════════════════════════╝"
    Write-Info ""
    Write-Host "Detected OS: $OS" -ForegroundColor Cyan
    Write-Host ""

    # Show disk space before
    $drive = if ($OS -eq "Windows") { Get-PSDrive C } else { Get-PSDrive / }
    $beforeFree = $drive.Free
    Write-Host "Free space before: $(Format-Bytes $beforeFree)" -ForegroundColor Gray
    Write-Host ""
}

# Run OS-specific cleanup
switch ($OS) {
    "Windows" { Invoke-WindowsCleanup }
    "macOS"   { Invoke-MacOSCleanup }
    "Linux"   { Invoke-LinuxCleanup }
}

# Show results
if (-not $Quiet) {
    Write-Host ""
    Write-Info "=== RESULTS ==="
    Write-Success "Total space freed: $(Format-Bytes $totalFreed)"

    $drive = if ($OS -eq "Windows") { Get-PSDrive C } else { Get-PSDrive / }
    $afterFree = $drive.Free
    Write-Host "Free space after:  $(Format-Bytes $afterFree)" -ForegroundColor Gray
    Write-Host "Actual freed:       $(Format-Bytes ($afterFree - $beforeFree))" -ForegroundColor Green

    Write-Host ""
    Write-Success "Cleanup complete!"
}
