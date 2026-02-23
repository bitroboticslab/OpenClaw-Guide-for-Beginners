@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo.
echo ╔═══════════════════════════════════════════════════════════╗
echo ║           OpenClaw Windows 一键安装脚本                    ║
echo ║                                                           ║
echo ║  本脚本将自动安装:                                         ║
echo ║  1. Node.js 22 (通过 nvm)                                 ║
echo ║  2. OpenClaw 核心                                         ║
echo ║  3. 依赖组件                                              ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.

:: 检查管理员权限
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 请以管理员身份运行此脚本！
    echo 右键点击 PowerShell -^> 以管理员身份运行
    pause
    exit /b 1
)

:: 检查 Node.js
echo [1/4] 检查 Node.js 环境...
node -v >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('node -v') do set NODE_VER=%%i
    echo [√] Node.js 已安装: !NODE_VER!
) else (
    echo [!] Node.js 未安装，正在安装...
    
    :: 检查 nvm
    nvm version >nul 2>&1
    if %errorlevel% neq 0 (
        echo [!] 正在下载 nvm-windows...
        powershell -Command "Invoke-WebRequest -Uri 'https://github.com/coreybutler/nvm-windows/releases/download/1.1.11/nvm-setup.exe' -OutFile '%TEMP%\nvm-setup.exe'"
        echo [!] 请完成 nvm 安装后重新运行此脚本
        start /wait %TEMP%\nvm-setup.exe
        pause
        exit /b 0
    )
    
    :: 安装 Node.js 22
    echo [!] 正在安装 Node.js 22...
    nvm install 22
    nvm use 22
)

:: 验证 Node.js 版本
for /f "tokens=2 delims=v" %%i in ('node -v 2^>nul') do set NODE_MAJOR=%%i
set NODE_MAJOR=%NODE_MAJOR:~0,2%
if %NODE_MAJOR% lss 22 (
    echo [!] Node.js 版本过低，需要 22 或更高版本
    echo [!] 当前版本: !NODE_VER!
    pause
    exit /b 1
)

:: 安装 OpenClaw
echo.
echo [2/4] 安装 OpenClaw...
where openclaw >nul 2>&1
if %errorlevel% equ 0 (
    echo [√] OpenClaw 已安装
) else (
    echo [!] 正在下载并安装 OpenClaw...
    powershell -Command "iwr -useb https://openclaw.ai/install.ps1 | iex"
)

:: 配置向导
echo.
echo [3/4] 配置向导...
echo 请选择你的 API 提供商:
echo   1. 硅基流动 (推荐新手)
echo   2. 阿里百炼
echo   3. 火山方舟
echo   4. 智谱 GLM
echo   5. 跳过配置
echo.
set /p CHOICE="请输入选择 [1-5]: "

if "%CHOICE%"=="1" (
    echo.
    echo [!] 请先在 https://cloud.siliconflow.cn 注册账号并获取 API Key
    set /p API_KEY="请输入硅基流动 API Key: "
    echo [!] 正在配置...
    openclaw config set provider siliconflow
    openclaw config set api_key !API_KEY!
)
if "%CHOICE%"=="2" (
    echo.
    echo [!] 请先在 https://bailian.console.aliyun.com 开通服务
    set /p API_KEY="请输入阿里百炼 API Key: "
    openclaw config set provider bailian
    openclaw config set api_key !API_KEY!
)
if "%CHOICE%"=="3" (
    echo.
    echo [!] 请先在 https://www.volcengine.com/activity/codingplan 订阅
    set /p API_KEY="请输入火山方舟 API Key: "
    openclaw config set provider volcengine
    openclaw config set api_key !API_KEY!
)
if "%CHOICE%"=="4" (
    echo.
    echo [!] 请先在 https://z.ai/subscribe 订阅
    set /p API_KEY="请输入智谱 API Key: "
    openclaw config set provider zhipu
    openclaw config set api_key !API_KEY!
)

:: 完成
echo.
echo [4/4] 安装完成！
echo.
echo ╔═══════════════════════════════════════════════════════════╗
echo ║                    安装成功！                              ║
echo ║                                                           ║
echo ║  启动命令: openclaw start                                 ║
echo ║  查看状态: openclaw status                                ║
echo ║  查看日志: openclaw logs                                  ║
echo ║                                                           ║
echo ║  API 平台注册链接:                                        ║
echo ║  - 硅基流动: https://cloud.siliconflow.cn                 ║
echo ║  - 阿里百炼: https://bailian.console.aliyun.com           ║
echo ║  - 火山方舟: https://www.volcengine.com/activity/codingplan║
echo ╚═══════════════════════════════════════════════════════════╝
echo.

pause
