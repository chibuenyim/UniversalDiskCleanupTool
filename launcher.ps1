#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Universal Disk Cleanup Tool v5.0 - GUI Launcher
.DESCRIPTION
    Beautiful GUI launcher with dependency checking
#>

#Requires -PSEdition Core
#Requires -Version 7

# Check if running on Windows
if (-not $IsWindows) {
    Write-Host "GUI launcher is only available on Windows." -ForegroundColor Yellow
    Write-Host "Please use: ./start.sh" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}

# Add Windows Forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# =============================================
# FUNCTIONS
# =============================================

function Test-PowerShellCore {
    try {
        $null = Get-Command pwsh -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

function Show-DependencyDialog {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "PowerShell Core Not Found"
    $form.Size = New-Object System.Drawing.Size(500, 350)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)

    # Title
    $title = New-Object System.Windows.Forms.Label
    $title.Text = "PowerShell Core Required"
    $title.Location = New-Object System.Drawing.Point(20, 20)
    $title.Size = New-Object System.Drawing.Size(450, 30)
    $title.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
    $title.ForeColor = [System.Drawing.Color]::White
    $form.Controls.Add($title)

    # Message
    $message = New-Object System.Windows.Forms.Label
    $message.Text = "This tool requires PowerShell 7+ (pwsh) to run.`n`nWindows PowerShell (the default) is not supported."
    $message.Location = New-Object System.Drawing.Point(20, 70)
    $message.Size = New-Object System.Drawing.Size(450, 60)
    $message.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $message.ForeColor = [System.Drawing.Color]::FromArgb(220, 220, 220)
    $form.Controls.Add($message)

    # Download button
    $downloadBtn = New-Object System.Windows.Forms.Button
    $downloadBtn.Text = "Download PowerShell 7+"
    $downloadBtn.Location = New-Object System.Drawing.Point(20, 150)
    $downloadBtn.Size = New-Object System.Drawing.Size(200, 40)
    $downloadBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $downloadBtn.FlatStyle = "Flat"
    $downloadBtn.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
    $downloadBtn.ForeColor = [System.Drawing.Color]::White
    $downloadBtn.Cursor = "Hand"
    $downloadBtn.Add_Click({
        Start-Process "https://github.com/PowerShell/PowerShell/releases/latest"
    })
    $form.Controls.Add($downloadBtn)

    # Close button
    $closeBtn = New-Object System.Windows.Forms.Button
    $closeBtn.Text = "Close"
    $closeBtn.Location = New-Object System.Drawing.Point(240, 150)
    $closeBtn.Size = New-Object System.Drawing.Size(200, 40)
    $closeBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $closeBtn.FlatStyle = "Flat"
    $closeBtn.BackColor = [System.Drawing.Color]::FromArgb(100, 100, 100)
    $closeBtn.ForeColor = [System.Drawing.Color]::White
    $closeBtn.Cursor = "Hand"
    $closeBtn.Add_Click({
        $form.Close()
    })
    $form.Controls.Add($closeBtn)

    # Info
    $info = New-Object System.Windows.Forms.Label
    $info.Text = "After installing, restart this application."
    $info.Location = New-Object System.Drawing.Point(20, 210)
    $info.Size = New-Object System.Drawing.Size(450, 30)
    $info.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $info.ForeColor = [System.Drawing.Color]::FromArgb(180, 180, 180)
    $form.Controls.Add($info)

    $form.ShowDialog() | Out-Null
    $form.Dispose()
}

function Show-MainForm {
    # Create main form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Universal Disk Cleanup Tool v5.0"
    $form.Size = New-Object System.Drawing.Size(600, 500)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)

    # Title
    $title = New-Object System.Windows.Forms.Label
    $title.Text = "🧹 Universal Disk Cleanup Tool"
    $title.Location = New-Object System.Drawing.Point(20, 20)
    $title.Size = New-Object System.Drawing.Size(560, 40)
    $title.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
    $title.ForeColor = [System.Drawing.Color]::White
    $form.Controls.Add($title)

    # Subtitle
    $subtitle = New-Object System.Windows.Forms.Label
    $subtitle.Text = "Free up to 45 GB of disk space safely"
    $subtitle.Location = New-Object System.Drawing.Point(20, 65)
    $subtitle.Size = New-Object System.Drawing.Size(560, 25)
    $subtitle.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $subtitle.ForeColor = [System.Drawing.Color]::FromArgb(180, 180, 180)
    $form.Controls.Add($subtitle)

    # Cleanup options
    $yPos = 110

    $options = @(
        @{Name = "Quick Cleanup"; Desc = "Clean everything (recommended)"; All = $true},
        @{Name = "Temporary Files"; Desc = "System temp files and caches"; Temp = $true},
        @{Name = "Browser Caches"; Desc = "Chrome, Firefox, Edge, Safari"; Browser = $true},
        @{Name = "Developer Tools"; Desc = "npm, pip, cargo, maven, etc."; Dev = $true},
        @{Name = "System Files"; Desc = "Logs, thumbnails, recycle bin"; System = $true}
    )

    $radioButtons = @()

    foreach ($opt in $options) {
        $radio = New-Object System.Windows.Forms.RadioButton
        $radio.Location = New-Object System.Drawing.Point(20, $yPos)
        $radio.Size = New-Object System.Drawing.Size(400, 25)
        $radio.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
        $radio.ForeColor = [System.Drawing.Color]::White
        $radio.Text = $opt.Name
        $radio.BackColor = [System.Drawing.Color]::Transparent

        # Store the option data
        $radio.Tag = $opt

        if ($opt.All) {
            $radio.Checked = $true
        }

        $form.Controls.Add($radio)
        $radioButtons += $radio

        # Description
        $desc = New-Object System.Windows.Forms.Label
        $desc.Location = New-Object System.Drawing.Point(40, $yPos + 22)
        $desc.Size = New-Object System.Drawing.Size(520, 20)
        $desc.Font = New-Object System.Drawing.Font("Segoe UI", 9)
        $desc.ForeColor = [System.Drawing.Color]::FromArgb(150, 150, 150)
        $desc.Text = $opt.Desc
        $form.Controls.Add($desc)

        $yPos += 50
    }

    # Start button
    $startBtn = New-Object System.Windows.Forms.Button
    $startBtn.Text = "▶ Start Cleanup"
    $startBtn.Location = New-Object System.Drawing.Point(20, 380)
    $startBtn.Size = New-Object System.Drawing.Size(260, 50)
    $startBtn.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $startBtn.FlatStyle = "Flat"
    $startBtn.BackColor = [System.Drawing.Color]::FromArgb(16, 185, 129)
    $startBtn.ForeColor = [System.Drawing.Color]::White
    $startBtn.Cursor = "Hand"
    $startBtn.Add_Click({
        $selected = $radioButtons | Where-Object { $_.Checked } | Select-Object -First 1

        if ($selected) {
            $opt = $selected.Tag

            # Build arguments
            $args = @()
            if ($opt.All) { $args += "--All" }
            elseif ($opt.Temp) { $args += "--Temp" }
            elseif ($opt.Browser) { $args += "--Browser" }
            elseif ($opt.Dev) { $args += "--Dev" }
            elseif ($opt.System) { $args += "--System" }

            # Close form
            $form.Close()

            # Run cleanup
            Write-Host "Starting cleanup..." -ForegroundColor Green
            & pwsh -ExecutionPolicy Bypass -File "$PSScriptRoot/cleanup.ps1" @args

            Write-Host ""
            Write-Host "Cleanup complete!" -ForegroundColor Green
            Read-Host "Press Enter to exit"
        }
    })
    $form.Controls.Add($startBtn)

    # Cancel button
    $cancelBtn = New-Object System.Windows.Forms.Button
    $cancelBtn.Text = "Cancel"
    $cancelBtn.Location = New-Object System.Drawing.Point(300, 380)
    $cancelBtn.Size = New-Object System.Drawing.Size(240, 50)
    $cancelBtn.Font = New-Object System.Drawing.Font("Segoe UI", 11)
    $cancelBtn.FlatStyle = "Flat"
    $cancelBtn.BackColor = [System.Drawing.Color]::FromArgb(100, 100, 100)
    $cancelBtn.ForeColor = [System.Drawing.Color]::White
    $cancelBtn.Cursor = "Hand"
    $cancelBtn.Add_Click({
        $form.Close()
    })
    $form.Controls.Add($cancelBtn)

    # Status bar
    $status = New-Object System.Windows.Forms.Label
    $status.Text = "✓ Ready to clean"
    $status.Location = New-Object System.Drawing.Point(20, 440)
    $status.Size = New-Object System.Drawing.Size(560, 20)
    $status.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $status.ForeColor = [System.Drawing.Color]::FromArgb(140, 140, 140)
    $form.Controls.Add($status)

    # Show form
    $form.ShowDialog() | Out-Null
    $form.Dispose()
}

# =============================================
# MAIN
# =============================================

# Check for PowerShell Core
if (-not (Test-PowerShellCore)) {
    Show-DependencyDialog
    exit 1
}

# Show main form
Show-MainForm
