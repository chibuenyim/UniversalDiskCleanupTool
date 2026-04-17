@echo off
REM Universal Disk Cleanup Tool GUI Launcher
REM Windows launcher

setlocal

set SCRIPT_DIR=%~dp0

echo.
echo ===================================
echo 🧹 Universal Disk Cleanup Tool v4.0
echo ===================================
echo.

REM Check if PowerShell is installed
where pwsh >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ERROR: PowerShell Core (pwsh) is not installed!
    echo.
    echo Please install PowerShell 7+ from:
    echo https://github.com/PowerShell/PowerShell/releases
    echo.
    pause
    exit /b 1
)

REM Check if gui.ps1 exists
if not exist "%SCRIPT_DIR%gui.ps1" (
    echo ERROR: gui.ps1 not found in %SCRIPT_DIR%
    echo Please ensure you have the complete UniversalDiskCleanupTool.
    pause
    exit /b 1
)

REM Launch the GUI
echo Launching GUI...
echo.
cd /d "%SCRIPT_DIR%"
pwsh -ExecutionPolicy Bypass -File gui.ps1 %*

pause
