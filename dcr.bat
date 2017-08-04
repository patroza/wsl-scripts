@echo off

set cmd=%0
set cmd=%cmd:.bat=%
set cmd=%cmd:C:\tools\=%

powershell .\dcr.ps1 %*
