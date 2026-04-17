#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Universal Disk Cleanup Tool v5.2 - GUI Launcher
.DESCRIPTION
    Beautiful GUI launcher with space estimation and multiple selection
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

function Get-SpaceEstimation {
    param($Selections)

    $totalMB = 0

    foreach ($sel in $Selections) {
        switch ($sel) {
            "Temp" { $totalMB += 1500 }
            "Browser" { $totalMB += 1150 }
            "Dev" { $totalMB += 16500 }
            "System" { $totalMB += 5000 }
            "All" { $totalMB += 25000 }
        }
    }

    return $totalMB
}

function Format-Bytes {
    param($bytes)

    if ($bytes -ge 1GB) {
        return "{0:N2} GB" - ($bytes / 1GB)
    } elseif ($bytes -ge 1MB) {
        return "{0:N2} MB" - ($bytes / 1MB)
    } else {
        return "{0:N2} KB" - ($bytes / 1KB)
    }
}

function Show-PreviewDialog {
    param($Selections, $EstimatedSpace)

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Cleanup Preview"
    $form.Size = New-Object System.Drawing.Size(500, 400)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)

    # Title
    $title = New-Object System.Windows.Forms.Label
    $title.Text = "Cleanup Preview"
    $title.Location = New-Object System.Drawing.Point(20, 20)
    $title.Size = New-Object System.Drawing.Size(450, 30)
    $title.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
    $title.ForeColor = [System.Drawing.Color]::White
    $form.Controls.Add($title)

    # Items to clean
    $y = 70
    foreach ($sel in $Selections) {
        $item = New-Object System.Windows.Forms.Label
        $item.Text = "  - $sel"
        $item.Location = New-Object System.Drawing.Point(40, $y)
        $item.Size = New-Object System.Drawing.Size(400, 20)
        $item.Font = New-Object System.Drawing.Font("Segoe UI", 10)
        $item.ForeColor = [System.Drawing.Color]::FromArgb(220, 220, 220)
        $form.Controls.Add($item)
        $y += 25
    }

    # Estimated space
    $spaceLabel = New-Object System.Windows.Forms.Label
    $spaceLabel.Text = "Estimated space to be freed: $(Format-Bytes ($EstimatedSpace * 1MB))"
    $spaceLabel.Location = New-Object System.Drawing.Point(20, $y + 10)
    $spaceLabel.Size = New-Object System.Drawing.Size(450, 30)
    $spaceLabel.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $spaceLabel.ForeColor = [System.Drawing.Color]::FromArgb(16, 185, 129)
    $form.Controls.Add($spaceLabel)

    # Confirm button
    $confirmBtn = New-Object System.Windows.Forms.Button
    $confirmBtn.Text = "Confirm & Cleanup"
    $confirmBtn.Location = New-Object System.Drawing.Point(20, 300)
    $confirmBtn.Size = New-Object System.Drawing.Size(210, 45)
    $confirmBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $confirmBtn.FlatStyle = "Flat"
    $confirmBtn.BackColor = [System.Drawing.Color]::FromArgb(16, 185, 129)
    $confirmBtn.ForeColor = [System.Drawing.Color]::White
    $confirmBtn.Cursor = "Hand"
    $confirmBtn.Add_Click({
        $form.Tag = "Confirm"
        $form.Close()
    })
    $form.Controls.Add($confirmBtn)

    # Cancel button
    $cancelBtn = New-Object System.Windows.Forms.Button
    $cancelBtn.Text = "Cancel"
    $cancelBtn.Location = New-Object System.Drawing.Point(250, 300)
    $cancelBtn.Size = New-Object System.Drawing.Size(210, 45)
    $cancelBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $cancelBtn.FlatStyle = "Flat"
    $cancelBtn.BackColor = [System.Drawing.Color]::FromArgb(100, 100, 100)
    $cancelBtn.ForeColor = [System.Drawing.Color]::White
    $cancelBtn.Cursor = "Hand"
    $cancelBtn.Add_Click({
        $form.Tag = "Cancel"
        $form.Close()
    })
    $form.Controls.Add($cancelBtn)

    $form.Tag = ""
    $form.ShowDialog() | Out-Null

    return $form.Tag -eq "Confirm"
}

