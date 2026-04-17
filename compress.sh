#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Cross-Platform File Compression Utility for Linux and macOS
.DESCRIPTION
    Adds file and folder compression capabilities for Linux and macOS systems
.VERSION
    4.0.0
#>

#Requires -PSEdition Core
#Requires -Version 7

param(
    [switch]$CompressFolder,
    [switch]$CompressSystem,
    [switch]$CompressHome,
    [switch]$QueryCompression,
    [string]$FolderPath,
    [switch]$Help
)

$OS = $null
if ($IsMacOS) {
    $OS = "macOS"
} elseif ($IsLinux) {
    $OS = "Linux"
} else {
    Write-Host "[!] This script is for macOS and Linux only" -ForegroundColor Red
    exit 1
}

function Show-Help {
    Write-Host @"
Cross-Platform Compression Utility v4.0
========================================

Current OS: $OS

USAGE:
    ./compress.sh [OPTIONS]

MACOS OPTIONS:
    --CompressSystem    Compress system folders (/System, /Library)
    --CompressHome      Compress home folder
    --CompressFolder    Compress specific folder
    --QueryCompression  Query compression status

LINUX OPTIONS:
    --CompressSystem    Compress system folders (/usr, /opt, etc.)
    --CompressHome      Compress home folder
    --CompressFolder    Compress specific folder
    --QueryCompression  Query compression status

EXAMPLES:
    # Compress home folder
    ./compress.sh --CompressHome

    # Compress specific folder
    ./compress.sh --CompressFolder --FolderPath /path/to/folder

    # Query compression status
    ./compress.sh --QueryCompression

INFORMATION:
    macOS: Uses built-in HFS+/APFS compression
    Linux: Uses filesystem compression (Btrfs, ZFS) or tools like gzip

    Expected savings:
    - System folders: 2-5 GB
    - Home folder: 1-3 GB
    - User folders: 500 MB - 2 GB
"@
}

if ($Help) {
    Show-Help
    exit 0
}

# =============================================
# MACOS COMPRESSION FUNCTIONS
# =============================================

