New-ModuleManifest
  -Path src/SmartCleanup/SmartCleanup.psd1 `
  -RootModule SmartCleanup.psm1 `
  -ModuleVersion 1.0.0 `
  -Description "Safe PowerShell disk cleanup module with WhatIf support" `
  -Author "Ravin Bhakta" `
  -CompanyName "Personal" `
  -PowerShellVersion 5.1 `
  -FunctionsToExport Invoke-SmartCleanup
