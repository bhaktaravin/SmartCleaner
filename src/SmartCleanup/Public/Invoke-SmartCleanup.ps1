
<#
.SYNOPSIS
Safely cleans temporary files and the Recycle Bin.

.DESCRIPTION
SmartCleanup removes common temporary files while supporting
-WhatIf and -Confirm to prevent accidental data loss.

.EXAMPLE
Invoke-SmartCleanup -WhatIf

.EXAMPLE
Invoke-SmartCleanup -Confirm
#>


Function Invoke-SmartCleanup {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param ()

    # Admin check
    $IsAdmin = ([Security.Principal.WindowsPrincipal]
        [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if (-not $IsAdmin) {
        Write-Warning "Run PowerShell as Administrator."
        return
    }

    $LogFile = Join-Path $PSScriptRoot "cleanup.log"

    function Write-Log {
        param ($Message)
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        "$timestamp - $Message" | Tee-Object -FilePath $LogFile -Append
    }

    if ($WhatIfPreference) {
        Write-Verbose "WHAT-IF mode enabled"
        Write-Log "WHAT-IF mode enabled"
    }

    $Before = (Get-PSDrive C).Free

    $CleanupTargets = @(
        "$env:TEMP\*",
        "C:\Windows\Temp\*"
    )

    Write-Log "Starting cleanup"

    foreach ($target in $CleanupTargets) {
        if (Test-Path $target) {
            if ($PSCmdlet.ShouldProcess($target, "Delete files")) {
                Write-Log "Cleaning $target"
                Remove-Item $target -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
    }

    if ($PSCmdlet.ShouldProcess("Recycle Bin", "Clear")) {
        Clear-RecycleBin -Force -ErrorAction SilentlyContinue
        Write-Log "Recycle Bin cleared"
    }

    $After = (Get-PSDrive C).Free
    $Recovered = [math]::Round(($After - $Before) / 1GB, 2)

    Write-Log "Recovered $Recovered GB"
    Write-Host "Recovered $Recovered GB" -ForegroundColor Green
}
