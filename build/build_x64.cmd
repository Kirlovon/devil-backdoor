@echo off
@title Devil-Backdoor Builder x64
color 0f

echo Devil-Backdoor Builder x64
echo Aut2Exe Version: 3.3.14.5
echo ______________________________
echo.

echo Building started!
mkdir builded_x64
copy ..\config.ini builded_x64
echo.

echo Devil-ControlPanel.au3 building...
start Aut2Exe\Aut2exe.exe /in "..\Devil-ControlPanel.au3" /out "builded_x64\Devil-ControlPanel.exe" /icon "icon.ico" /x64
echo.

echo Devil-Server.au3 building...
start Aut2Exe\Aut2exe.exe /in "..\Devil-Server.au3" /out "builded_x64\Devil-Server.exe" /pack /x64
echo.

echo Finished! See builded_x64 folder!
echo ______________________________
echo.

pause