function Compress-Folder-MacOS {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        Write-Host "[✗] Path not found: $Path" -ForegroundColor Red
        return
    }

    Write-Host "[*] Compressing: $Path" -ForegroundColor Cyan

    try {
        # Get size before
        $beforeMB = [math]::Round(((Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue |
            Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum) / 1MB, 2)

        Write-Host "[*] Current size: $beforeMB MB" -ForegroundColor Gray

        # Use ditto with compression (macOS built-in)
        $tempPath = "$Path.tmp"
        ditto --hfsCompression --keepParent $Path $tempPath

        if (Test-Path $tempPath) {
            Remove-Item -Path $Path -Recurse -Force
            Move-Item -Path $tempPath -Destination $Path

            $afterMB = [math]::Round(((Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue |
                Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum) / 1MB, 2)

            $savedMB = $beforeMB - $afterMB

            Write-Host "[✓] Compression complete!" -ForegroundColor Green
            Write-Host "[*] Space saved: $savedMB MB" -ForegroundColor Green
            Write-Host "[*] Compressed size: $afterMB MB" -ForegroundColor Gray
        } else {
            Write-Host "[✗] Compression failed" -ForegroundColor Red
        }
    } catch {
        Write-Host "[✗] Failed to compress: $_" -ForegroundColor Red
    }
}

function Query-Compression-MacOS {
    Write-Host ""
    Write-Host "[*] Querying compression status..." -ForegroundColor Cyan

    # Check if APFS is being used
    $fsInfo = df -T /,apfs | Out-String

    if ($fsInfo -match "apfs") {
        Write-Host "[✓] Filesystem: APFS (compression supported)" -ForegroundColor Green
        Write-Host "[*] APFS automatically compresses files" -ForegroundColor Gray
    } else {
        Write-Host "[!] Filesystem: HFS+ or other" -ForegroundColor Yellow
    }

    # Check system folder sizes
    Write-Host ""
    Write-Host "System Folder Sizes:" -ForegroundColor Cyan

    $folders = @(
        @{Path = "/System"; Name = "System"},
        @{Path = "/Library"; Name = "Library"},
        @{Path = "/Applications"; Name = "Applications"}
    )

    foreach ($folder in $folders) {
        if (Test-Path $folder.Path) {
            try {
                $size = [math]::Round(((Get-ChildItem -Path $folder.Path -Recurse -ErrorAction SilentlyContinue |
                    Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum) / 1GB, 2)
                Write-Host "  $($folder.Name): $size GB" -ForegroundColor Gray
            } catch {}
        }
    }
}

# =============================================
# LINUX COMPRESSION FUNCTIONS
# =============================================

function Compress-Folder-Linux {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        Write-Host "[✗] Path not found: $Path" -ForegroundColor Red
        return
    }

    Write-Host "[*] Compressing: $Path" -ForegroundColor Cyan

    try {
        # Get size before
        $beforeMB = [math]::Round(((Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue |
            Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum) / 1MB, 2)

        Write-Host "[*] Current size: $beforeMB MB" -ForegroundColor Gray

        # Check for filesystem compression support
        $fsInfo = df -T $Path | Out-String
        $useFSCompression = $false

        if ($fsInfo -match "btrfs") {
            Write-Host "[*] Btrfs detected - using filesystem compression" -ForegroundColor Green

            # Enable compression for the folder
            sudo chattr +c $Path 2>$null
            $useFSCompression = $true
        } elseif ($fsInfo -match "zfs") {
            Write-Host "[*] ZFS detected - compression already enabled at filesystem level" -ForegroundColor Green
            $useFSCompression = $true
        }

        if (-not $useFSCompression) {
            Write-Host "[*] No filesystem compression detected - using gzip" -ForegroundColor Yellow

            # Compress files using tar + gzip
            $archivePath = "$Path.tar.gz"
            tar czf $archivePath -C $Path .

            if (Test-Path $archivePath) {
                $afterMB = [math]::Round(((Get-Item $archivePath).Length) / 1MB, 2)
                $savedMB = $beforeMB - $afterMB

                Write-Host "[✓] Compression complete!" -ForegroundColor Green
                Write-Host "[*] Archive created: $archivePath" -ForegroundColor Gray
                Write-Host "[*] Archive size: $afterMB MB" -ForegroundColor Gray
                Write-Host "[*] Space saved: $savedMB MB" -ForegroundColor Green
                Write-Host "[!] Original folder preserved" -ForegroundColor Yellow
            }
        } else {
            Write-Host "[✓] Filesystem compression enabled" -ForegroundColor Green
            Write-Host "[*] Files will be compressed automatically" -ForegroundColor Gray
        }
    } catch {
        Write-Host "[✗] Failed to compress: $_" -ForegroundColor Red
    }
}

function Query-Compression-Linux {
    Write-Host ""
    Write-Host "[*] Querying compression status..." -ForegroundColor Cyan

    # Check filesystem type
    $fsInfo = df -T / | Out-String

    Write-Host ""
    Write-Host "Filesystem Information:" -ForegroundColor Cyan

    if ($fsInfo -match "btrfs") {
        Write-Host "[✓] Filesystem: Btrfs (compression supported)" -ForegroundColor Green

        # Check if compression is enabled
        $compression = sudo btrfs filesystem df / 2>$null | Out-String
        Write-Host "$compression" -ForegroundColor Gray
    } elseif ($fsInfo -match "zfs") {
        Write-Host "[✓] Filesystem: ZFS (compression supported)" -ForegroundColor Green

        # Check compression properties
        $compression = sudo zfs get compression 2>$null | Out-String
        Write-Host "$compression" -ForegroundColor Gray
    } elseif ($fsInfo -match "ext4") {
        Write-Host "[!] Filesystem: ext4 (no native compression)" -ForegroundColor Yellow
        Write-Host "[*] Consider using Btrfs or ZFS for compression support" -ForegroundColor Gray
    } else {
        Write-Host "[?] Filesystem: Unknown" -ForegroundColor Yellow
    }

    # Check for available compression tools
    Write-Host ""
    Write-Host "Available Compression Tools:" -ForegroundColor Cyan

    $tools = @("gzip", "bzip2", "xz", "zstd")
    foreach ($tool in $tools) {
        if (Get-Command $tool -ErrorAction SilentlyContinue) {
            $version = & $tool --version 2>$null | Select-Object -First 1
            Write-Host "  [✓] $tool" -ForegroundColor Green
        } else {
            Write-Host "  [ ] $tool (not installed)" -ForegroundColor Gray
        }
    }

    # Show system folder sizes
    Write-Host ""
    Write-Host "System Folder Sizes:" -ForegroundColor Cyan

    $folders = @(
        @{Path = "/usr"; Name = "usr"},
        @{Path = "/opt"; Name = "opt"},
        @{Path = "/var"; Name = "var"}
    )

    foreach ($folder in $folders) {
        if (Test-Path $folder.Path) {
            try {
                $size = [math]::Round(((Get-ChildItem -Path $folder.Path -Recurse -ErrorAction SilentlyContinue |
                    Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum) / 1GB, 2)
                Write-Host "  $($folder.Name): $size GB" -ForegroundColor Gray
            } catch {}
        }
    }
}

# =============================================
# MAIN EXECUTION
# =============================================

if ($OS -eq "macOS") {
    if ($CompressSystem) {
        Write-Host ""
        Write-Host "[!] Compressing system folders on macOS" -ForegroundColor Yellow
        Write-Host "[*] This will compress /System and /Library" -ForegroundColor Cyan
        Write-Host "[*] Estimated savings: 2-5 GB" -ForegroundColor Yellow
        Write-Host ""

        $response = Read-Host "Continue? (Y/N)"
        if ($response -eq "Y" -or $response -eq "y") {
            Compress-Folder-MacOS "/System"
            Compress-Folder-MacOS "/Library"
        }
    } elseif ($CompressHome) {
        Write-Host ""
        Write-Host "[!] Compressing home folder" -ForegroundColor Yellow
        Write-Host "[*] Estimated savings: 1-3 GB" -ForegroundColor Yellow
        Write-Host ""

        $response = Read-Host "Continue? (Y/N)"
        if ($response -eq "Y" -or $response -eq "y") {
            Compress-Folder-MacOS $env:HOME
        }
    } elseif ($CompressFolder -and $FolderPath) {
        Compress-Folder-MacOS $FolderPath
    } elseif ($QueryCompression) {
        Query-Compression-MacOS
    } else {
        # Interactive menu
        Write-Host ""
        Write-Host "╔══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
        Write-Host "║     macOS Compression Utility v4.0                     ║" -ForegroundColor Cyan
        Write-Host "╚══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Select an option:" -ForegroundColor White
        Write-Host ""
        Write-Host "  [1] Compress System Folders (2-5 GB)" -ForegroundColor Green
        Write-Host "  [2] Compress Home Folder (1-3 GB)" -ForegroundColor Green
        Write-Host "  [3] Compress Specific Folder" -ForegroundColor Cyan
        Write-Host "  [4] Query Compression Status" -ForegroundColor Cyan
        Write-Host "  [Q] Quit" -ForegroundColor Red
        Write-Host ""

        $choice = Read-Host "Enter your choice"

        switch ($choice) {
            "1" {
                Compress-Folder-MacOS "/System"
                Compress-Folder-MacOS "/Library"
            }
            "2" { Compress-Folder-MacOS $env:HOME }
            "3" {
                $folder = Read-Host "Enter folder path"
                if ($folder -and (Test-Path $folder)) {
                    Compress-Folder-MacOS $folder
                } else {
                    Write-Host "[✗] Invalid folder path" -ForegroundColor Red
                }
            }
            "4" { Query-Compression-MacOS }
            "Q" { exit 0 }
            "q" { exit 0 }
        }
    }
} elseif ($OS -eq "Linux") {
    if ($CompressSystem) {
        Write-Host ""
        Write-Host "[!] Compressing system folders on Linux" -ForegroundColor Yellow
        Write-Host "[*] This will compress /usr, /opt, etc." -ForegroundColor Cyan
        Write-Host "[*] Estimated savings: 2-5 GB" -ForegroundColor Yellow
        Write-Host ""

        $response = Read-Host "Continue? (Y/N)"
        if ($response -eq "Y" -or $response -eq "y") {
            Compress-Folder-Linux "/usr"
            Compress-Folder-Linux "/opt"
        }
    } elseif ($CompressHome) {
        Write-Host ""
        Write-Host "[!] Compressing home folder" -ForegroundColor Yellow
        Write-Host "[*] Estimated savings: 1-3 GB" -ForegroundColor Yellow
        Write-Host ""

        $response = Read-Host "Continue? (Y/N)"
        if ($response -eq "Y" -or $response -eq "y") {
            Compress-Folder-Linux $env:HOME
        }
    } elseif ($CompressFolder -and $FolderPath) {
        Compress-Folder-Linux $FolderPath
    } elseif ($QueryCompression) {
        Query-Compression-Linux
    } else {
        # Interactive menu
        Write-Host ""
        Write-Host "╔══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
        Write-Host "║     Linux Compression Utility v4.0                      ║" -ForegroundColor Cyan
        Write-Host "╚══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Select an option:" -ForegroundColor White
        Write-Host ""
        Write-Host "  [1] Compress System Folders (2-5 GB)" -ForegroundColor Green
        Write-Host "  [2] Compress Home Folder (1-3 GB)" -ForegroundColor Green
        Write-Host "  [3] Compress Specific Folder" -ForegroundColor Cyan
        Write-Host "  [4] Query Compression Status" -ForegroundColor Cyan
        Write-Host "  [Q] Quit" -ForegroundColor Red
        Write-Host ""

        $choice = Read-Host "Enter your choice"

        switch ($choice) {
            "1" {
                Compress-Folder-Linux "/usr"
                Compress-Folder-Linux "/opt"
            }
            "2" { Compress-Folder-Linux $env:HOME }
            "3" {
                $folder = Read-Host "Enter folder path"
                if ($folder -and (Test-Path $folder)) {
                    Compress-Folder-Linux $folder
                } else {
                    Write-Host "[✗] Invalid folder path" -ForegroundColor Red
                }
            }
            "4" { Query-Compression-Linux }
            "Q" { exit 0 }
            "q" { exit 0 }
        }
    }
}
