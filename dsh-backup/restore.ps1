# DeepSeek Harness (DSH) 一键环境恢复脚本
# 适用于新电脑安装 DSH 后的配置与插件一键恢复

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  DeepSeek Harness 配置与插件一键恢复   " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$userHome = [Environment]::GetFolderPath("UserProfile")
$dshHome = Join-Path $userHome ".dsh"
$desktopProfile = Join-Path $dshHome "profiles\desktop"
$pluginsDir = Join-Path $dshHome "plugins"

$currentDir = $PSScriptRoot

Write-Host "[1/4] 检查目标目录..." -ForegroundColor Yellow
if (!(Test-Path $desktopProfile)) {
    New-Item -ItemType Directory -Path $desktopProfile -Force | Out-Null
}
if (!(Test-Path $pluginsDir)) {
    New-Item -ItemType Directory -Path $pluginsDir -Force | Out-Null
}

Write-Host "[2/4] 同步插件扩展包..." -ForegroundColor Yellow
Copy-Item -Path (Join-Path $currentDir "plugins\*") -Destination $pluginsDir -Recurse -Force

Write-Host "[3/4] 同步配置文件 (package.json & cordis.patch.yml)..." -ForegroundColor Yellow
# 读取 package.json，动态调整本地 link 路径以适配新机器的用户目录
$pkgPath = Join-Path $currentDir "package.json"
$pkgJson = Get-Content $pkgPath -Raw | ConvertFrom-Json

$newIotPath = "link:" + ($pluginsDir -replace '\\', '/') + "/dsh-plugin-iot-thinking"
$newScreenshotPath = "file:" + ($pluginsDir -replace '\\', '/') + "/dsh-screenshot-2.3.0.tgz"

if ($pkgJson.dependencies.'dsh-plugin-iot-thinking') {
    $pkgJson.dependencies.'dsh-plugin-iot-thinking' = $newIotPath
}
if ($pkgJson.dependencies.'dsh-screenshot') {
    $pkgJson.dependencies.'dsh-screenshot' = $newScreenshotPath
}

$destPkgPath = Join-Path $desktopProfile "package.json"
$pkgJson | ConvertTo-Json -Depth 20 | Set-Content -Path $destPkgPath -Encoding UTF8

Copy-Item -Path (Join-Path $currentDir "cordis.patch.yml") -Destination (Join-Path $desktopProfile "cordis.patch.yml") -Force

Write-Host "[4/4] 执行插件依赖同步与挂载..." -ForegroundColor Yellow
$dshCli = "C:\Users\$env:USERNAME\AppData\Local\Programs\DeepSeek Harness\resources\runtime\cli\bin\dsh.cmd"
if (Test-Path $dshCli) {
    & $dshCli plugin --profile desktop install
    Write-Host "`n[✓] 恢复成功！请重启 DeepSeek Harness 即可体验全部插件与配置。" -ForegroundColor Green
} else {
    Write-Host "`n[!] 未在默认路径检测到 DSH CLI，请手动在新机器终端中执行: dsh plugin --profile desktop install" -ForegroundColor Yellow
}
