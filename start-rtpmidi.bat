@echo off
:: Start rtpMIDI and restart Windows MIDI Service so virtual ports are visible
:: (Workaround for Windows 11 MIDI Services bug with dynamic ports)
:: Must be run as Administrator

echo Starting loopMIDI...
start "" "C:\Program Files (x86)\Tobias Erichsen\loopMIDI\loopMIDI.exe"

echo Starting rtpMIDI...
start "" "C:\Program Files (x86)\Tobias Erichsen\rtpMIDI\rtpMIDI.exe"

echo Waiting for virtual ports to be created...
timeout /t 5 /nobreak >nul

echo Restarting Windows MIDI Service...
net stop midisrv /y
timeout /t 2 /nobreak >nul
net start midisrv

echo Restarting rtpMIDI Service...
net stop rtpMIDIService /y
timeout /t 2 /nobreak >nul
net start rtpMIDIService

echo.
echo Done! ALPHABEAR and loopMIDI ports should now be visible.
echo You can close this window.
pause
