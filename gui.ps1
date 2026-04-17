#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Universal Disk Cleanup Tool GUI v4.0 - Cross-platform GUI interface
.DESCRIPTION
    Graphical interface for disk cleanup on Windows, macOS, and Linux
.VERSION
    4.0.0
#>

#Requires -PSEdition Core
#Requires -Version 7

param(
    [switch]$Help
)

if ($Help) {
    Write-Host @"
Universal Disk Cleanup Tool GUI v4.0
=====================================

USAGE:
    gui.ps1

PLATFORM SUPPORT:
    - Windows: Full GUI with Windows Forms
    - macOS/Linux: Interactive Terminal Menu

FEATURES:
    - Visual cleanup options selection
    - Real-time progress tracking
    - Detailed results display
    - Export/Import settings
    - Scheduled cleanup setup

For more info: https://github.com/chibuenyim/UniversalDiskCleanupTool
"@
    exit 0
}

# Detect OS
function Get-OS {
    if ($IsWindows) { return "Windows" }
    elseif ($IsMacOS) { return "macOS" }
    elseif ($IsLinux) { return "Linux" }
    else { return "Unknown" }
}

$OS = Get-OS

# =============================================
# WINDOWS GUI (Windows Forms)
# =============================================
function Show-WindowsGUI {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    # Create main form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "🧹 Universal Disk Cleanup Tool v4.0"
    $form.Size = New-Object System.Drawing.Size(700, 650)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.BackColor = [System.Drawing.Color]::White

    # Title
    $titleLabel = New-Object System.Windows.Forms.Label
    $titleLabel.Location = New-Object System.Drawing.Point(20, 20)
    $titleLabel.Size = New-Object System.Drawing.Size(650, 40)
    $titleLabel.Text = "Universal Disk Cleanup Tool"
    $titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
    $titleLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
    $form.Controls.Add($titleLabel)

    # Subtitle
    $subtitleLabel = New-Object System.Windows.Forms.Label
    $subtitleLabel.Location = New-Object System.Drawing.Point(20, 65)
    $subtitleLabel.Size = New-Object System.Drawing.Size(650, 20)
    $subtitleLabel.Text = "Cross-platform disk cleanup for Windows, macOS, and Linux"
    $subtitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $subtitleLabel.ForeColor = [System.Drawing.Color]::Gray
    $form.Controls.Add($subtitleLabel)

    # Cleanup Options Group
    $cleanupGroup = New-Object System.Windows.Forms.GroupBox
    $cleanupGroup.Location = New-Object System.Drawing.Point(20, 100)
    $cleanupGroup.Size = New-Object System.Drawing.Size(320, 280)
    $cleanupGroup.Text = "Cleanup Options"
    $cleanupGroup.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $form.Controls.Add($cleanupGroup)

    # Checkboxes for cleanup options
    $checkboxes = @{}

    $options = @(
        @{Name = "Temp"; Label = "Temporary Files"; Y = 30; Tip = "Clean system and user temp folders"},
        @{Name = "Browser"; Label = "Browser Caches"; Y = 60; Tip = "Clean Chrome, Firefox, Safari, Edge, etc."},
        @{Name = "Dev"; Label = "Developer Caches"; Y = 90; Tip = "Clean npm, yarn, pip, Docker, etc."},
        @{Name = "Logs"; Label = "System Logs"; Y = 120; Tip = "Clean system and application logs"},
        @{Name = "Cache"; Label = "Package Caches"; Y = 150; Tip = "Clean apt, brew, dnf, pacman, etc."},
        @{Name = "Apps"; Label = "Application Caches"; Y = 180; Tip = "Clean Spotify, Discord, Adobe, etc."},
        @{Name = "System"; Label = "System Files"; Y = 210; Tip = "Clean thumbnails, fonts, etc."}
    )

    foreach ($opt in $options) {
        $cb = New-Object System.Windows.Forms.CheckBox
        $cb.Location = New-Object System.Drawing.Point(15, $opt.Y)
        $cb.Size = New-Object System.Drawing.Size(290, 24)
        $cb.Text = $opt.Label
        $cb.Font = New-Object System.Drawing.Font("Segoe UI", 9)
        $cb.Tag = $opt.Name
        $cb.ToolTipText = $opt.Tip

        # Add tooltip
        $tooltip = New-Object System.Windows.Forms.ToolTip
        $tooltip.SetToolTip($cb, $opt.Tip)

        $checkboxes[$opt.Name] = $cb
        $cleanupGroup.Controls.Add($cb)
    }

    # Advanced Options Group
    $advancedGroup = New-Object System.Windows.Forms.GroupBox
    $advancedGroup.Location = New-Object System.Drawing.Point(360, 100)
    $advancedGroup.Size = New-Object System.Drawing.Size(300, 280)
    $advancedGroup.Text = "Advanced Options"
    $advancedGroup.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $form.Controls.Add($advancedGroup)

    $advancedCheckboxes = @{}

    $advancedOptions = @(
        @{Name = "DryRun"; Label = "Dry Run (Preview Only)"; Y = 30; Tip = "Show what would be cleaned without making changes"},
        @{Name = "ScanOnly"; Label = "Scan Only"; Y = 60; Tip = "Scan and display potential space savings"},
        @{Name = "Interactive"; Label = "Interactive Mode"; Y = 90; Tip = "Show progress bars and real-time feedback"},
        @{Name = "Verbose"; Label = "Verbose Output"; Y = 120; Tip = "Show detailed cleanup information"},
        @{Name = "Schedule"; Label = "Schedule Weekly Cleanup"; Y = 150; Tip = "Set up automatic weekly cleanup (Sundays 2 AM)"}
    )

    foreach ($opt in $advancedOptions) {
        $cb = New-Object System.Windows.Forms.CheckBox
        $cb.Location = New-Object System.Drawing.Point(15, $opt.Y)
        $cb.Size = New-Object System.Drawing.Size(270, 24)
        $cb.Text = $opt.Label
        $cb.Font = New-Object System.Drawing.Font("Segoe UI", 9)
        $cb.Tag = $opt.Name
        $cb.ToolTipText = $opt.Tip

        $tooltip = New-Object System.Windows.Forms.ToolTip
        $tooltip.SetToolTip($cb, $opt.Tip)

        $advancedCheckboxes[$opt.Name] = $cb
        $advancedGroup.Controls.Add($cb)
    }

    # Export/Import buttons
    $exportButton = New-Object System.Windows.Forms.Button
    $exportButton.Location = New-Object System.Drawing.Point(15, 190)
    $exportButton.Size = New-Object System.Drawing.Size(130, 30)
    $exportButton.Text = "📤 Export Config"
    $exportButton.Font = New-Object System.Drawing.Font("Segoe UI", 8)
    $advancedGroup.Controls.Add($exportButton)

    $importButton = New-Object System.Windows.Forms.Button
    $importButton.Location = New-Object System.Drawing.Point(155, 190)
    $importButton.Size = New-Object System.Drawing.Size(130, 30)
    $importButton.Text = "📥 Import Config"
    $importButton.Font = New-Object System.Drawing.Font("Segoe UI", 8)
    $advancedGroup.Controls.Add($importButton)

    # Select All button
    $selectAllButton = New-Object System.Windows.Forms.Button
    $selectAllButton.Location = New-Object System.Drawing.Point(15, 230)
    $selectAllButton.Size = New-Object System.Drawing.Size(130, 30)
    $selectAllButton.Text = "✅ Select All"
    $selectAllButton.Font = New-Object System.Drawing.Font("Segoe UI", 8)
    $advancedGroup.Controls.Add($selectAllButton)

    # Clear All button
    $clearAllButton = New-Object System.Windows.Forms.Button
    $clearAllButton.Location = New-Object System.Drawing.Point(155, 230)
    $clearAllButton.Size = New-Object System.Drawing.Size(130, 30)
    $clearAllButton.Text = "❌ Clear All"
    $clearAllButton.Font = New-Object System.Drawing.Font("Segoe UI", 8)
    $advancedGroup.Controls.Add($clearAllButton)

    # Start Cleanup button
    $startButton = New-Object System.Windows.Forms.Button
    $startButton.Location = New-Object System.Drawing.Point(20, 400)
    $startButton.Size = New-Object System.Drawing.Size(200, 50)
    $startButton.Text = "🚀 Start Cleanup"
    $startButton.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    $startButton.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
    $startButton.ForeColor = [System.Drawing.Color]::White
    $startButton.FlatStyle = "Flat"
    $startButton.Cursor = "Hand"
    $form.Controls.Add($startButton)

    # Exit button
    $exitButton = New-Object System.Windows.Forms.Button
    $exitButton.Location = New-Object System.Drawing.Point(480, 400)
    $exitButton.Size = New-Object System.Drawing.Size(180, 50)
    $exitButton.Text = "❌ Exit"
    $exitButton.Font = New-Object System.Drawing.Font("Segoe UI", 12)
    $exitButton.BackColor = [System.Drawing.Color]::FromArgb(108, 117, 125)
    $exitButton.ForeColor = [System.Drawing.Color]::White
    $exitButton.FlatStyle = "Flat"
    $exitButton.Cursor = "Hand"
    $form.Controls.Add($exitButton)

    # Results textbox
    $resultsLabel = New-Object System.Windows.Forms.Label
    $resultsLabel.Location = New-Object System.Drawing.Point(20, 470)
    $resultsLabel.Size = New-Object System.Drawing.Size(650, 20)
    $resultsLabel.Text = "Results:"
    $resultsLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $form.Controls.Add($resultsLabel)

    $resultsTextbox = New-Object System.Windows.Forms.TextBox
    $resultsTextbox.Location = New-Object System.Drawing.Point(20, 495)
    $resultsTextbox.Size = New-Object System.Drawing.Size(640, 110)
    $resultsTextbox.Multiline = $true
    $resultsTextbox.ScrollBars = "Vertical"
    $resultsTextbox.ReadOnly = $true
    $resultsTextbox.BackColor = [System.Drawing.Color]::FromArgb(248, 249, 250)
    $resultsTextbox.Font = New-Object System.Drawing.Font("Consolas", 9)
    $form.Controls.Add($resultsTextbox)

    # Event handlers
    $selectAllButton.Add_Click({
        foreach ($cb in $checkboxes.Values) { $cb.Checked = $true }
    })

    $clearAllButton.Add_Click({
        foreach ($cb in $checkboxes.Values) { $cb.Checked = $false }
        foreach ($cb in $advancedCheckboxes.Values) { $cb.Checked = $false }
    })

    $exportButton.Add_Click({
        $scriptPath = Join-Path $PSScriptRoot "cleanup.ps1"
        $output = & pwsh -File $scriptPath --ExportConfig 2>&1
        $resultsTextbox.AppendText("$(Get-Date -Format 'HH:mm:ss') - Exported configuration`r`n")
        [System.Windows.Forms.MessageBox]::Show("Configuration exported successfully!", "Export Complete", "OK", "Information")
    })

    $importButton.Add_Click({
        $scriptPath = Join-Path $PSScriptRoot "cleanup.ps1"
        $output = & pwsh -File $scriptPath --ImportConfig 2>&1
        $resultsTextbox.AppendText("$(Get-Date -Format 'HH:mm:ss') - Imported configuration`r`n")
        [System.Windows.Forms.MessageBox]::Show("Configuration imported successfully!", "Import Complete", "OK", "Information")
    })

    $startButton.Add_Click({
        $startButton.Enabled = $false
        $resultsTextbox.Clear()

        # Build arguments
        $arguments = @()
        $anySelected = $false

        foreach ($opt in $checkboxes.Values) {
            if ($opt.Checked) {
                $arguments += "--$($opt.Tag)"
                $anySelected = $true
            }
        }

        foreach ($opt in $advancedCheckboxes.Values) {
            if ($opt.Checked) {
                if ($opt.Tag -eq "Schedule") {
                    # Schedule is special - run it separately
                    $scriptPath = Join-Path $PSScriptRoot "cleanup.ps1"
                    $output = & pwsh -File $scriptPath --Schedule 2>&1
                    $resultsTextbox.AppendText("$(Get-Date -Format 'HH:mm:ss') - Scheduled weekly cleanup`r`n")
                } else {
                    $arguments += "--$($opt.Tag)"
                }
            }
        }

        if (-not $anySelected) {
            $resultsTextbox.AppendText("$(Get-Date -Format 'HH:mm:ss') - ERROR: Please select at least one cleanup option`r`n")
            $startButton.Enabled = $true
            return
        }

        # Run cleanup
        $resultsTextbox.AppendText("$(Get-Date -Format 'HH:mm:ss') - Starting cleanup...`r`n")
        $resultsTextbox.AppendText("$(Get-Date -Format 'HH:mm:ss') - Options: $($arguments -join ', ')`r`n`r`n")

        $scriptPath = Join-Path $PSScriptRoot "cleanup.ps1"
        $job = Start-Job -ScriptBlock {
            param($scriptPath, $arguments)
            & pwsh -File $scriptPath @arguments
        } -ArgumentList $scriptPath, $arguments

        # Update progress
        $timer = New-Object System.Windows.Forms.Timer
        $timer.Interval = 500
        $timer.Add_Tick({
            if ($job.State -eq "Completed" -or $job.State -eq "Failed") {
                $timer.Stop()
                $output = Receive-Job $job
                foreach ($line in $output) {
                    $resultsTextbox.AppendText("$line`r`n")
                }
                $resultsTextbox.AppendText("`r`n$(Get-Date -Format 'HH:mm:ss') - Cleanup complete!`r`n")
                $startButton.Enabled = $true
                Remove-Job $job
            } else {
                $resultsTextbox.AppendText(".")
                $resultsTextbox.SelectionStart = $resultsTextbox.Text.Length
                $resultsTextbox.ScrollToCaret()
            }
        })
        $timer.Start()
    })

    $exitButton.Add_Click({
        $form.Close()
    })

    # Show form
    $form.ShowDialog() | Out-Null
}

