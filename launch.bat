@echo off
set SERVER="xxx-pal-server.com:18211"
set LOCAL="127.0.0.1:18211"
echo Port Forwarder running at %LOCAL%
echo Starting...
realm.exe -l %LOCAL% -r %SERVER% -u --dns-mode ipv6_only
