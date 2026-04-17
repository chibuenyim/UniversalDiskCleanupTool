@echo off
REM ============================================
REM  Universal Disk Cleanup Tool v5.1
REM  For Windows - GUI Launcher with Auto-Install
REM ============================================

title Universal Disk Cleanup Tool v5.1

echo.
echo ============================================
echo    Universal Disk Cleanup Tool v5.1
echo ============================================
echo.

REM Check for PowerShell Core (pwsh)
where pwsh >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo PowerShell 7+ not found. Starting installer...
    echo.
    PowerShell -ExecutionPolicy Bypass -NoProfile -File "%~dp0install-pwsh.ps1"
    echo.
    echo Installer finished. Please run START.bat again after installing PowerShell 7+.
    echo.
    pause
    exit /b 0
)

REM Run GUI launcher
echo Starting GUI launcher...
echo.
pwsh -ExecutionPolicy Bypass -NoProfile -File "%~dp0launcher.ps1"

if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: Failed to launch the application.
    echo Please make sure all files are extracted properly.
    echo.
    pause
)
