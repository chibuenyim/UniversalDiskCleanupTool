@echo off
REM ============================================
REM  Universal Disk Cleanup Tool v5.0
REM  For Windows - GUI Launcher
REM ============================================

title Universal Disk Cleanup Tool v5.0

REM Check for PowerShell Core
where pwsh >nul 2>nul
if %ERRORLEVEL% neq 0 (
    REM PowerShell Core not found, run launcher anyway
    REM The launcher will show a helpful download dialog
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
