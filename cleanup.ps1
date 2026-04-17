#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Universal Disk Cleanup Tool - Cross-platform disk cleanup utility
.DESCRIPTION
    Cleans temporary files, caches, and system junk on Windows, macOS, and Linux
.VERSION
    2.0.0
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
    [switch]$Quiet,
    [switch]$Verbose
)

# Detect OS
$OS = $null
if ($IsWindows) {
    $OS = "Windows"
} elseif ($IsMacOS) {
    $OS = "macOS"
} elseif ($IsLinux) {
    $OS = "Linux"
} else {
    Write-Host "Unsupported operating system" -ForegroundColor Red
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
function Write-Error { Write-ColorOutput @args -Color "Red" }
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

$totalFreed = 0

# =============================================
# WINDOWS CLEANERS
# =============================================
function Invoke-WindowsCleanup {
    Write-Info "=== Windows Disk Cleanup ==="

    # Temp files
    if ($All -or $Temp) {
        Write-Host "Cleaning Windows temp files..."
        $tempPaths = @(
            "$env:LOCALAPPDATA\Temp",
            "$env:TEMP",
            "$env:WINDIR\Temp",
            "$env:WINDIR\Prefetch"
        )

        foreach ($path in $tempPaths) {
            if (Test-Path $path) {
                try {
                    $before = Get-FolderSize $path
                    Remove-Item -Path "$path\*" -Recurse -Force -ErrorAction SilentlyContinue
                    $after = Get-FolderSize $path
                    $freed = $before - $after
                    $totalFreed += $freed
                    Write-Success "  Cleaned $path - Freed $(Format-Bytes $freed)"
                } catch {
                    Write-Warning "  Could not clean $path"
                }
            }
        }
    }

    # Browser caches
    if ($All -or $Browser) {
        Write-Host "Cleaning browser caches..."
        $browsers = @{
            "Chrome" = @("$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache",
                        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Code Cache")
            "Edge" = @("$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache",
                      "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Code Cache")
            "Firefox" = @("$env:APPDATA\Mozilla\Firefox\Profiles")
            "Brave" = @("$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Cache")
        }

        foreach ($browser in $browsers.Keys) {
            foreach ($path in $browsers[$browser]) {
                if (Test-Path $path) {
                    try {
                        $before = Get-FolderSize $path
                        Remove-Item -Path "$path\*" -Recurse -Force -ErrorAction SilentlyContinue
                        $after = Get-FolderSize $path
                        $freed = $before - $after
                        $totalFreed += $freed
                        if ($freed -gt 0) {
                            Write-Success "  Cleaned $browser - Freed $(Format-Bytes $freed)"
                        }
                    } catch {}
                }
            }
        }
    }

    # Developer caches
    if ($All -or $Dev) {
        Write-Host "Cleaning developer caches..."

        # npm
        if (Get-Command npm -ErrorAction SilentlyContinue) {
            try {
                $before = Get-FolderSize "$env:APPDATA\npm-cache"
                npm cache clean --force *> $null
                $after = Get-FolderSize "$env:APPDATA\npm-cache"
                $freed = $before - $after
                $totalFreed += $freed
                Write-Success "  Cleaned npm cache - Freed $(Format-Bytes $freed)"
            } catch {}
        }

        # yarn
        if (Get-Command yarn -ErrorAction SilentlyContinue) {
            try {
                $before = Get-FolderSize "$env:LOCALAPPDATA\Yarn\Cache"
                yarn cache clean *> $null
                $after = Get-FolderSize "$env:LOCALAPPDATA\Yarn\Cache"
                $freed = $before - $after
                $totalFreed += $freed
                Write-Success "  Cleaned yarn cache - Freed $(Format-Bytes $freed)"
            } catch {}
        }

        # pip
        if (Get-Command pip -ErrorAction SilentlyContinue) {
            try {
                pip cache purge *> $null
                Write-Success "  Cleaned pip cache"
            } catch {}
        }

        # NuGet
        $nugetPath = "$env:LOCALAPPDATA\NuGet\v3-cache"
        if (Test-Path $nugetPath) {
            try {
                $before = Get-FolderSize $nugetPath
                Remove-Item -Path "$nugetPath\*" -Recurse -Force -ErrorAction SilentlyContinue
                $after = Get-FolderSize $nugetPath
                $freed = $before - $after
                $totalFreed += $freed
                Write-Success "  Cleaned NuGet cache - Freed $(Format-Bytes $freed)"
            } catch {}
        }

        # Docker
        if (Get-Command docker -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning Docker system..."
                docker system prune -f *> $null
                Write-Success "  Cleaned Docker system"
            } catch {}
        }
    }

    # Logs
    if ($All -or $Logs) {
        Write-Host "Cleaning logs..."
        $logPaths = @(
            "$env:LOCALAPPDATA\Microsoft\Windows\INetCache",
            "$env:LOCALAPPDATA\Microsoft\Windows\History",
            "$env:WINDIR\Logs",
            "$env:WINDIR\Debug"
        )

        foreach ($path in $logPaths) {
            if (Test-Path $path) {
                try {
                    $before = Get-FolderSize $path
                    Remove-Item -Path "$path\*" -Recurse -Force -ErrorAction SilentlyContinue
                    $after = Get-FolderSize $path
                    $freed = $before - $after
                    $totalFreed += $freed
                    if ($freed -gt 0) {
                        Write-Success "  Cleaned $path - Freed $(Format-Bytes $freed)"
                    }
                } catch {}
            }
        }
    }

    # Windows Update
    if ($All) {
        Write-Host "Cleaning Windows Update residues..."
        try {
            Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
            $wuPath = "C:\Windows\SoftwareDistribution\Download"
            if (Test-Path $wuPath) {
                $before = Get-FolderSize $wuPath
                Remove-Item -Path "$wuPath\*" -Recurse -Force -ErrorAction SilentlyContinue
                $after = Get-FolderSize $wuPath
                $freed = $before - $after
                $totalFreed += $freed
                Write-Success "  Cleaned Windows Update - Freed $(Format-Bytes $freed)"
            }
            Start-Service -Name wuauserv -ErrorAction SilentlyContinue

            # DISM cleanup
            Write-Info "  Running DISM cleanup (may take 10-30 minutes)..."
            dism /Online /Cleanup-Image /StartComponentCleanup *> $null
        } catch {
            Write-Warning "  Could not clean Windows Update (requires Admin)"
        }
    }

    # Recycle Bin
    if ($All) {
        Write-Host "Emptying Recycle Bin..."
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
}

# =============================================
# MACOS CLEANERS
# =============================================
function Invoke-MacOSCleanup {
    Write-Info "=== macOS Disk Cleanup ==="

    # User temp
    if ($All -or $Temp) {
        Write-Host "Cleaning temp files..."
        $tempPaths = @(
            "/tmp",
            "$env:HOME/Library/Caches",
            "$env:HOME/.Trash"
        )

        foreach ($path in $tempPaths) {
            if (Test-Path $path) {
                try {
                    $before = Get-FolderSize $path
                    Remove-Item -Path "$path/*" -Recurse -Force -ErrorAction SilentlyContinue
                    $after = Get-FolderSize $path
                    $freed = $before - $after
                    $totalFreed += $freed
                    Write-Success "  Cleaned $path - Freed $(Format-Bytes $freed)"
                } catch {
                    Write-Warning "  Could not clean $path (may need sudo)"
                }
            }
        }
    }

    # Browser caches
    if ($All -or $Browser) {
        Write-Host "Cleaning browser caches..."
        $browsers = @{
            "Safari" = @("$env:HOME/Library/Caches/com.apple.Safari",
                         "$env:HOME/Library/Safari")
            "Chrome" = @("$env:HOME/Library/Caches/Google/Chrome",
                        "$env:HOME/Library/Application Support/Google/Chrome/Default/Cache")
            "Firefox" = @("$env:HOME/Library/Caches/Firefox")
        }

        foreach ($browser in $browsers.Keys) {
            foreach ($path in $browsers[$browser]) {
                if (Test-Path $path) {
                    try {
                        $before = Get-FolderSize $path
                        Remove-Item -Path "$path/*" -Recurse -Force -ErrorAction SilentlyContinue
                        $after = Get-FolderSize $path
                        $freed = $before - $after
                        $totalFreed += $freed
                        if ($freed -gt 0) {
                            Write-Success "  Cleaned $browser - Freed $(Format-Bytes $freed)"
                        }
                    } catch {}
                }
            }
        }
    }

    # Developer caches
    if ($All -or $Dev) {
        Write-Host "Cleaning developer caches..."

        # npm
        if (Get-Command npm -ErrorAction SilentlyContinue) {
            try {
                $before = Get-FolderSize "$env:HOME/.npm"
                npm cache clean --force *> $null
                $after = Get-FolderSize "$env:HOME/.npm"
                $freed = $before - $after
                $totalFreed += $freed
                Write-Success "  Cleaned npm cache - Freed $(Format-Bytes $freed)"
            } catch {}
        }

        # yarn
        if (Get-Command yarn -ErrorAction SilentlyContinue) {
            try {
                $before = Get-FolderSize "$env:HOME/Library/Caches/Yarn"
                yarn cache clean *> $null
                $after = Get-FolderSize "$env:HOME/Library/Caches/Yarn"
                $freed = $before - $after
                $totalFreed += $freed
                Write-Success "  Cleaned yarn cache - Freed $(Format-Bytes $freed)"
            } catch {}
        }

        # pip
        if (Get-Command pip3 -ErrorAction SilentlyContinue) {
            try {
                pip3 cache purge *> $null
                Write-Success "  Cleaned pip cache"
            } catch {}
        }

        # Homebrew
        if (Get-Command brew -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning Homebrew..."
                brew cleanup -s *> $null
                Write-Success "  Cleaned Homebrew cache"
            } catch {}
        }

        # Xcode
        if (Test-Path "$env:HOME/Library/Developer/Xcode/DerivedData") {
            try {
                $before = Get-FolderSize "$env:HOME/Library/Developer/Xcode/DerivedData"
                Remove-Item -Path "$env:HOME/Library/Developer/Xcode/DerivedData/*" -Recurse -Force -ErrorAction SilentlyContinue
                $after = Get-FolderSize "$env:HOME/Library/Developer/Xcode/DerivedData"
                $freed = $before - $after
                $totalFreed += $freed
                Write-Success "  Cleaned Xcode DerivedData - Freed $(Format-Bytes $freed)"
            } catch {}
        }

        # Docker
        if (Get-Command docker -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning Docker system..."
                docker system prune -af --volumes *> $null
                Write-Success "  Cleaned Docker system"
            } catch {}
        }
    }

    # System logs
    if ($All -or $Logs) {
        Write-Host "Cleaning system logs..."
        $logPaths = @(
            "$env:HOME/Library/Logs",
            "/Library/Logs",
            "/var/log"
        )

        foreach ($path in $logPaths) {
            if (Test-Path $path) {
                try {
                    $before = Get-FolderSize $path
                    sudo rm -rf "$path/*" 2>$null
                    $after = Get-FolderSize $path
                    $freed = $before - $after
                    $totalFreed += $freed
                    if ($freed -gt 0) {
                        Write-Success "  Cleaned $path - Freed $(Format-Bytes $freed)"
                    }
                } catch {
                    Write-Warning "  Could not clean $path (requires sudo)"
                }
            }
        }
    }
}

