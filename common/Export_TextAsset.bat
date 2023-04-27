@echo off
color a
for %%a in (*.assets) do UnityEX.exe export "%%a" -t txt

pause