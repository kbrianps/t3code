param(
    [switch]$Build,
    [switch]$DevWatch
)

$ErrorActionPreference = "Stop"

$workspaceRoot = "Z:\Workspaces\t3code"
$desktopDir = Join-Path $workspaceRoot "apps\desktop"
$electronPath = Join-Path $workspaceRoot "node_modules\.pnpm\electron@41.5.0\node_modules\electron\dist\electron.exe"
$mainPath = Join-Path $desktopDir "dist-electron\main.cjs"
$iconPath = Join-Path $workspaceRoot "assets\prod\t3-black-windows.ico"

# Ensure PATH includes Node & pnpm
$npmDir = "$env:APPDATA\npm"
$pnpmDir = "$env:LOCALAPPDATA\pnpm"
$nodeDir = "C:\Program Files\nodejs"
if ($env:PATH -notlike "*$npmDir*") { $env:PATH = "$npmDir;$env:PATH" }
if ($env:PATH -notlike "*$pnpmDir*") { $env:PATH = "$pnpmDir;$env:PATH" }
if ($env:PATH -notlike "*$nodeDir*") { $env:PATH = "$nodeDir;$env:PATH" }

if ($DevWatch) {
    Write-Host "Starting T3 Code in Live Dev Watch mode..." -ForegroundColor Cyan
    Push-Location $workspaceRoot
    try {
        node scripts/dev-runner.ts dev:desktop
    } finally {
        Pop-Location
    }
    return
}

if ($Build -or (-not (Test-Path $mainPath))) {
    Write-Host "Building T3 Code desktop artifacts..." -ForegroundColor Yellow
    Push-Location $workspaceRoot
    try {
        pnpm run build:desktop
    } finally {
        Pop-Location
    }
}

# Check if an instance is already running
$existing = Get-Process -Name "electron" -ErrorAction SilentlyContinue | Where-Object {
    $procId = $_.Id
    $cmd = (Get-CimInstance Win32_Process -Filter "ProcessId = $procId" -ErrorAction SilentlyContinue).CommandLine
    $cmd -like "*dist-electron\main.cjs*"
}

if ($existing) {
    Write-Host "T3 Code is already running (PID: $($existing.Id)). Activating window..." -ForegroundColor Green
    $wshell = New-Object -ComObject WScript.Shell
    $wshell.AppActivate("T3 Code") | Out-Null
    return
}

Write-Host "Launching T3 Code Dev Build..." -ForegroundColor Green
Start-Process -FilePath $electronPath -ArgumentList "`"$mainPath`"" -WorkingDirectory $desktopDir
