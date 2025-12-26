# 🧹 SmartCleanup

SmartCleanup is a safe, PowerShell-based disk cleanup tool for Windows.
It removes common junk files while supporting `-WhatIf` and `-Confirm`
for maximum safety.

## ✨ Features
- Cleans user & system temp files
- Clears Recycle Bin
- Shows disk space recovered
- Logging support
- `-WhatIf` (dry-run) mode
- `-Confirm` prompts
- Admin-aware

## 📦 Requirements
- Windows 10 / 11
- PowerShell 5.1+ or PowerShell 7+
- Administrator privileges (recommended)

## 🚀 Usage

```powershell
# Dry run (no changes)
.\SmartCleanup.ps1 -WhatIf

# Ask for confirmation
.\SmartCleanup.ps1 -Confirm

# Normal run
.\SmartCleanup.ps1
