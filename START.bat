@echo off
REM ============================================
REM  Universal Disk Cleanup Tool v5.0
REM  For Windows
REM ============================================

title Universal Disk Cleanup Tool v5.0

echo.
echo ============================================
echo    Universal Disk Cleanup Tool v5.0
echo    Starting...
echo ============================================
echo.

REM Check for PowerShell
where pwsh >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo PowerShell Core not found.
    echo Please install PowerShell 7+ from:
    echo https://github.com/PowerShell/PowerShell/releases
    pause
    exit /b 1
)

REM Run cleanup
pwsh -ExecutionPolicy Bypass -File cleanup.ps1 --All

echo.
echo Cleanup complete!
pause
