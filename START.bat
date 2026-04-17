@echo off
REM ============================================
REM  Universal Disk Cleanup Tool v5.0
REM  For Windows - GUI Launcher with Auto-Install
REM ============================================

title Universal Disk Cleanup Tool v5.0

REM Check for PowerShell Core (pwsh)
where pwsh >nul 2>nul
if %ERRORLEVEL% neq 0 (
    REM PowerShell Core not found - run installer
    PowerShell -ExecutionPolicy Bypass -NoProfile -File "%~dp0install-pwsh.ps1"
    exit /b %ERRORLEVEL%
)

REM Run GUI launcher
pwsh -ExecutionPolicy Bypass -NoProfile -File "%~dp0launcher.ps1"

if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: Failed to launch the application.
    echo Please make sure all files are extracted properly.
    echo.
    pause
)
