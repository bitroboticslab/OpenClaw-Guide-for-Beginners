# OpenClaw WSL 一键安装脚本
# 适用于 Windows Subsystem for Linux

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════╗"
Write-Host "║           OpenClaw WSL 一键安装脚本                      ║"
Write-Host "║                                                           ║"
Write-Host "║  本脚本将自动安装:                                         ║"
Write-Host "║  1. WSL 2 (如果未启用)                                   ║"
Write-Host "║  2. Ubuntu (如果未安装)                                  ║"
Write-Host "║  3. Node.js 22                                            ║"
Write-Host "║  4. OpenClaw 核心                                         ║"
Write-Host "╚═══════════════════════════════════════════════════════════╝"
Write-Host ""

# 检查管理员权限
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[错误] 请以管理员身份运行此脚本！" -ForegroundColor Red
    Write-Host "右键点击 PowerShell -^> 以管理员身份运行" -ForegroundColor Yellow
    Read-Host "按回车键退出"
    exit 1
}

# 启用 WSL 2
function Enable-WSL2 {
    Write-Host ""
    Write-Host "[1/4] 检查 WSL 2..." -ForegroundColor Cyan

    # 检查 WSL 是否已安装
    $wslFeature = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
    $vmFeature = Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform

    if ($wslFeature.State -eq "Enabled" -and $vmFeature.State -eq "Enabled") {
        Write-Host "[√] WSL 2 已启用" -ForegroundColor Green
        return 0
    }

    Write-Host "[!] 正在启用 WSL 2..." -ForegroundColor Yellow

    try {
        # 启用 WSL 功能
        if ($wslFeature.State -ne "Enabled") {
            Write-Host "[*] 启用 WSL 功能..." -ForegroundColor Yellow
            Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
        }

        # 启用虚拟机平台
        if ($vmFeature.State -ne "Enabled") {
            Write-Host "[*] 启用虚拟机平台..." -ForegroundColor Yellow
            Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
        }

        # 设置 WSL 2 为默认版本
        wsl --set-default-version 2

        Write-Host "[√] WSL 2 启用完成" -ForegroundColor Green
        Write-Host "[!] 可能需要重启系统" -ForegroundColor Yellow
        Write-Host "[!] 重启后请重新运行此脚本" -ForegroundColor Yellow

        Read-Host "按回车键重启系统"
        Restart-Computer -Force
        exit 0
    }
    catch {
        Write-Host "[错误] 启用 WSL 2 失败: $_" -ForegroundColor Red
        exit 1
    }
}

# 安装 Ubuntu
function Install-UbLinux {
    Write-Host ""
    Write-Host "[2/4] 检查 Ubuntu..." -ForegroundColor Cyan

    # 检查是否已安装 Ubuntu
    $ubuntuDistributions = wsl -l -q
    if ($ubuntuDistributions -match "Ubuntu") {
        Write-Host "[√] Ubuntu 已安装" -ForegroundColor Green
        $ubuntuName = ($ubuntuDistributions -match "Ubuntu")[0]
        return $ubuntuName
    }

    Write-Host "[!] 正在安装 Ubuntu..." -ForegroundColor Yellow

    try {
        # 下载 Ubuntu
        Write-Host "[*] 从 Microsoft Store 下载 Ubuntu..." -ForegroundColor Yellow
        Write-Host "[!] 请在弹出的 Microsoft Store 窗口中点击「获取」" -ForegroundColor Yellow

        # 打开 Microsoft Store
        Start-Process "ms-windows-store://pdp/?productid=9PND9F5V3WCL"

        Write-Host "[!]`n请按照以下步骤操作:" -ForegroundColor Yellow
        Write-Host "  1. 在 Microsoft Store 中安装 Ubuntu" -ForegroundColor White
        Write-Host "  2. 安装完成后，首次启动 Ubuntu" -ForegroundColor White
        Write-Host "  3. 设置用户名和密码" -ForegroundColor White
        Write-Host "  4. 完成后按回车键继续" -ForegroundColor White

        Read-Host "`n按回车键继续"

        # 再次检查
        $ubuntuDistributions = wsl -l -q
        if ($ubuntuDistributions -match "Ubuntu") {
            Write-Host "[√] Ubuntu 安装成功" -ForegroundColor Green
            return ($ubuntuDistributions -match "Ubuntu")[0]
        }

        Write-Host "[错误] 未检测到 Ubuntu 安装" -ForegroundColor Red
        exit 1
    }
    catch {
        Write-Host "[错误] 安装 Ubuntu 失败: $_" -ForegroundColor Red
        exit 1
    }
}