# =============================================
# LINUX CLEANERS
# =============================================
function Invoke-LinuxCleanup {
    Write-Info "=== Linux Disk Cleanup ==="

    # Package manager caches
    if ($All -or $Cache) {
        Write-Host "Cleaning package manager caches..."

        # apt/debian
        if (Get-Command apt-get -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning apt cache..."
                sudo apt-get clean *> $null
                sudo apt-get autoclean *> $null
                sudo apt-get autoremove -y *> $null
                Write-Success "  Cleaned apt cache"
            } catch {}
        }

        # dnf/fedora
        if (Get-Command dnf -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning dnf cache..."
                sudo dnf clean all *> $null
                sudo dnf autoremove -y *> $null
                Write-Success "  Cleaned dnf cache"
            } catch {}
        }

        # pacman/arch
        if (Get-Command pacman -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning pacman cache..."
                sudo pacman -Sc --noconfirm *> $null
                sudo pacman -Scc --noconfirm *> $null
                Write-Success "  Cleaned pacman cache"
            } catch {}
        }

        # yum/older rhel
        if (Get-Command yum -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning yum cache..."
                sudo yum clean all *> $null
                Write-Success "  Cleaned yum cache"
            } catch {}
        }
    }

    # Temp files
    if ($All -or $Temp) {
        Write-Host "Cleaning temp files..."
        $tempPaths = @("/tmp", "/var/tmp", "$env:HOME/.cache")

        foreach ($path in $tempPaths) {
            if (Test-Path $path) {
                try {
                    $before = Get-FolderSize $path
                    sudo rm -rf "$path/*" 2>$null
                    $after = Get-FolderSize $path
                    $freed = $before - $after
                    $totalFreed += $freed
                    Write-Success "  Cleaned $path - Freed $(Format-Bytes $freed)"
                } catch {
                    Write-Warning "  Could not clean $path (requires sudo)"
                }
            }
        }
    }

    # Logs
    if ($All -or $Logs) {
        Write-Host "Cleaning system logs..."
        try {
            $before = Get-FolderSize "/var/log"
            sudo journalctl --vacuum-time=7d *> $null
            $after = Get-FolderSize "/var/log"
            $freed = $before - $after
            $totalFreed += $freed
            Write-Success "  Cleaned journal logs - Freed $(Format-Bytes $freed)"
        } catch {
            Write-Warning "  Could not clean logs (requires sudo)"
        }
    }

    # Developer caches
    if ($All -or $Dev) {
        Write-Host "Cleaning developer caches..."

        # npm
        if (Get-Command npm -ErrorAction SilentlyContinue) {
            try {
                $before = Get-FolderSize "$env:HOME/.npm"
                npm cache clean --force *> $null
                $after = Get-FolderSize "$env:HOME/.npm"
                $freed = $before - $after
                $totalFreed += $freed
                Write-Success "  Cleaned npm cache - Freed $(Format-Bytes $freed)"
            } catch {}
        }

        # pip
        if (Get-Command pip3 -ErrorAction SilentlyContinue) {
            try {
                pip3 cache purge *> $null
                Write-Success "  Cleaned pip cache"
            } catch {}
        }

        # Docker
        if (Get-Command docker -ErrorAction SilentlyContinue) {
            try {
                Write-Host "  Cleaning Docker system..."
                sudo docker system prune -af --volumes *> $null
                Write-Success "  Cleaned Docker system"
            } catch {}
        }
    }

    # Thumbnails cache
    if ($All) {
        Write-Host "Cleaning thumbnails..."
        $thumbPath = "$env:HOME/.cache/thumbnails"
        if (Test-Path $thumbPath) {
            try {
                $before = Get-FolderSize $thumbPath
                rm -rf "$thumbPath/*" 2>$null
                $after = Get-FolderSize $thumbPath
                $freed = $before - $after
                $totalFreed += $freed
                Write-Success "  Cleaned thumbnails - Freed $(Format-Bytes $freed)"
            } catch {}
        }
    }
}

