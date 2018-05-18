@echo off
@title Devil-Backdoor Builder x86
color 0f

echo Devil-Backdoor Builder x86
echo Aut2Exe Version: 3.3.14.5
echo ______________________________
echo.

echo Building started!
mkdir final_x86
copy ..\config.ini final_x86
echo.

echo Devil-ControlPanel.au3 building...
start Aut2Exe\Aut2exe.exe /in "..\Devil-ControlPanel.au3" /out "final_x86\Devil-ControlPanel.exe" /icon "icon.ico" /x86
echo.

echo Devil-Server.au3 building...
start Aut2Exe\Aut2exe.exe /in "..\Devil-Server.au3" /out "final_x86\Devil-Server.exe" /pack /x86
echo.

echo Finished! See final_x86 folder!
echo. 

pause