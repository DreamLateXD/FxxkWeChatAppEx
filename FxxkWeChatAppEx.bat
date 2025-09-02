chcp 65001
@echo off && title FxxkWeChatAppEx v1.0 by LateDream

:menu
cls
mode con: cols=42 lines=13
echo     FxxkWeChatAppEx v1.0 by LateDream
echo =========================================
echo       理论上该脚本不需要管理员权限
echo.
echo [k] - 关闭微信
echo [f] - 移除 WeChatAppEX + 防止死灰复燃
echo.
echo [r] - 恢复 WeChatAppEX
echo.
echo                                  [q] 退出
echo =========================================
set /p option=^>
if /i "%option%"=="q" exit
if /i "%option%"=="k" goto kill
if /i "%option%"=="f" goto fxxk
if /i "%option%"=="r" goto recovery

echo 无效的选项
pause
goto menu

:kill
cls
mode con: lines=3
taskkill /f /im Weixin.exe
if %errorlevel% neq 0 (
  echo.
  echo 关闭微信失败 请尝试手动关闭微信
  echo.
) else (
  echo.
  echo 成功关闭微信
  echo.
)
pause
goto menu

:fxxk
cls
mode con: cols=45 lines=3
rd /s /q %AppData%\Tencent\xwechat\XPlugin\Plugins\RadiumWMPF
if %errorlevel%==0 (
  echo 删除 RadiumWMPF...
  echo [==================                   ] 50%%
) else (
  echo 删除 RadiumWMPF 失败! 错误码: %errorlevel%
  echo [                                     ] 0%%
  pause
  goto menu
)
cls
echo FxxkWeChatAppEx>%AppData%\Tencent\xwechat\XPlugin\Plugins\RadiumWMPF
if %errorlevel%==0 (
  echo 写入 RadiumWMPF...
  echo [===========================          ] 75%%
) else (
  echo 写入 RadiumWMPF 失败! 错误码: %errorlevel%
  echo [==================                   ] 50%%
  pause
  goto menu
)
cls
attrib +r %AppData%\Tencent\xwechat\XPlugin\Plugins\RadiumWMPF
if %errorlevel%==0 (
  echo 成功! 感谢你的使用
  echo [=====================================] 100%%
) else (
  echo 添加只读属性失败! 错误码: %errorlevel%
  echo [===========================          ] 75%%
)
pause
goto menu

:recovery
cls
mode con: cols=45 lines=4
attrib -r %AppData%\Tencent\xwechat\XPlugin\Plugins\RadiumWMPF
del /s /q %AppData%\Tencent\xwechat\XPlugin\Plugins\RadiumWMPF>nul
if %errorlevel%==0 (
  echo 处理完成 重启微信即可完成恢复
  echo [=====================================] 100%%
) else (
  echo 处理失败! 错误码: %errorlevel%
  echo [                                     ] 0%%
)
pause
goto menu