# =============================================
# MAIN
# =============================================
Write-Info ""
Write-Info "╔════════════════════════════════════════╗"
Write-Info "║   Universal Disk Cleanup Tool v2.0    ║"
Write-Info "╚════════════════════════════════════════╝"
Write-Info ""
Write-Host "Detected OS: $OS" -ForegroundColor Cyan
Write-Host ""

# Show disk space before
$drive = if ($OS -eq "Windows") { Get-PSDrive C } else { Get-PSDrive / }
$beforeFree = $drive.Free
Write-Host "Free space before: $(Format-Bytes $beforeFree)" -ForegroundColor Gray
Write-Host ""

# Run OS-specific cleanup
switch ($OS) {
    "Windows" { Invoke-WindowsCleanup }
    "macOS"   { Invoke-MacOSCleanup }
    "Linux"   { Invoke-LinuxCleanup }
}

# Show results
Write-Host ""
Write-Info "=== RESULTS ==="
Write-Success "Total space freed: $(Format-Bytes $totalFreed)"

$drive = if ($OS -eq "Windows") { Get-PSDrive C } else { Get-PSDrive / }
$afterFree = $drive.Free
Write-Host "Free space after:  $(Format-Bytes $afterFree)" -ForegroundColor Gray
Write-Host "Actual freed:       $(Format-Bytes ($afterFree - $beforeFree))" -ForegroundColor Green

Write-Host ""
Write-Success "Cleanup complete!"
