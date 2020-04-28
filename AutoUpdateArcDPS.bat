@echo off
set Path=%~dp0
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe  -ExecutionPolicy ByPass -command "& '%Path%AutoUpdateArcDPS.ps1'"