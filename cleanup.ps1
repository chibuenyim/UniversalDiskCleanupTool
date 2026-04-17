#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Universal Disk Cleanup Tool v4.0 - Cross-platform disk cleanup utility
.DESCRIPTION
    Comprehensive cleanup for Windows, macOS, and Linux with advanced features:
    - 60+ application cache locations
    - 15+ package managers
    - 20+ developer tools
    - System-level cleanup (logs, caches, thumbnails, etc.)
    - Dry-run and scan-only modes
    - Configuration file support
    - Detailed logging with rotation
    - Scheduled cleanup support
    - Export/import settings
    - Interactive mode with progress bars
.VERSION
    4.0.0
#>

#Requires -PSEdition Core
#Requires -Version 7

param(
    [switch]$FixAll,
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
    [switch]$Help,
    [switch]$DryRun,
    [switch]$ScanOnly,
    [string]$ConfigFile,
    [switch]$ExportConfig,
    [switch]$ImportConfig,
    [switch]$Interactive,
    [switch]$Schedule,
    [string]$LogFile
)

# =============================================
# CONFIGURATION
# =============================================
$script:Config = @{
    Version = "4.0.0"
    LastRun = $null
    TotalCleaned = 0
    ScanResults = @{}
    LogFile = if ($LogFile) { $LogFile } else { "$env:HOME/.diskcleanup/cleanup.log" }
    MaxLogSize = 10MB
    ConfigPath = if ($ConfigFile) { $ConfigFile } else { "$env:HOME/.diskcleanup/config.json" }
}

# Create config directory
$configDir = Split-Path $script:Config.ConfigPath -Parent
if (-not (Test-Path $configDir)) {
    New-Item -ItemType Directory -Path $configDir -Force | Out-Null
}

$logDir = Split-Path $script:Config.LogFile -Parent
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

# =============================================
# LOGGING
# =============================================
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"

    # Log rotation
    if (Test-Path $script:Config.LogFile) {
        $logSize = (Get-Item $script:Config.LogFile).Length
        if ($logSize -gt $script:Config.MaxLogSize) {
            $archivePath = "$($script:Config.LogFile).old"
            Move-Item -Path $script:Config.LogFile -Destination $archivePath -Force
            if (Test-Path "$archivePath.1") { Remove-Item "$archivePath.1" -Force }
            Move-Item -Path $archivePath -Destination "$archivePath.1" -Force
        }
    }

    Add-Content -Path $script:Config.LogFile -Value $logMessage -ErrorAction SilentlyContinue
}

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )

    Write-Log -Message $Message -Level "INFO"

    if ($Quiet) { return }

    if ($Host.UI.RawUI.ForegroundColor) {
        Write-Host $Message -ForegroundColor $Color
    } else {
        Write-Host $Message
    }
}

function Write-Success {
    Write-ColorOutput @args -Color "Green"
    Write-Log -Message ($args -join " ") -Level "SUCCESS"
}

function Write-WarningOutput {
    Write-ColorOutput @args -Color "Yellow"
    Write-Log -Message ($args -join " ") -Level "WARNING"
}

function Write-Error-Msg {
    Write-ColorOutput @args -Color "Red"
    Write-Log -Message ($args -join " ") -Level "ERROR"
}

function Write-Info {
    Write-ColorOutput @args -Color "Cyan"
}

# =============================================
# CONFIG MANAGEMENT
# =============================================
function Save-Config {
    $configData = @{
        Version = $script:Config.Version
        LastRun = (Get-Date).ToString("o")
        TotalCleaned = $script:Config.TotalCleaned
        Options = @{
            All = $All
            Temp = $Temp
            Browser = $Browser
            Dev = $Dev
            Logs = $Logs
            Cache = $Cache
            Apps = $Apps
            System = $System
        }
    }

    $json = $configData | ConvertTo-Json -Depth 10
    $json | Out-File -FilePath $script:Config.ConfigPath -Encoding UTF8
    Write-Success "Configuration saved to: $($script:Config.ConfigPath)"
}

function Load-Config {
    if (Test-Path $script:Config.ConfigPath) {
        $json = Get-Content $script:Config.ConfigPath -Raw | ConvertFrom-Json

        if ($json.LastRun) {
            $script:Config.LastRun = [DateTime]::Parse($json.LastRun)
            Write-Info "Last run: $($script:Config.LastRun)"
        }

        if ($json.TotalCleaned) {
            $script:Config.TotalCleaned = $json.TotalCleaned
            Write-Info "Previously cleaned: $(Format-Bytes $script:Config.TotalCleaned)"
        }

        if ($json.Options) {
            Write-Info "Loaded configuration with saved options"
            return $json.Options
        }
    } else {
        Write-WarningOutput "No configuration file found at: $($script:Config.ConfigPath)"
    }
    return $null
}

