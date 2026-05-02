@echo off
title Youth Forum – Local Server
echo.
echo  OM Shri Radhe!  Youth Forum Attendance System
echo  Starting local web server on http://localhost:8080
echo.
echo  Open your browser at: http://localhost:8080
echo  Press Ctrl+C to stop.
echo.
cd /d "%~dp0"
python -m http.server 8080
pause
