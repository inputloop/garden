@echo off
setlocal
set OUT=%~dp0mcp-probe2.out.txt
echo == mcp-probe2 %DATE% %TIME% > "%OUT%"
echo == where the app runs from >> "%OUT%"
powershell -NoProfile -Command "Get-Process claude -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -Unique" >> "%OUT%" 2>&1
echo == candidate roots >> "%OUT%"
for %%R in ("%APPDATA%\Claude" "%LOCALAPPDATA%\Claude" "%LOCALAPPDATA%\AnthropicClaude" "%LOCALAPPDATA%\Programs\Claude") do (
  if exist "%%~R" (echo EXISTS %%~R >> "%OUT%") else (echo absent %%~R >> "%OUT%")
)
for /d %%P in ("%LOCALAPPDATA%\Packages\*laude*" "%LOCALAPPDATA%\Packages\*nthropic*") do echo PACKAGE %%~P >> "%OUT%"
echo == scanning >> "%OUT%"
for %%R in ("%APPDATA%\Claude" "%LOCALAPPDATA%\Claude" "%LOCALAPPDATA%\AnthropicClaude") do call :scan "%%~R"
for /d %%P in ("%LOCALAPPDATA%\Packages\*laude*" "%LOCALAPPDATA%\Packages\*nthropic*") do call :scan "%%~P"
echo == done >> "%OUT%"
goto :eof

:scan
if not exist "%~1" goto :eof
echo -- root %~1 >> "%OUT%"
dir /b "%~1" >> "%OUT%" 2>&1
echo -- dirs named for the plugin, its servers, or plugins in general >> "%OUT%"
dir /s /b /ad "%~1" 2>nul | findstr /i "plugin_019U3bNQkGTiXZ6scgwqCx7c vibrobeast polygram plugins" >> "%OUT%"
echo -- mcp.json files >> "%OUT%"
dir /s /b "%~1\*.mcp.json" 2>nul >> "%OUT%"
dir /s /b "%~1\claude_desktop_config.json" 2>nul >> "%OUT%"
echo -- log files >> "%OUT%"
dir /s /b "%~1\*.log" 2>nul >> "%OUT%"
echo -- log lines naming the servers >> "%OUT%"
for /f "delims=" %%L in ('dir /s /b "%~1\*.log" 2^>nul') do findstr /i /c:"could_not_prepare" /c:"mentcached" /c:"skillx" /c:"vibrobeast" /c:"CLAUDE_PLUGIN_ROOT" /c:"prepare" "%%L" >> "%OUT%" 2>nul
goto :eof
