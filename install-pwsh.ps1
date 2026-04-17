# PowerShell 5.1+ compatible installer for PowerShell 7+
# This script can run with Windows PowerShell to install PowerShell 7+

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Test-Winget {
    try {
        $null = Get-Command winget -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

function Install-PowerShellCoreWinget {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Installing PowerShell 7+"
    $form.Size = New-Object System.Drawing.Size(450, 200)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)

    # Title
    $title = New-Object System.Windows.Forms.Label
    $title.Text = "Installing PowerShell 7+..."
    $title.Location = New-Object System.Drawing.Point(20, 20)
    $title.Size = New-Object System.Drawing.Size(400, 30)
    $title.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    $title.ForeColor = [System.Drawing.Color]::White
    $form.Controls.Add($title)

    # Message
    $message = New-Object System.Windows.Forms.Label
    $message.Text = "Please wait while we install PowerShell 7+ for you..."
    $message.Location = New-Object System.Drawing.Point(20, 60)
    $message.Size = New-Object System.Drawing.Size(400, 60)
    $message.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $message.ForeColor = [System.Drawing.Color]::FromArgb(220, 220, 220)
    $form.Controls.Add($message)

    $form.Show()
    $form.Refresh()

    try {
        # Use winget to install PowerShell
        $process = Start-Process -FilePath "winget" -ArgumentList "install", "--id", "Microsoft.PowerShell", "--accept-package-agreements", "--accept-source-agreements", "-e" -Wait -PassThru -WindowStyle Hidden

        $form.Close()

        if ($process.ExitCode -eq 0) {
            [System.Windows.Forms.MessageBox]::Show(
                "PowerShell 7+ has been installed successfully!`n`nPlease close this window and run START.bat again.",
                "Installation Complete",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Information
            )
            return $true
        } else {
            [System.Windows.Forms.MessageBox]::Show(
                "Installation failed. Please try installing manually from:`n`nhttps://github.com/PowerShell/PowerShell/releases/latest",
                "Installation Failed",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Error
            )
            return $false
        }
    } catch {
        $form.Close()
        [System.Windows.Forms.MessageBox]::Show(
            "Could not install PowerShell 7+ automatically.`n`nPlease install manually from:`n`nhttps://github.com/PowerShell/PowerShell/releases/latest",
            "Installation Failed",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
        return $false
    }
}

function Show-InstallDialog {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "PowerShell 7+ Required"
    $form.Size = New-Object System.Drawing.Size(500, 400)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)

    # Title
    $title = New-Object System.Windows.Forms.Label
    $title.Text = "PowerShell 7+ Required"
    $title.Location = New-Object System.Drawing.Point(20, 20)
    $title.Size = New-Object System.Drawing.Size(450, 30)
    $title.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
    $title.ForeColor = [System.Drawing.Color]::White
    $form.Controls.Add($title)

    # Message
    $message = New-Object System.Windows.Forms.Label
    $message.Text = "This tool requires PowerShell 7+ (pwsh) to run.`n`nWe can install it for you automatically, or you can install it manually."
    $message.Location = New-Object System.Drawing.Point(20, 70)
    $message.Size = New-Object System.Drawing.Size(450, 80)
    $message.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $message.ForeColor = [System.Drawing.Color]::FromArgb(220, 220, 220)
    $form.Controls.Add($message)

    # Auto-install button
    $autoBtn = New-Object System.Windows.Forms.Button
    $autoBtn.Text = "🚀 Install Automatically"
    $autoBtn.Location = New-Object System.Drawing.Point(20, 170)
    $autoBtn.Size = New-Object System.Drawing.Size(450, 45)
    $autoBtn.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $autoBtn.FlatStyle = "Flat"
    $autoBtn.BackColor = [System.Drawing.Color]::FromArgb(16, 185, 129)
    $autoBtn.ForeColor = [System.Drawing.Color]::White
    $autoBtn.Cursor = "Hand"
    $autoBtn.Add_Click({
        $form.Close()
        $success = Install-PowerShellCoreWinget
        if ($success) {
            exit 0
        } else {
            exit 1
        }
    })
    $form.Controls.Add($autoBtn)

    # Manual button
    $manualBtn = New-Object System.Windows.Forms.Button
    $manualBtn.Text = "📥 Download Manually"
    $manualBtn.Location = New-Object System.Drawing.Point(20, 230)
    $manualBtn.Size = New-Object System.Drawing.Size(215, 45)
    $manualBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $manualBtn.FlatStyle = "Flat"
    $manualBtn.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
    $manualBtn.ForeColor = [System.Drawing.Color]::White
    $manualBtn.Cursor = "Hand"
    $manualBtn.Add_Click({
        Start-Process "https://github.com/PowerShell/PowerShell/releases/latest"
        $form.Close()
    })
    $form.Controls.Add($manualBtn)

    # Cancel button
    $cancelBtn = New-Object System.Windows.Forms.Button
    $cancelBtn.Text = "Cancel"
    $cancelBtn.Location = New-Object System.Drawing.Point(255, 230)
    $cancelBtn.Size = New-Object System.Drawing.Size(215, 45)
    $cancelBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $cancelBtn.FlatStyle = "Flat"
    $cancelBtn.BackColor = [System.Drawing.Color]::FromArgb(100, 100, 100)
    $cancelBtn.ForeColor = [System.Drawing.Color]::White
    $cancelBtn.Cursor = "Hand"
    $cancelBtn.Add_Click({
        $form.Close()
    })
    $form.Controls.Add($cancelBtn)

    # Info
    $info = New-Object System.Windows.Forms.Label
    $info.Text = "Automatic installation requires Windows Package Manager (winget)."
    $info.Location = New-Object System.Drawing.Point(20, 290)
    $info.Size = New-Object System.Drawing.Size(450, 40)
    $info.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $info.ForeColor = [System.Drawing.Color]::FromArgb(150, 150, 150)
    $form.Controls.Add($info)

    $form.ShowDialog() | Out-Null
    $form.Dispose()
}

# Main
if (Test-Winget) {
    Show-InstallDialog
} else {
    # No winget available, show manual download dialog
    $result = [System.Windows.Forms.MessageBox]::Show(
        "PowerShell 7+ is required but not installed.`n`nWould you like to download it now?",
        "PowerShell 7+ Required",
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Question
    )

    if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
        Start-Process "https://github.com/PowerShell/PowerShell/releases/latest"
    }
}
