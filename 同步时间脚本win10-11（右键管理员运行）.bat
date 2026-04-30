@echo off
title 修复并设置Windows时间同步间隔为3小时

echo 正在检查并启动 Windows 时间服务...

:: 将服务启动类型设为自动（延迟启动也可，但自动更稳妥）
sc config W32Time start= auto >nul

:: 启动服务（如果已启动会提示，不影响）
net start W32Time >nul 2>&1

echo 正在设置时间同步间隔为 10800 秒 (3 小时)...

:: 修改注册表中的轮询间隔
reg add "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient" /v SpecialPollInterval /t REG_DWORD /d 10800 /f >nul

:: 更新时间服务配置
w32tm /config /update >nul

:: 强制立即同步一次
echo 正在强制同步时间...
w32tm /resync

echo.
echo 设置完成！现在系统将每隔 3 小时自动同步一次时间。
pause