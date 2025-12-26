# =========================
# Smart Disk Cleanup Script
# =========================

$IsAdmin = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $IsAdmin) {
    Write-Host "Please run PowerShell as Administrator." -ForegroundColor Red
    exit
}


$LogFile = "$PSScriptRoot\cleanup.log"


$Before = (Get-PSDrive C).Free

function Write-Log {
    param ($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $Message" | Tee-Object -FilePath $LogFile -Append
}

Write-Log "Starting cleanup..."

$CleanupTargets = @(
    "$env:TEMP\*",
    "C:\Windows\Temp\*"
)

foreach ($target in $CleanupTargets) {
    Write-Log "Cleaning $target"
    Remove-Item $target -Recurse -Force -ErrorAction SilentlyContinue
}

Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Write-Log "Recycle Bin cleared"

Write-Log "Cleanup completed"

$After = (Get-PSDrive C).Free
$Recovered = [math]::Round(($After - $Before) / 1GB, 2)

Write-Log "Disk space recovered: $Recovered GB"
Write-Host "Recovered $Recovered GB" -ForegroundColor Green

Stop-Service wuauserv -Force
Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force
Start-Service wuauserv
