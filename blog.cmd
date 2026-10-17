@echo off
rem Thin wrapper: keeps PowerShell execution policy out of the way.
chcp 65001 >nul
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0blog.ps1" %*
endlocal