function Show-CompletionDialog {
    param($SpaceFreed)

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Cleanup Complete"
    $form.Size = New-Object System.Drawing.Size(450, 300)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)

    # Success icon
    $icon = New-Object System.Windows.Forms.Label
    $icon.Text = "[OK]"
    $icon.Location = New-Object System.Drawing.Point(180, 30)
    $icon.Size = New-Object System.Drawing.Size(80, 50)
    $icon.Font = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Bold)
    $icon.ForeColor = [System.Drawing.Color]::FromArgb(16, 185, 129)
    $icon.TextAlign = "MiddleCenter"
    $form.Controls.Add($icon)

    # Title
    $title = New-Object System.Windows.Forms.Label
    $title.Text = "Cleanup Complete!"
    $title.Location = New-Object System.Drawing.Point(20, 100)
    $title.Size = New-Object System.Drawing.Size(400, 30)
    $title.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
    $title.ForeColor = [System.Drawing.Color]::White
    $title.TextAlign = "MiddleCenter"
    $form.Controls.Add($title)

    # Space freed
    $spaceLabel = New-Object System.Windows.Forms.Label
    $spaceLabel.Text = "Space freed: $(Format-Bytes $SpaceFreed)"
    $spaceLabel.Location = New-Object System.Drawing.Point(20, 140)
    $spaceLabel.Size = New-Object System.Drawing.Size(400, 30)
    $spaceLabel.Font = New-Object System.Drawing.Font("Segoe UI", 12)
    $spaceLabel.ForeColor = [System.Drawing.Color]::FromArgb(16, 185, 129)
    $spaceLabel.TextAlign = "MiddleCenter"
    $form.Controls.Add($spaceLabel)

    # OK button
    $okBtn = New-Object System.Windows.Forms.Button
    $okBtn.Text = "OK"
    $okBtn.Location = New-Object System.Drawing.Point(125, 200)
    $okBtn.Size = New-Object System.Drawing.Size(200, 40)
    $okBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $okBtn.FlatStyle = "Flat"
    $okBtn.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
    $okBtn.ForeColor = [System.Drawing.Color]::White
    $okBtn.Cursor = "Hand"
    $okBtn.Add_Click({
        $form.Close()
    })
    $form.Controls.Add($okBtn)

    $form.ShowDialog() | Out-Null
    $form.Dispose()
}