# =============================================
# MACOS/LINUX INTERACTIVE TERMINAL MENU
# =============================================
function Show-TerminalMenu {
    function Show-Menu {
        Clear-Host
        Write-Host ""
        Write-Host "╔══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
        Write-Host "║     🧹 Universal Disk Cleanup Tool v4.0                  ║" -ForegroundColor Cyan
        Write-Host "║     Interactive Terminal Menu                             ║" -ForegroundColor Cyan
        Write-Host "╚══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Detected OS: $OS" -ForegroundColor Yellow
        Write-Host ""
    }

    function Show-Options {
        Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Gray
        Write-Host " CLEANUP OPTIONS" -ForegroundColor White
        Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Gray
        Write-Host "  [1] Temporary Files      - System and user temp folders" -ForegroundColor White
        Write-Host "  [2] Browser Caches       - Chrome, Firefox, Safari, etc." -ForegroundColor White
        Write-Host "  [3] Developer Caches     - npm, yarn, pip, Docker, etc." -ForegroundColor White
        Write-Host "  [4] System Logs          - System and application logs" -ForegroundColor White
        Write-Host "  [5] Package Caches       - apt, brew, dnf, pacman, etc." -ForegroundColor White
        Write-Host "  [6] Application Caches   - Spotify, Discord, Adobe, etc." -ForegroundColor White
        Write-Host "  [7] System Files         - Thumbnails, fonts, etc." -ForegroundColor White
        Write-Host ""
        Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Gray
        Write-Host " ADVANCED OPTIONS" -ForegroundColor White
        Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Gray
        Write-Host "  [A] Select All           - Select all cleanup options" -ForegroundColor White
        Write-Host "  [C] Clear Selection      - Clear all selections" -ForegroundColor White
        Write-Host "  [D] Dry Run              - Preview without changes" -ForegroundColor White
        Write-Host "  [S] Scan Only            - Show what would be cleaned" -ForegroundColor White
        Write-Host "  [I] Interactive Mode     - Show progress bars" -ForegroundColor White
        Write-Host "  [V] Verbose Output       - Detailed cleanup info" -ForegroundColor White
        Write-Host ""
        Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Gray
        Write-Host " ACTIONS" -ForegroundColor White
        Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Gray
        Write-Host "  [E] Export Configuration  - Save current settings" -ForegroundColor White
        Write-Host "  [M] Import Configuration  - Load saved settings" -ForegroundColor White
        Write-Host "  [L] Schedule Cleanup     - Set up weekly automatic cleanup" -ForegroundColor White
        Write-Host "  [R] Run Cleanup          - Start cleanup with selected options" -ForegroundColor Green
        Write-Host "  [Q] Quit                 - Exit the program" -ForegroundColor Red
        Write-Host ""
    }

    $selectedOptions = @()
    $advancedOptions = @()

    while ($true) {
        Show-Menu
        Show-Options

        Write-Host "Selected Options: " -NoNewline -ForegroundColor Cyan
        if ($selectedOptions.Count -eq 0) {
            Write-Host "None" -ForegroundColor Gray
        } else {
            Write-Host ($selectedOptions -join ", ") -ForegroundColor Green
        }

        Write-Host "Advanced Options: " -NoNewline -ForegroundColor Cyan
        if ($advancedOptions.Count -eq 0) {
            Write-Host "None" -ForegroundColor Gray
        } else {
            Write-Host ($advancedOptions -join ", ") -ForegroundColor Yellow
        }

        Write-Host ""
        $choice = Read-Host "Enter your choice"

        switch ($choice.ToUpper()) {
            "1" {
                if ($selectedOptions -contains "Temp") {
                    $selectedOptions = $selectedOptions | Where-Object { $_ -ne "Temp" }
                    Write-Host "Removed: Temporary Files" -ForegroundColor Yellow
                } else {
                    $selectedOptions += "Temp"
                    Write-Host "Added: Temporary Files" -ForegroundColor Green
                }
            }
            "2" {
                if ($selectedOptions -contains "Browser") {
                    $selectedOptions = $selectedOptions | Where-Object { $_ -ne "Browser" }
                    Write-Host "Removed: Browser Caches" -ForegroundColor Yellow
                } else {
                    $selectedOptions += "Browser"
                    Write-Host "Added: Browser Caches" -ForegroundColor Green
                }
            }
            "3" {
                if ($selectedOptions -contains "Dev") {
                    $selectedOptions = $selectedOptions | Where-Object { $_ -ne "Dev" }
                    Write-Host "Removed: Developer Caches" -ForegroundColor Yellow
                } else {
                    $selectedOptions += "Dev"
                    Write-Host "Added: Developer Caches" -ForegroundColor Green
                }
            }
            "4" {
                if ($selectedOptions -contains "Logs") {
                    $selectedOptions = $selectedOptions | Where-Object { $_ -ne "Logs" }
                    Write-Host "Removed: System Logs" -ForegroundColor Yellow
                } else {
                    $selectedOptions += "Logs"
                    Write-Host "Added: System Logs" -ForegroundColor Green
                }
            }
            "5" {
                if ($selectedOptions -contains "Cache") {
                    $selectedOptions = $selectedOptions | Where-Object { $_ -ne "Cache" }
                    Write-Host "Removed: Package Caches" -ForegroundColor Yellow
                } else {
                    $selectedOptions += "Cache"
                    Write-Host "Added: Package Caches" -ForegroundColor Green
                }
            }
            "6" {
                if ($selectedOptions -contains "Apps") {
                    $selectedOptions = $selectedOptions | Where-Object { $_ -ne "Apps" }
                    Write-Host "Removed: Application Caches" -ForegroundColor Yellow
                } else {
                    $selectedOptions += "Apps"
                    Write-Host "Added: Application Caches" -ForegroundColor Green
                }
            }
            "7" {
                if ($selectedOptions -contains "System") {
                    $selectedOptions = $selectedOptions | Where-Object { $_ -ne "System" }
                    Write-Host "Removed: System Files" -ForegroundColor Yellow
                } else {
                    $selectedOptions += "System"
                    Write-Host "Added: System Files" -ForegroundColor Green
                }
            }
            "A" {
                $selectedOptions = @("Temp", "Browser", "Dev", "Logs", "Cache", "Apps", "System")
                Write-Host "All cleanup options selected!" -ForegroundColor Green
            }
            "C" {
                $selectedOptions = @()
                $advancedOptions = @()
                Write-Host "All selections cleared!" -ForegroundColor Yellow
            }
            "D" {
                if ($advancedOptions -contains "DryRun") {
                    $advancedOptions = $advancedOptions | Where-Object { $_ -ne "DryRun" }
                    Write-Host "Removed: Dry Run" -ForegroundColor Yellow
                } else {
                    $advancedOptions += "DryRun"
                    Write-Host "Added: Dry Run (Preview Only)" -ForegroundColor Green
                }
            }
            "S" {
                if ($advancedOptions -contains "ScanOnly") {
                    $advancedOptions = $advancedOptions | Where-Object { $_ -ne "ScanOnly" }
                    Write-Host "Removed: Scan Only" -ForegroundColor Yellow
                } else {
                    $advancedOptions += "ScanOnly"
                    Write-Host "Added: Scan Only" -ForegroundColor Green
                }
            }
            "I" {
                if ($advancedOptions -contains "Interactive") {
                    $advancedOptions = $advancedOptions | Where-Object { $_ -ne "Interactive" }
                    Write-Host "Removed: Interactive Mode" -ForegroundColor Yellow
                } else {
                    $advancedOptions += "Interactive"
                    Write-Host "Added: Interactive Mode" -ForegroundColor Green
                }
            }
            "V" {
                if ($advancedOptions -contains "Verbose") {
                    $advancedOptions = $advancedOptions | Where-Object { $_ -ne "Verbose" }
                    Write-Host "Removed: Verbose Output" -ForegroundColor Yellow
                } else {
                    $advancedOptions += "Verbose"
                    Write-Host "Added: Verbose Output" -ForegroundColor Green
                }
            }
            "E" {
                Write-Host "`nExporting configuration..." -ForegroundColor Cyan
                $scriptPath = Join-Path $PSScriptRoot "cleanup.ps1"
                & pwsh -File $scriptPath --ExportConfig
                Write-Host "Configuration exported!" -ForegroundColor Green
                Read-Host "Press Enter to continue"
            }
            "M" {
                Write-Host "`nImporting configuration..." -ForegroundColor Cyan
                $scriptPath = Join-Path $PSScriptRoot "cleanup.ps1"
                & pwsh -File $scriptPath --ImportConfig
                Write-Host "Configuration imported!" -ForegroundColor Green
                Read-Host "Press Enter to continue"
            }
            "L" {
                Write-Host "`nSetting up scheduled cleanup..." -ForegroundColor Cyan
                $scriptPath = Join-Path $PSScriptRoot "cleanup.ps1"
                & pwsh -File $scriptPath --Schedule
                Write-Host "Scheduled cleanup configured!" -ForegroundColor Green
                Read-Host "Press Enter to continue"
            }
            "R" {
                if ($selectedOptions.Count -eq 0) {
                    Write-Host "`nERROR: Please select at least one cleanup option!" -ForegroundColor Red
                    Read-Host "Press Enter to continue"
                    continue
                }

                Write-Host "`n═══════════════════════════════════════════════════════════" -ForegroundColor Green
                Write-Host " STARTING CLEANUP" -ForegroundColor Green
                Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
                Write-Host "Options: $($selectedOptions -join ', ')" -ForegroundColor Cyan
                if ($advancedOptions.Count -gt 0) {
                    Write-Host "Advanced: $($advancedOptions -join ', ')" -ForegroundColor Yellow
                }
                Write-Host ""

                $scriptPath = Join-Path $PSScriptRoot "cleanup.ps1"
                $arguments = $selectedOptions | ForEach-Object { "--$_" }
                foreach ($opt in $advancedOptions) {
                    $arguments += "--$opt"
                }

                & pwsh -File $scriptPath @arguments

                Write-Host "`nCleanup complete!" -ForegroundColor Green
                Read-Host "Press Enter to continue"
            }
            "Q" {
                Write-Host "`nExiting... Goodbye!" -ForegroundColor Cyan
                exit 0
            }
            default {
                Write-Host "`nInvalid choice. Please try again." -ForegroundColor Red
                Start-Sleep -Seconds 1
            }
        }
    }
}

# =============================================
# MAIN
# =============================================
if ($OS -eq "Windows") {
    Show-WindowsGUI
} else {
    Show-TerminalMenu
}
