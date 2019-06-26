@echo off
title EFT Soft Reset Utility
set /p tmp=Checking for pssuspend.exe...<NUL
if NOT EXIST pssuspend.exe (
	echo pssuspend.exe not found!
	exit
)
if EXIST pssuspend.exe (
	echo pssuspend OK!
)
set /p tmp=Checking for administrator rights...<NUL
net session >nul 2>&1
if %errorlevel%==0 (
	echo Admin rights confirmed.
	goto suspend
) else (
	echo Utility not run with administrator rights, relaunching as administrator...
	goto elevateSelf
)
:elevateSelf
echo Set objShell = CreateObject("Shell.Application") >elevatedapp.vbs
echo Set objWshShell = WScript.CreateObject("WScript.Shell") >>elevatedapp.vbs
echo Set objWshProcessEnv = objWshShell.Environment("PROCESS") >>elevatedapp.vbs
echo objShell.ShellExecute "EFTReset.bat", "", "", "runas" >>elevatedapp.vbs
start "" /WAIT /MIN elevatedapp.vbs
timeout /t 1 /nobreak > nul
DEL elevatedapp.vbs
exit
:suspend
set /p tmp=Suspending Escape from Tarkov...<NUL
pssuspend.exe -accepteula -nobanner EscapeFromTarkov.exe
timeout /t 10 /NOBREAK>NUL
set /p tmp=Resuming Escape from Tarkov<NUL
pssuspend.exe -accepteula -nobanner -r EscapeFromTarkov.exe
echo Done.
pause
exit