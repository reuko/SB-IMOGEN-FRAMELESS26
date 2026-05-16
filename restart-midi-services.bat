@echo off
:: Restart Windows MIDI Services to pick up virtual ports
:: (Workaround for Windows 11 MIDI Services bug)
:: Must be run as Administrator

echo Restarting Windows MIDI Service...
net stop midisrv /y
timeout /t 2 /nobreak >nul
net start midisrv

echo Restarting rtpMIDI Service...
net stop rtpMIDIService /y
timeout /t 2 /nobreak >nul
net start rtpMIDIService

echo.
echo Done! Virtual MIDI ports should now be visible.
pause