function Show-MainForm {
    # Create main form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Universal Disk Cleanup Tool v5.2"
    $form.Size = New-Object System.Drawing.Size(550, 520)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)

    # Title
    $title = New-Object System.Windows.Forms.Label
    $title.Text = "Universal Disk Cleanup Tool"
    $title.Location = New-Object System.Drawing.Point(20, 20)
    $title.Size = New-Object System.Drawing.Size(500, 30)
    $title.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
    $title.ForeColor = [System.Drawing.Color]::White
    $form.Controls.Add($title)

    # Subtitle
    $subtitle = New-Object System.Windows.Forms.Label
    $subtitle.Text = "Select items to clean (multiple selection allowed)"
    $subtitle.Location = New-Object System.Drawing.Point(20, 55)
    $subtitle.Size = New-Object System.Drawing.Size(500, 20)
    $subtitle.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $subtitle.ForeColor = [System.Drawing.Color]::FromArgb(180, 180, 180)
    $form.Controls.Add($subtitle)

    # Cleanup options (Checkboxes for multiple selection)
    $yPos = 90

    $options = @(
        @{Name = "Quick Cleanup"; Desc = "Clean everything"; Key = "All"},
        @{Name = "Temporary Files"; Desc = "500 MB - 3 GB"; Key = "Temp"},
        @{Name = "Browser Caches"; Desc = "300 MB - 2 GB"; Key = "Browser"},
        @{Name = "Developer Tools"; Desc = "8 - 25 GB"; Key = "Dev"},
        @{Name = "System Files"; Desc = "2 - 8 GB"; Key = "System"}
    )

    $checkBoxes = @()

    foreach ($opt in $options) {
        $cb = New-Object System.Windows.Forms.CheckBox
        $cb.Location = New-Object System.Drawing.Point(20, $yPos)
        $cb.Size = New-Object System.Drawing.Size(480, 24)
        $cb.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
        $cb.ForeColor = [System.Drawing.Color]::White
        $cb.Text = "$($opt.Name) - $($opt.Desc)"
        $cb.BackColor = [System.Drawing.Color]::Transparent
        $cb.Tag = $opt.Key

        if ($opt.Key -eq "All") {
            $cb.Checked = $true
        }

        $form.Controls.Add($cb)
        $checkBoxes += $cb

        $yPos += 30
    }

    # Select All button
    $selectAllBtn = New-Object System.Windows.Forms.Button
    $selectAllBtn.Text = "Select All"
    $selectAllBtn.Location = New-Object System.Drawing.Point(20, 250)
    $selectAllBtn.Size = New-Object System.Drawing.Size(120, 35)
    $selectAllBtn.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $selectAllBtn.FlatStyle = "Flat"
    $selectAllBtn.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
    $selectAllBtn.ForeColor = [System.Drawing.Color]::White
    $selectAllBtn.Cursor = "Hand"
    $selectAllBtn.Add_Click({
        foreach ($cb in $checkBoxes) {
            $cb.Checked = $true
        }
    })
    $form.Controls.Add($selectAllBtn)

    # Clear All button
    $clearAllBtn = New-Object System.Windows.Forms.Button
    $clearAllBtn.Text = "Clear All"
    $clearAllBtn.Location = New-Object System.Drawing.Point(150, 250)
    $clearAllBtn.Size = New-Object System.Drawing.Size(120, 35)
    $clearAllBtn.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $clearAllBtn.FlatStyle = "Flat"
    $clearAllBtn.BackColor = [System.Drawing.Color]::FromArgb(100, 100, 100)
    $clearAllBtn.ForeColor = [System.Drawing.Color]::White
    $clearAllBtn.Cursor = "Hand"
    $clearAllBtn.Add_Click({
        foreach ($cb in $checkBoxes) {
            $cb.Checked = $false
        }
    })
    $form.Controls.Add($clearAllBtn)

    # Preview button
    $previewBtn = New-Object System.Windows.Forms.Button
    $previewBtn.Text = "Preview & Cleanup"
    $previewBtn.Location = New-Object System.Drawing.Point(20, 300)
    $previewBtn.Size = New-Object System.Drawing.Size(480, 50)
    $previewBtn.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $previewBtn.FlatStyle = "Flat"
    $previewBtn.BackColor = [System.Drawing.Color]::FromArgb(16, 185, 129)
    $previewBtn.ForeColor = [System.Drawing.Color]::White
    $previewBtn.Cursor = "Hand"
    $previewBtn.Add_Click({
        # Get selected options
        $selected = $checkBoxes | Where-Object { $_.Checked } | ForEach-Object { $_.Tag }

        if ($selected.Count -eq 0) {
            [System.Windows.Forms.MessageBox]::Show(
                "Please select at least one option.",
                "No Selection",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Warning
            )
            return
        }

        # If "All" is selected, don't include individual options
        if ($selected -contains "All") {
            $selected = @("All")
        }

        # Get space estimation
        $estimatedMB = Get-SpaceEstimation -Selections $selected

        # Show preview dialog
        $confirmed = Show-PreviewDialog -Selections $selected -EstimatedSpace $estimatedMB

        if ($confirmed) {
            # Close main form
            $form.Close()

            # Build arguments
            $argsList = @()
            foreach ($sel in $selected) {
                $argsList += "--$sel"
            }

            # Run cleanup and capture output
            Write-Host "Starting cleanup..." -ForegroundColor Green
            Write-Host ""

            $output = & pwsh -ExecutionPolicy Bypass -File "$PSScriptRoot/cleanup.ps1" @argsList 2>&1

            # Try to parse space freed from output
            $spaceFreed = 0
            foreach ($line in $output) {
                if ($line -match "(\d+(?:\.\d+)?)\s*(GB|MB|KB)\s+freed") {
                    $value = [double]$Matches[1]
                    $unit = $Matches[2]

                    switch ($unit) {
                        "GB" { $spaceFreed = $value * 1GB }
                        "MB" { $spaceFreed = $value * 1MB }
                        "KB" { $spaceFreed = $value * 1KB }
                    }
                    break
                }
            }

            # If we couldn't parse it, use estimation
            if ($spaceFreed -eq 0) {
                $spaceFreed = $estimatedMB * 1MB
            }

            Write-Host ""
            Write-Host "Cleanup complete!" -ForegroundColor Green
            Write-Host "Space freed: $(Format-Bytes $spaceFreed)" -ForegroundColor Cyan

            # Show completion dialog
            Show-CompletionDialog -SpaceFreed $spaceFreed
        }
    })
    $form.Controls.Add($previewBtn)

    # Cancel button
    $cancelBtn = New-Object System.Windows.Forms.Button
    $cancelBtn.Text = "Cancel"
    $cancelBtn.Location = New-Object System.Drawing.Point(20, 370)
    $cancelBtn.Size = New-Object System.Drawing.Size(480, 40)
    $cancelBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10)
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
    $status.Text = "[OK] Ready to clean"
    $status.Location = New-Object System.Drawing.Point(20, 430)
    $status.Size = New-Object System.Drawing.Size(500, 20)
    $status.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $status.ForeColor = [System.Drawing.Color]::FromArgb(140, 140, 140)
    $form.Controls.Add($status)

    # Show form
    $form.ShowDialog() | Out-Null
    $form.Dispose()
}

# Show main form
Show-MainForm