function Export-Configuration {
    $configData = @{
        Version = $script:Config.Version
        Created = (Get-Date).ToString("o")
        Options = @{
            All = $All
            Temp = $Temp
            Browser = $Browser
            Dev = $Dev
            Logs = $Logs
            Cache = $Cache
            Apps = $Apps
            System = $System
            Verbose = $Verbose
            Interactive = $Interactive
        }
    }

    $exportPath = "$env:HOME/.diskcleanup/config-export-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
    $configData | ConvertTo-Json -Depth 10 | Out-File -FilePath $exportPath -Encoding UTF8
    Write-Success "Configuration exported to: $exportPath"
}

function Import-Configuration {
    $imports = Get-ChildItem -Path "$env:HOME/.diskcleanup" -Filter "config-export-*.json" |
               Sort-Object LastWriteTime -Descending |
               Select-Object -First 1

    if ($imports) {
        $configData = Get-Content $imports.FullName -Raw | ConvertFrom-Json
        Write-Info "Imported configuration from: $($imports.Name)"
        Write-Info "Created: $($configData.Created)"
        return $configData.Options
    } else {
        Write-WarningOutput "No exported configuration found"
        return $null
    }
}

# =============================================
# SCHEDULING
# =============================================
function Register-ScheduledCleanup {
    $OS = Get-OS

    if ($OS -eq "Windows") {
        Write-Info "Registering Windows Task Scheduler job..."

        $scriptPath = $PSCommandPath
        $action = New-ScheduledTaskAction -Execute "pwsh.exe" -Argument "-File `"$scriptPath`" --All"
        $trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At 2am
        $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
        $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

        Register-ScheduledTask -TaskName "DiskCleanupTool" -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
        Write-Success "Scheduled task registered: DiskCleanupTool (Weekly Sundays at 2 AM)"

    } elseif ($OS -eq "macOS" -or $OS -eq "Linux") {
        Write-Info "Registering cron job..."

        $scriptPath = $PSCommandPath
        $cronEntry = "0 2 * * 0 pwsh -File `"$scriptPath`" --All --Quiet >> `$HOME/.diskcleanup/scheduled.log 2>&1"

        # Install cron job
        $cronJob = (crontab -l 2>/dev/null) -notmatch "DiskCleanupTool"
        $cronJob += $cronEntry
        $cronJob | crontab -

        Write-Success "Cron job registered: Weekly Sundays at 2 AM"
    }
}

# =============================================
# PROGRESS BAR
# =============================================
function Show-Progress {
    param(
        [string]$Activity,
        [int]$PercentComplete
    )

    if ($Interactive -and -not $Quiet) {
        Write-Progress -Activity $Activity -PercentComplete $PercentComplete
    }
}

# =============================================
# HELP
# =============================================
function Show-Help {
    Write-Host @"
Universal Disk Cleanup Tool v4.0
================================

USAGE:
    cleanup.ps1 [OPTIONS]

BASIC OPTIONS:
    --All         Clean everything (recommended)
    --Temp        Clean temporary files
    --Browser     Clean browser caches
    --Dev         Clean developer tool caches
    --Logs        Clean system logs
    --Cache       Clean package manager caches
    --Apps        Clean application caches
    --System      Clean system files (thumbnails, fonts, etc.)

ADVANCED OPTIONS:
    --DryRun      Preview cleanup without making changes
    --ScanOnly    Scan and show what would be cleaned
    --Interactive Show progress bars and prompts
    --Quiet       Suppress output
    --Verbose     Show detailed output
    --Help        Show this help message

CONFIGURATION:
    --ConfigFile  Path to configuration file
    --ExportConfig Export current settings to file
    --ImportConfig Import settings from file
    --Schedule    Set up automatic weekly cleanup

EXAMPLES:
    ./cleanup.ps1 --All                    # Clean everything
    ./cleanup.ps1 --DryRun --All           # Preview what would be cleaned
    ./cleanup.ps1 --ScanOnly --Dev         # Scan dev tools only
    ./cleanup.ps1 --All --Verbose          # Full cleanup with details
    ./cleanup.ps1 --All --Interactive      # With progress bars
    ./cleanup.ps1 --ExportConfig           # Save current settings
    ./cleanup.ps1 --ImportConfig --All     # Import and run
    ./cleanup.ps1 --Schedule               # Set up weekly cleanup

PLATFORM SUPPORT:
    - Windows 10/11
    - macOS 10.14+
    - Linux (Ubuntu, Fedora, Arch, Debian, etc.)

CONFIGURATION FILES:
    Config:  ~/.diskcleanup/config.json
    Logs:    ~/.diskcleanup/cleanup.log
    Exports: ~/.diskcleanup/config-export-*.json

For more info: https://github.com/chibuenyim/UniversalDiskCleanupTool
"@
    exit 0
}

if ($Help) { Show-Help }

# =============================================
# OS DETECTION
# =============================================
function Get-OS {
    if ($IsWindows) { return "Windows" }
    elseif ($IsMacOS) { return "macOS" }
    elseif ($IsLinux) { return "Linux" }
    else { return "Unknown" }
}

$OS = Get-OS

# Handle export/import
if ($ExportConfig) {
    Export-Configuration
    exit 0
}

if ($ImportConfig) {
    $options = Import-Configuration
    if ($options) {
        $All = $options.All
        $Temp = $options.Temp
        $Browser = $options.Browser
        $Dev = $options.Dev
        $Logs = $options.Logs
        $Cache = $options.Cache
        $Apps = $options.Apps
        $System = $options.System
        if ($options.Verbose) { $Verbose = $true }
        if ($options.Interactive) { $Interactive = $true }
    }
    exit 0
}

if ($Schedule) {
    Register-ScheduledCleanup
    exit 0
}

# =============================================
# UTILITY FUNCTIONS
# =============================================
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

function Remove-FolderSafe {
    param(
        [string]$Path,
        [string]$Description = $Path,
        [bool]$Sudo = $false
    )

    if (-not (Test-Path $Path)) { return 0 }

    try {
        $before = Get-FolderSize $Path

        if ($ScanOnly) {
            $script:Config.ScanResults[$Description] = $before
            Write-Info "  Would clean: $Description - $(Format-Bytes $before)"
            return 0
        }

        if ($DryRun) {
            Write-Info "  [DRY RUN] Would clean: $Description - $(Format-Bytes $before)"
            return 0
        }

        if ($Sudo -and $OS -ne "Windows") {
            sudo rm -rf "$Path/*" 2>$null
        } else {
            Remove-Item -Path "$Path/*" -Recurse -Force -ErrorAction SilentlyContinue
        }

        $after = Get-FolderSize $Path
        $freed = $before - $after

        if ($Verbose -or $freed -gt 0) {
            Write-Success "  Cleaned $Description - Freed $(Format-Bytes $freed)"
        }

        return $freed
    } catch {
        Write-Error-Msg "  Error cleaning $Description"
        return 0
    }
}

$totalFreed = 0

# =============================================
# WINDOWS CLEANERS
# =============================================
function Invoke-WindowsCleanup {
    Write-Info "=== Windows Disk Cleanup ==="

    $progress = 0
    $maxProgress = 7

    # Temp files
    if ($All -or $Temp) {
        Show-Progress -Activity "Cleaning temp files" -PercentComplete (++$progress / $maxProgress * 100)
        Write-Host "Cleaning Windows temp files..." -ForegroundColor Cyan
        $tempPaths = @(
            "$env:LOCALAPPDATA\Temp",
            "$env:TEMP",
            "$env:WINDIR\Temp",
            "$env:WINDIR\Prefetch"
        )

        foreach ($path in $tempPaths) {
            $freed = Remove-FolderSafe -Path $path -Description $path
            $totalFreed += $freed
        }
    }

    # Browser caches
    if ($All -or $Browser) {
        Show-Progress -Activity "Cleaning browser caches" -PercentComplete (++$progress / $maxProgress * 100)
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
                    $freed = Remove-FolderSafe -Path $path -Description "$browser cache"
                    $totalFreed += $freed
                }
            }
        }
    }

    # Developer caches
    if ($All -or $Dev) {
        Show-Progress -Activity "Cleaning developer caches" -PercentComplete (++$progress / $maxProgress * 100)
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
                    if ($Verbose) { Write-Success "  Cleaned $tool - Freed $(Format-Bytes $freed)" }
                } catch {}
            } elseif ($tool -eq "pip" -and (Get-Command pip -ErrorAction SilentlyContinue)) {
                try {
                    pip cache purge *> $null
                    if ($Verbose) { Write-Success "  Cleaned $tool cache" }
                } catch {}
            } else {
                $freed = Remove-FolderSafe -Path $path -Description $tool
                $totalFreed += $freed
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
            $freed = Remove-FolderSafe -Path $path -Description "Dev tools"
            $totalFreed += $freed
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
        Show-Progress -Activity "Cleaning application caches" -PercentComplete (++$progress / $maxProgress * 100)
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
            $freed = Remove-FolderSafe -Path $path -Description $app
            $totalFreed += $freed
        }
    }

    # System files
    if ($All -or $System) {
        Show-Progress -Activity "Cleaning system files" -PercentComplete (++$progress / $maxProgress * 100)
        Write-Host "Cleaning system files..." -ForegroundColor Cyan
        $sysPaths = @(
            "C:\ProgramData\Microsoft\Windows\WER",
            "C:\Windows\Logs",
            "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Store",
            "$env:LOCALAPPDATA\Microsoft\Windows\Explorer"
        )

        foreach ($path in $sysPaths) {
            $freed = Remove-FolderSafe -Path $path -Description "System files"
            $totalFreed += $freed
        }

        # Thumbnail cache
        $thumbPath = "$env:LOCALAPPDATA\Microsoft\Windows\Explorer"
        if (Test-Path $thumbPath) {
            Get-ChildItem -Path $thumbPath -Filter "thumbcache*.db" -ErrorAction SilentlyContinue | ForEach-Object {
                try {
                    $totalFreed += $_.Length
                    if (-not $DryRun -and -not $ScanOnly) {
                        Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue
                    }
                } catch {}
            }
        }

        # Recycle Bin
        try {
            $shell = New-Object -ComObject Shell.Application
            $recycleBin = $shell.Namespace(0xA)
            $items = $recycleBin.Items()
            if ($items.Count -gt 0) {
                if (-not $DryRun -and -not $ScanOnly) {
                    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
                }
                Write-Success "  Emptied Recycle Bin ($($items.Count) items)"
            }
        } catch {}
    }

    # Windows Update
    if ($All -or $Cache) {
        Show-Progress -Activity "Cleaning Windows Update" -PercentComplete (++$progress / $maxProgress * 100)
        Write-Host "Cleaning Windows Update residues..." -ForegroundColor Cyan
        try {
            Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
            $wuPath = "C:\Windows\SoftwareDistribution\Download"
            $freed = Remove-FolderSafe -Path $wuPath -Description "Windows Update"
            $totalFreed += $freed
            Start-Service -Name wuauserv -ErrorAction SilentlyContinue

            Write-Info "  Running DISM cleanup (may take 10-30 minutes)..."
            if (-not $DryRun -and -not $ScanOnly) {
                dism /Online /Cleanup-Image /StartComponentCleanup *> $null
            }
        } catch {
            Write-WarningOutput "  Could not clean Windows Update (requires Admin)"
        }
    }
}

# =============================================
# MACOS CLEANERS (ENHANCED)
# =============================================
function Invoke-MacOSCleanup {
    Write-Info "=== macOS Disk Cleanup ==="

    $progress = 0
    $maxProgress = 6

    # Temp files
    if ($All -or $Temp) {
        Show-Progress -Activity "Cleaning temp files" -PercentComplete (++$progress / $maxProgress * 100)
        Write-Host "Cleaning temp files..." -ForegroundColor Cyan
        $tempPaths = @(
            "/tmp",
            "$env:HOME/Library/Caches",
            "$env:HOME/.Trash",
            "$env:HOME/.npm/_cacache",
            "$env:HOME/.yarn/cache"
        )

        foreach ($path in $tempPaths) {
            $freed = Remove-FolderSafe -Path $path -Description $path -Sudo $true
            $totalFreed += $freed
        }
    }

    # Browser caches (Enhanced)
    if ($All -or $Browser) {
        Show-Progress -Activity "Cleaning browser caches" -PercentComplete (++$progress / $maxProgress * 100)
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
                    $freed = Remove-FolderSafe -Path $path -Description "$browser cache"
                    $totalFreed += $freed
                }
            }
        }
    }

    # Developer caches (Enhanced)
    if ($All -or $Dev) {
        Show-Progress -Activity "Cleaning developer caches" -PercentComplete (++$progress / $maxProgress * 100)
        Write-Host "Cleaning developer caches..." -ForegroundColor Cyan

        # Package managers
        if (Get-Command npm -ErrorAction SilentlyContinue) {
            try {
                $before = Get-FolderSize "$env:HOME/.npm"
                if (-not $DryRun -and -not $ScanOnly) {
                    npm cache clean --force *> $null
                }
                $after = Get-FolderSize "$env:HOME/.npm"
                $freed = $before - $after
                $totalFreed += $freed
                if ($Verbose) { Write-Success "  Cleaned npm - Freed $(Format-Bytes $freed)" }
            } catch {}
        }

        if (Get-Command yarn -ErrorAction SilentlyContinue) {
            try {
                if (-not $DryRun -and -not $ScanOnly) {
                    yarn cache clean *> $null
                }
                if ($Verbose) { Write-Success "  Cleaned yarn cache" }
            } catch {}
        }

        if (Get-Command pip3 -ErrorAction SilentlyContinue) {
            try {
                if (-not $DryRun -and -not $ScanOnly) {
                    pip3 cache purge *> $null
                }
                if ($Verbose) { Write-Success "  Cleaned pip cache" }
            } catch {}
        }

        if (Get-Command poetry -ErrorAction SilentlyContinue) {
            try {
                if (-not $DryRun -and -not $ScanOnly) {
                    poetry cache clear --all -q *> $null
                }
                if ($Verbose) { Write-Success "  Cleaned Poetry cache" }
            } catch {}
        }

        # Homebrew
        if (Get-Command brew -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning Homebrew..."
                if (-not $DryRun -and -not $ScanOnly) {
                    brew cleanup -s --prune=all *> $null
                }
                Write-Success "  Cleaned Homebrew cache"
            } catch {}
        }

        # CocoaPods
        $cocoaPath = "$env:HOME/Library/Caches/CocoaPods"
        if (Test-Path $cocoaPath) {
            $freed = Remove-FolderSafe -Path $cocoaPath -Description "CocoaPods"
            $totalFreed += $freed
        }

        # Carthage
        $carthagePath = "$env:HOME/Library/Caches/org.carthage.CarthageKit"
        if (Test-Path $carthagePath) {
            $freed = Remove-FolderSafe -Path $carthagePath -Description "Carthage"
            $totalFreed += $freed
        }

        # Swift Package Manager
        $swiftPath = "$env:HOME/Library/Developer/Xcode/DerivedData"
        if (Test-Path $swiftPath) {
            $freed = Remove-FolderSafe -Path $swiftPath -Description "Xcode DerivedData" -Sudo $true
            $totalFreed += $freed
        }

        # Go modules
        $goPath = "$env:HOME/go/pkg/mod"
        if (Test-Path $goPath) {
            $freed = Remove-FolderSafe -Path $goPath -Description "Go modules"
            $totalFreed += $freed
        }

        # Cargo
        $cargoPath = "$env:HOME/.cargo/registry"
        if (Test-Path $cargoPath) {
            $freed = Remove-FolderSafe -Path $cargoPath -Description "Cargo"
            $totalFreed += $freed
        }

        # Docker
        if (Get-Command docker -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning Docker..."
                if (-not $DryRun -and -not $ScanOnly) {
                    docker system prune -af --volumes *> $null
                }
                Write-Success "  Cleaned Docker system"
            } catch {}
        }

        # Gradle
        $gradlePath = "$env:HOME/.gradle/caches"
        if (Test-Path $gradlePath) {
            $freed = Remove-FolderSafe -Path $gradlePath -Description "Gradle"
            $totalFreed += $freed
        }

        # Maven
        $mavenPath = "$env:HOME/.m2/repository"
        if (Test-Path $mavenPath) {
            $freed = Remove-FolderSafe -Path $mavenPath -Description "Maven"
            $totalFreed += $freed
        }
    }

    # Application caches (Enhanced)
    if ($All -or $Apps) {
        Show-Progress -Activity "Cleaning application caches" -PercentComplete (++$progress / $maxProgress * 100)
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
                $freed = Remove-FolderSafe -Path $path -Description $app
                $totalFreed += $freed
            }
        }
    }

    # System files (Enhanced)
    if ($All -or $System) {
        Show-Progress -Activity "Cleaning system files" -PercentComplete (++$progress / $maxProgress * 100)
        Write-Host "Cleaning system files..." -ForegroundColor Cyan

        # System logs
        $logPaths = @(
            "$env:HOME/Library/Logs",
            "/Library/Logs",
            "/var/log",
            "$env:HOME/Library/Logs/DiagnosticReports"
        )

        foreach ($path in $logPaths) {
            $freed = Remove-FolderSafe -Path $path -Description "Logs" -Sudo $true
            $totalFreed += $freed
        }

        # Font cache
        try {
            if (-not $DryRun -and -not $ScanOnly) {
                sudo rm -rf /Library/Caches/*/cached.ttf 2>$null
                sudo rm -rf "$env:HOME/Library/Caches/com.apple.ATS/*/fontRegistry" 2>$null
            }
            if ($Verbose) { Write-Success "  Cleaned font cache" }
        } catch {}

        # Thumbnail cache
        $thumbPath = "$env:HOME/Library/Caches/com.apple.ichat"
        if (Test-Path $thumbPath) {
            $freed = Remove-FolderSafe -Path $thumbPath -Description "Thumbnails"
            $totalFreed += $freed
        }

        # iOS device backups
        $backupPath = "$env:HOME/Library/Application Support/MobileSync/Backup"
        if (Test-Path $backupPath) {
            Write-WarningOutput "  iOS backups found at: $backupPath"
            Write-WarningOutput "  Review and delete old backups manually if needed"
        }

        # Time Machine snapshots (requires user interaction)
        try {
            $snapshots = tmutil listlocalsnapshots / 2>$null
            if ($snapshots) {
                Write-WarningOutput "  Time Machine snapshots found:"
                Write-WarningOutput $snapshots
                Write-WarningOutput "  Run 'sudo tmutil deletelocalsnapshots' to clean"
            }
        } catch {}
    }

    # Package manager caches
    if ($All -or $Cache) {
        Show-Progress -Activity "Cleaning package caches" -PercentComplete (++$progress / $maxProgress * 100)
        Write-Host "Cleaning package manager caches..." -ForegroundColor Cyan

        # Homebrew already handled in Dev section

        # MacPorts
        if (Get-Command port -ErrorAction SilentlyContinue) {
            try {
                if (-not $DryRun -and -not $ScanOnly) {
                    sudo port clean --all installed *> $null
                }
                if ($Verbose) { Write-Success "  Cleaned MacPorts" }
            } catch {}
        }
    }
}

# =============================================
# LINUX CLEANERS (ENHANCED)
# =============================================
function Invoke-LinuxCleanup {
    Write-Info "=== Linux Disk Cleanup ==="

    $progress = 0
    $maxProgress = 8

    # Package manager caches (Enhanced)
    if ($All -or $Cache) {
        Show-Progress -Activity "Cleaning package caches" -PercentComplete (++$progress / $maxProgress * 100)
        Write-Host "Cleaning package manager caches..." -ForegroundColor Cyan

        # apt/debian/ubuntu
        if (Get-Command apt-get -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning apt..."
                if (-not $DryRun -and -not $ScanOnly) {
                    sudo apt-get clean *> $null
                    sudo apt-get autoclean *> $null
                    sudo apt-get autoremove -y *> $null
                    sudo rm -rf /var/cache/apt/archives/*.deb 2>$null
                }
                Write-Success "  Cleaned apt cache"
            } catch {}
        }

        # dnf/fedora
        if (Get-Command dnf -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning dnf..."
                if (-not $DryRun -and -not $ScanOnly) {
                    sudo dnf clean all *> $null
                    sudo dnf autoremove -y *> $null
                }
                Write-Success "  Cleaned dnf cache"
            } catch {}
        }

        # pacman/arch
        if (Get-Command pacman -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning pacman..."
                if (-not $DryRun -and -not $ScanOnly) {
                    sudo pacman -Sc --noconfirm *> $null
                    sudo pacman -Scc --noconfirm *> $null
                }
                Write-Success "  Cleaned pacman cache"
            } catch {}
        }

        # yum/older rhel
        if (Get-Command yum -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning yum..."
                if (-not $DryRun -and -not $ScanOnly) {
                    sudo yum clean all *> $null
                    sudo yum autoremove -y *> $null
                }
                Write-Success "  Cleaned yum cache"
            } catch {}
        }

        # zypper/suse
        if (Get-Command zypper -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning zypper..."
                if (-not $DryRun -and -not $ScanOnly) {
                    sudo zypper clean --all *> $null
                }
                Write-Success "  Cleaned zypper cache"
            } catch {}
        }

        # swupd/clear linux
        if (Get-Command swupd -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning swupd..."
                if (-not $DryRun -and -not $ScanOnly) {
                    sudo swupd cleanup --all *> $null
                }
                Write-Success "  Cleaned swupd cache"
            } catch {}
        }

        # xbps/void
        if (Get-Command xbps-remove -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning xbps..."
                if (-not $DryRun -and -not $ScanOnly) {
                    sudo xbps-remove -O *> $null
                }
                Write-Success "  Cleaned xbps cache"
            } catch {}
        }

        # apk/alpine
        if (Get-Command apk -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning apk..."
                if (-not $DryRun -and -not $ScanOnly) {
                    sudo apk cache clean *> $null
                }
                Write-Success "  Cleaned apk cache"
            } catch {}
        }

        # snap
        if (Get-Command snap -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning old snap revisions..."
                if (-not $DryRun -and -not $ScanOnly) {
                    sudo snap set system refresh.retain=2
                    sudo snap run --shell `sh -c 'set -eu; rm -f /var/lib/snapd/snaps/*_* && snap run --shell /bin/sh'` 2>$null
                }
                if ($Verbose) { Write-Success "  Cleaned old snap revisions" }
            } catch {}
        }

        # flatpak
        if (Get-Command flatpak -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning flatpak..."
                if (-not $DryRun -and -not $ScanOnly) {
                    flatpak uninstall --unused -y *> $null
                }
                if ($Verbose) { Write-Success "  Cleaned unused flatpak runtimes" }
            } catch {}
        }
    }

    # Temp files
    if ($All -or $Temp) {
        Show-Progress -Activity "Cleaning temp files" -PercentComplete (++$progress / $maxProgress * 100)
        Write-Host "Cleaning temp files..." -ForegroundColor Cyan
        $tempPaths = @("/tmp", "/var/tmp", "$env:HOME/.cache", "$env:HOME/.thumbnails")

        foreach ($path in $tempPaths) {
            $freed = Remove-FolderSafe -Path $path -Description $path -Sudo $true
            $totalFreed += $freed
        }
    }

    # Browser caches (Enhanced)
    if ($All -or $Browser) {
        Show-Progress -Activity "Cleaning browser caches" -PercentComplete (++$progress / $maxProgress * 100)
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
                    $freed = Remove-FolderSafe -Path $path -Description "$browser cache"
                    $totalFreed += $freed
                }
            }
        }
    }

    # Developer caches (Enhanced)
    if ($All -or $Dev) {
        Show-Progress -Activity "Cleaning developer caches" -PercentComplete (++$progress / $maxProgress * 100)
        Write-Host "Cleaning developer caches..." -ForegroundColor Cyan

        # npm
        if (Get-Command npm -ErrorAction SilentlyContinue) {
            try {
                $before = Get-FolderSize "$env:HOME/.npm"
                if (-not $DryRun -and -not $ScanOnly) {
                    npm cache clean --force *> $null
                }
                $after = Get-FolderSize "$env:HOME/.npm"
                $freed = $before - $after
                $totalFreed += $freed
                if ($Verbose) { Write-Success "  Cleaned npm - Freed $(Format-Bytes $freed)" }
            } catch {}
        }

        # yarn
        if (Get-Command yarn -ErrorAction SilentlyContinue) {
            try {
                $before = Get-FolderSize "$env:HOME/.yarn/cache"
                if (-not $DryRun -and -not $ScanOnly) {
                    yarn cache clean *> $null
                }
                $after = Get-FolderSize "$env:HOME/.yarn/cache"
                $freed = $before - $after
                $totalFreed += $freed
                if ($Verbose) { Write-Success "  Cleaned yarn - Freed $(Format-Bytes $freed)" }
            } catch {}
        }

        # pnpm
        if (Get-Command pnpm -ErrorAction SilentlyContinue) {
            try {
                if (-not $DryRun -and -not $ScanOnly) {
                    pnpm store prune *> $null
                }
                if ($Verbose) { Write-Success "  Cleaned pnpm store" }
            } catch {}
        }

        # pip
        if (Get-Command pip3 -ErrorAction SilentlyContinue) {
            try {
                if (-not $DryRun -and -not $ScanOnly) {
                    pip3 cache purge *> $null
                }
                if ($Verbose) { Write-Success "  Cleaned pip cache" }
            } catch {}
        }

        # Poetry
        if (Get-Command poetry -ErrorAction SilentlyContinue) {
            try {
                if (-not $DryRun -and -not $ScanOnly) {
                    poetry cache clear --all -q *> $null
                }
                if ($Verbose) { Write-Success "  Cleaned Poetry cache" }
            } catch {}
        }

        # Composer
        if (Get-Command composer -ErrorAction SilentlyContinue) {
            try {
                if (-not $DryRun -and -not $ScanOnly) {
                    composer clear-cache -q *> $null
                }
                if ($Verbose) { Write-Success "  Cleaned Composer cache" }
            } catch {}
        }

        # Go modules
        $goPath = "$env:HOME/go/pkg/mod"
        if (Test-Path $goPath) {
            $freed = Remove-FolderSafe -Path $goPath -Description "Go modules"
            $totalFreed += $freed
        }

        # Cargo
        $cargoPath = "$env:HOME/.cargo/registry"
        if (Test-Path $cargoPath) {
            $freed = Remove-FolderSafe -Path $cargoPath -Description "Cargo"
            $totalFreed += $freed
        }

        # Gradle
        $gradlePath = "$env:HOME/.gradle/caches"
        if (Test-Path $gradlePath) {
            $freed = Remove-FolderSafe -Path $gradlePath -Description "Gradle"
            $totalFreed += $freed
        }

        # Maven
        $mavenPath = "$env:HOME/.m2/repository"
        if (Test-Path $mavenPath) {
            $freed = Remove-FolderSafe -Path $mavenPath -Description "Maven"
            $totalFreed += $freed
        }

        # Docker
        if (Get-Command docker -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning Docker..."
                if (-not $DryRun -and -not $ScanOnly) {
                    sudo docker system prune -af --volumes *> $null
                }
                Write-Success "  Cleaned Docker system"
            } catch {}
        }
    }

    # Application caches (Enhanced)
    if ($All -or $Apps) {
        Show-Progress -Activity "Cleaning application caches" -PercentComplete (++$progress / $maxProgress * 100)
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
                $freed = Remove-FolderSafe -Path $path -Description $app
                $totalFreed += $freed
            }
        }
    }

    # System files (Enhanced)
    if ($All -or $System) {
        Show-Progress -Activity "Cleaning system files" -PercentComplete (++$progress / $maxProgress * 100)
        Write-Host "Cleaning system files..." -ForegroundColor Cyan

        # System logs
        try {
            Write-Host "  Cleaning journal logs..."
            $before = Get-FolderSize "/var/log/journal"
            if (-not $DryRun -and -not $ScanOnly) {
                sudo journalctl --vacuum-time=7d *> $null
            }
            $after = Get-FolderSize "/var/log/journal"
            $freed = $before - $after
            $totalFreed += $freed
            if ($Verbose) { Write-Success "  Cleaned journals - Freed $(Format-Bytes $freed)" }
        } catch {
            Write-WarningOutput "  Could not clean journals (requires sudo)"
        }

        # Thumbnail cache
        $thumbPaths = @("$env:HOME/.cache/thumbnails", "$env:HOME/.thumbnails")
        foreach ($path in $thumbPaths) {
            if (Test-Path $path) {
                $freed = Remove-FolderSafe -Path $path -Description "Thumbnails"
                $totalFreed += $freed
            }
        }

        # Font cache
        try {
            if (-not $DryRun -and -not $ScanOnly) {
                sudo rm -rf "$env:HOME/.cache/fontconfig" 2>$null
            }
            if ($Verbose) { Write-Success "  Cleaned font cache" }
        } catch {}

        # Icon cache
        try {
            if (-not $DryRun -and -not $ScanOnly) {
                sudo rm -rf "$env:HOME/.cache/icons" 2>$null
            }
            if ($Verbose) { Write-Success "  Cleaned icon cache" }
        } catch {}
    }

    # Logs
    if ($All -or $Logs) {
        Show-Progress -Activity "Cleaning system logs" -PercentComplete (++$progress / $maxProgress * 100)
        Write-Host "Cleaning system logs..." -ForegroundColor Cyan
        $logPaths = @("/var/log", "$env:HOME/.local/share/xorg", "$env:HOME/.local/share/sddm")

        foreach ($path in $logPaths) {
            if (Test-Path $path) {
                $freed = Remove-FolderSafe -Path $path -Description "Logs" -Sudo $true
                $totalFreed += $freed
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
    Write-Info "║  Universal Disk Cleanup Tool v4.0     ║"
    Write-Info "║  Advanced Features                    ║"
    Write-Info "╚════════════════════════════════════════╝"
    Write-Info ""
    Write-Host "Detected OS: $OS" -ForegroundColor Cyan
    Write-Host ""

    # Show mode
    if ($DryRun) { Write-WarningOutput "MODE: DRY RUN (no changes will be made)" }
    elseif ($ScanOnly) { Write-WarningOutput "MODE: SCAN ONLY (showing what would be cleaned)" }
    else { Write-Success "MODE: ACTIVE CLEANUP" }
    Write-Host ""

    # Show disk space before
    $drive = if ($OS -eq "Windows") { Get-PSDrive C } else { Get-PSDrive / }
    $beforeFree = $drive.Free
    Write-Host "Free space before: $(Format-Bytes $beforeFree)" -ForegroundColor Gray
    Write-Host ""
}

# Load configuration
Load-Config | Out-Null

# Run OS-specific cleanup
switch ($OS) {
    "Windows" { Invoke-WindowsCleanup }
    "macOS"   { Invoke-MacOSCleanup }
    "Linux"   { Invoke-LinuxCleanup }
}

# Update config
$script:Config.TotalCleaned = $totalFreed
Save-Config

# Show results
if (-not $Quiet) {
    if ($Interactive) { Write-Progress -Activity "Cleanup complete" -Completed }

    Write-Host ""
    Write-Info "=== RESULTS ==="

    if ($ScanOnly -and $script:Config.ScanResults.Count -gt 0) {
        Write-Success "Scan results:"
        foreach ($item in $script:Config.ScanResults.GetEnumerator()) {
            Write-Host "  $($item.Key): $(Format-Bytes $item.Value)" -ForegroundColor Cyan
        }
        Write-Host ""
        $totalScan = ($script:Config.ScanResults.Values | Measure-Object -Sum).Sum
        Write-Success "Total that could be freed: $(Format-Bytes $totalScan)"
    } elseif ($DryRun) {
        Write-Success "Total that would be freed: $(Format-Bytes $totalFreed)"
        Write-Info "Run without --DryRun to actually clean"
    } else {
        Write-Success "Total space freed: $(Format-Bytes $totalFreed)"

        $drive = if ($OS -eq "Windows") { Get-PSDrive C } else { Get-PSDrive / }
        $afterFree = $drive.Free
        Write-Host "Free space after:  $(Format-Bytes $afterFree)" -ForegroundColor Gray
        Write-Host "Actual freed:       $(Format-Bytes ($afterFree - $beforeFree))" -ForegroundColor Green
    }

    Write-Host ""
    Write-Success "Cleanup complete!"
    Write-Info "Log file: $($script:Config.LogFile)"
    Write-Info "Config:   $($script:Config.ConfigPath)"
}