# 安装 OpenClaw 到 WSL
function Install-OpenClaw-WSL {
    param([string]$UbuntuName)

    Write-Host ""
    Write-Host "[3/4] 在 WSL 中安装 OpenClaw..." -ForegroundColor Cyan

    try {
        # 检查 WSL 中是否已安装 OpenClaw
        $installed = wsl -d $UbuntuName -- bash -c "command -v openclaw" 2>$null

        if ($LASTEXITCODE -eq 0) {
            Write-Host "[√] OpenClaw 已安装" -ForegroundColor Green
            return 0
        }

        Write-Host "[!] 正在安装 OpenClaw..." -ForegroundColor Yellow

        # 创建安装脚本
        $installScript = @'
#!/bin/bash

# 安装 Node.js依赖
sudo apt update
sudo apt install -y curl python3

# 安装 Node.js 22
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    sudo apt install -y nodejs
fi

# 安装 OpenClaw
curl -fsSL https://openclaw.ai/install.sh | bash

# 添加到 PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
export PATH="$HOME/.local/bin:$PATH"

echo "OpenClaw 安装完成"
'@

        # 在 WSL 中执行安装
        $installScript | wsl -d $UbuntuName -- bash

        Write-Host "[√] OpenClaw 安装完成" -ForegroundColor Green
    }
    catch {
        Write-Host "[错误] 安装 OpenClaw 失败: $_" -ForegroundColor Red
        exit 1
    }
}

# 配置 API Key
function Configure-OpenClaw-WSL {
    param([string]$UbuntuName)

    Write-Host ""
    Write-Host "[4/4] 配置 API Key..." -ForegroundColor Cyan

    $choices = @(
        "1. 硅基流动 (推荐新手)",
        "2. 阿里百炼",
        "3. 火山方舟",
        "4. 智谱 GLM",
        "5. 跳过配置"
    )

    $choices | ForEach-Object { Write-Host $_ -ForegroundColor White }

    $choice = Read-Host "`n请输入选择 [1-5]"

    switch ($choice) {
        "1" {
            Write-Host ""
            Write-Host "[!] 请先在 https://cloud.siliconflow.cn 注册账号并获取 API Key" -ForegroundColor Yellow
            $apiKey = Read-Host "请输入硅基流动 API Key"

            wsl -d $UbuntuName -- bash -c "openclaw config set provider siliconflow && openclaw config set api_key $apiKey"
        }
        "2" {
            Write-Host ""
            Write-Host "[!] 请先在 https://www.aliyun.com/benefit/ai/aistar?userCode=yyzsc1al&clubBiz=subTask..12385059..10263.. 开通服务" -ForegroundColor Yellow
            $apiKey = Read-Host "请输入阿里百炼 API Key"

            wsl -d $UbuntuName -- bash -c "openclaw config set provider bailian && openclaw config set api_key $apiKey"
        }
        "3" {
            Write-Host ""
            Write-Host "[!] 请先在 https://www.volcengine.com/activity/codingplan 订阅" -ForegroundColor Yellow
            $apiKey = Read-Host "请输入火山方舟 API Key"

            wsl -d $UbuntuName -- bash -c "openclaw config set provider volcengine && openclaw config set api_key $apiKey"
        }
        "4" {
            Write-Host ""
            Write-Host "[!] 请先在 https://z.ai/subscribe 订阅" -ForegroundColor Yellow
            $apiKey = Read-Host "请输入智谱 API Key"

            wsl -d $UbuntuName -- bash -c "openclaw config set provider zhipu && openclaw config set api_key $apiKey"
        }
        "5" {
            Write-Host "[!] 已跳过配置，稍后请运行: wsl -d $UbuntuName -- openclaw onboard --install-daemon" -ForegroundColor Yellow
        }
        default {
            Write-Host "[!] 无效选择，已跳过配置" -ForegroundColor Yellow
        }
    }
}

# 显示完成信息
function Show-Complete-WSL {
    param([string]$UbuntuName)

    Write-Host ""
    Write-Host "╔═══════════════════════════════════════════════════════════╗"
    Write-Host "║                    安装成功！                              ║"
    Write-Host "║                                                           ║"
    Write-Host "║  启动 WSL: wsl -d $UbuntuName                              ║"
    Write-Host "║  启动 OpenClaw: wsl -d $UbuntuName -- openclaw start        ║"
    Write-Host "║  查看状态: wsl -d $UbuntuName -- openclaw status            �    ║"
    Write-Host "║  查看日志: wsl -d $UbuntuName -- openclaw logs              ║"
    Write-Host "║                                                           ║"
    Write-Host "║  API 平台注册链接:                                        ║"
    Write-Host "║  - 硅基流动: https://cloud.siliconflow.cn                 ║"
    Write-Host "║  - 阿里百炼: https://bailian.console.aliyun.com           ║"
    Write-Host "║  - 火山方舟: https://www.volcengine.com/activity/codingplan ║"
    Write-Host "╚═══════════════════════════════════════════════════════════╝"
    Write-Host ""
}

# 主流程
try {
    Enable-WSL2
    $ubuntuName = Install-UbLinux
    Install-OpenClaw-WSL -UbuntuName $ubuntuName
    Configure-OpenClaw-WSL -UbuntuName $ubuntuName
    Show-Complete-WSL -UbuntuName $ubuntuName
}
catch {
    Write-Host "[错误] 安装失败: $_" -ForegroundColor Red
    exit 1
}
