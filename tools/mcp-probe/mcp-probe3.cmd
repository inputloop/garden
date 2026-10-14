@echo off
setlocal
rem mcp-probe3 -- which vibrobeast build is INSTALLED on this desktop, and is it the one on the shelf?
rem Double-click. Writes mcp-probe3.out.txt beside itself; prints nothing. Read-only except that file.
set OUT=%~dp0mcp-probe3.out.txt
set TREE=F:\claude\AS4CE\AS4CE0001
set SHELF=%TREE%\dist\vibrobeast
set PYTHONDONTWRITEBYTECODE=1
set FOUND=0
echo == mcp-probe3 %DATE% %TIME% > "%OUT%"
echo == shelf MANIFEST sha256 (%SHELF%) >> "%OUT%"
if exist "%SHELF%\MANIFEST" (certutil -hashfile "%SHELF%\MANIFEST" SHA256 | findstr /v /i "hash" >> "%OUT%") else (echo absent %SHELF%\MANIFEST >> "%OUT%")
echo == installed plugin trees: any dir holding MANIFEST + .claude-plugin\plugin.json under the app roots >> "%OUT%"
for %%R in ("%APPDATA%\Claude" "%LOCALAPPDATA%\Claude" "%LOCALAPPDATA%\AnthropicClaude") do call :scan "%%~R"
for /d %%P in ("%LOCALAPPDATA%\Packages\*laude*" "%LOCALAPPDATA%\Packages\*nthropic*") do call :scan "%%~P"
if "%FOUND%"=="0" echo none found under the candidate roots -- the desktop keeps the plugin somewhere probe2 did not list >> "%OUT%"
echo == newest desktop log, last 40 lines naming mentcached >> "%OUT%"
for /f "delims=" %%L in ('dir /b /o-d "%LOCALAPPDATA%\Claude\Logs\main*.log" 2^>nul') do (
  echo -- %LOCALAPPDATA%\Claude\Logs\%%L >> "%OUT%"
  findstr /i /c:"mentcached" "%LOCALAPPDATA%\Claude\Logs\%%L" > "%TEMP%\mcp-probe3.tmp"
  powershell -NoProfile -Command "Get-Content -Tail 40 '%TEMP%\mcp-probe3.tmp'" >> "%OUT%" 2>&1
  del "%TEMP%\mcp-probe3.tmp" 2>nul
  goto :logdone
)
:logdone
echo == done >> "%OUT%"
goto :eof

:scan
if not exist "%~1" goto :eof
for /f "delims=" %%M in ('dir /s /b "%~1\MANIFEST" 2^>nul') do call :one "%%~dpM"
goto :eof

:one
set D=%~1
if "%D:~-1%"=="\" set D=%D:~0,-1%
if not exist "%D%\.claude-plugin\plugin.json" goto :eof
set FOUND=1
echo -- %D% >> "%OUT%"
echo    MANIFEST sha256: >> "%OUT%"
certutil -hashfile "%D%\MANIFEST" SHA256 | findstr /v /i "hash" >> "%OUT%"
if exist "%D%\servers\polygram\mcp\prefs.py" (echo    prefs.py: present  ^(the pref_list / soft_skill_read build^) >> "%OUT%") else (echo    prefs.py: ABSENT  ^(older build: no pref_list, no soft_skill_read, no checks on seat_mode^) >> "%OUT%")
if exist "%D%\servers\polygram\mcp\spans.py" (echo    spans.py: present >> "%OUT%") else (echo    spans.py: ABSENT >> "%OUT%")
echo    freshness ^(python3 -m polygram.mcp.freshness --shelf SHELF --installed THIS^): >> "%OUT%"
pushd "%TREE%"
python3 -m polygram.mcp.freshness --shelf "%SHELF%" --installed "%D%" >> "%OUT%" 2>&1
echo    exit %ERRORLEVEL%  ^(0 CURRENT, 1 BEHIND, 2 UNKNOWN^) >> "%OUT%"
popd
goto :eof
