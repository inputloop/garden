@echo off
setlocal
set OUT=%~dp0mcp-probe.out.txt
echo == mcp-probe %DATE% %TIME% > "%OUT%"
echo == whoami >> "%OUT%"
whoami >> "%OUT%" 2>&1
echo == PATH >> "%OUT%"
echo %PATH% >> "%OUT%"
echo == where python3 >> "%OUT%"
where python3 >> "%OUT%" 2>&1
echo == where python >> "%OUT%"
where python >> "%OUT%" 2>&1
echo == where py >> "%OUT%"
where py >> "%OUT%" 2>&1
echo == py -0p >> "%OUT%"
py -0p >> "%OUT%" 2>&1
echo == python3 -c version >> "%OUT%"
python3 -c "import sys;print(sys.version)" >> "%OUT%" 2>&1
echo rc=%ERRORLEVEL% >> "%OUT%"
echo == python -c version >> "%OUT%"
python -c "import sys;print(sys.version)" >> "%OUT%" 2>&1
echo rc=%ERRORLEVEL% >> "%OUT%"
echo == APPDATA Claude logs dir >> "%OUT%"
dir "%APPDATA%\Claude\logs" >> "%OUT%" 2>&1
echo == log lines naming the servers >> "%OUT%"
findstr /s /i /c:"could_not_prepare" /c:"mentcached" /c:"vibrobeast" /c:"skillx" /c:"CLAUDE_PLUGIN_ROOT" "%APPDATA%\Claude\logs\*" >> "%OUT%" 2>&1
echo == plugin copies on this host >> "%OUT%"
dir /s /b /ad "%APPDATA%\Claude" 2>nul | findstr /i "vibrobeast" >> "%OUT%"
dir /s /b /ad "%LOCALAPPDATA%\AnthropicClaude" 2>nul | findstr /i "vibrobeast" >> "%OUT%"
dir /s /b "%APPDATA%\Claude\*.mcp.json" 2>nul >> "%OUT%"
echo == done >> "%OUT%"
