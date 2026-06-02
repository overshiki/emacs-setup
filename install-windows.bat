@echo off
setlocal enabledelayedexpansion

rem install-windows.bat --- Copy .emacs-windows to the correct Windows location
rem
rem Emacs on Windows looks for init files in this order:em   1. %HOME%\.emacs       (if HOME env var is set)
rem   2. %APPDATA%\.emacs    (fallback, usually C:\Users\<you>\AppData\Roaming)
rem   3. %HOME%\_emacs       (legacy)
rem
rem This script copies .emacs-windows to the detected location and
rem creates ~/.emacs.d if it does not exist.

if defined HOME (
    set TARGET_DIR=%HOME%
    echo Detected HOME: %HOME%
) else (
    set TARGET_DIR=%APPDATA%
    echo HOME not set; using APPDATA: %APPDATA%
)

set TARGET_FILE=%TARGET_DIR%\.emacs

echo.
echo Installing .emacs-windows to %TARGET_FILE% ...

if not exist ".emacs-windows" (
    echo ERROR: .emacs-windows not found in current directory.
    echo Please run this batch file from the same directory as .emacs-windows.
    exit /b 1
)

copy /Y ".emacs-windows" "%TARGET_FILE%"
if errorlevel 1 (
    echo ERROR: Failed to copy .emacs-windows to %TARGET_FILE%
    exit /b 1
)

if not exist "%TARGET_DIR%\.emacs.d" (
    mkdir "%TARGET_DIR%\.emacs.d"
    echo Created %TARGET_DIR%\.emacs.d
)

echo.
echo Installation complete.
echo Start Emacs to download and install packages from MELPA.
pause
