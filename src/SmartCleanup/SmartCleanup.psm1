$Public = Join-Path $PSScriptRoot "Public"

Get-ChildItem -Path $Public -Filter *.ps1 -Recurse | ForEach-Object {
    . $_.FullName
}
