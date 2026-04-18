@echo off
REM ============================================
REM  Universal Disk Cleanup Tool v7.0.2
REM  For Windows - GUI Launcher with Auto-Install
REM ============================================

title Universal Disk Cleanup Tool v7.0.2

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

echo.
echo ============================================
echo    Universal Disk Cleanup Tool v7.0.2
echo ============================================
echo.
echo Script directory: %SCRIPT_DIR%
echo.

REM Check if installer script exists
if not exist "%SCRIPT_DIR%\install-pwsh.ps1" (
    echo ERROR: install-pwsh.ps1 not found!
    echo.
    echo Please make sure you extracted all files from the ZIP.
    echo.
    echo Expected location: %SCRIPT_DIR%\install-pwsh.ps1
    echo.
    pause
    exit /b 1
)

REM Check for PowerShell Core (pwsh)
where pwsh >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo PowerShell 7+ not found. Starting installer...
    echo.
    echo Running: "%SCRIPT_DIR%\install-pwsh.ps1"
    echo.
    PowerShell -ExecutionPolicy Bypass -NoProfile -File "%SCRIPT_DIR%\install-pwsh.ps1"
    echo.
    echo Installer finished. Please run START.bat again after installing PowerShell 7+.
    echo.
    pause
    exit /b 0
)

REM Check if launcher script exists
if not exist "%SCRIPT_DIR%\launcher.ps1" (
    echo ERROR: launcher.ps1 not found!
    echo.
    echo Please make sure you extracted all files from the ZIP.
    echo.
    pause
    exit /b 1
)

REM Run GUI launcher
echo Starting GUI launcher...
echo.
pwsh -ExecutionPolicy Bypass -NoProfile -File "%SCRIPT_DIR%\launcher.ps1"

if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: Failed to launch the application.
    echo Please make sure all files are extracted properly.
    echo.
    pause
)
