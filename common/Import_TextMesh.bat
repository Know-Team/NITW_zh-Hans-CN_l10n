@echo off
color a
for %%a in (*.assets) do UnityEX.exe import "%%a" -t -35,102
pause