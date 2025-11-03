# Student Number: s3944214
# Student Name  : Kenglin Zhu
# Script       : Windows.ps1
# Purpose      : Ask a folder and a file extension, then list matches as a table.

$dir  = Read-Host "Enter directory (e.g. C:\Users\kenglin\Documents\)"
$type = Read-Host "Enter file type (e.g. .ps1, .txt, .log)"

if (-not (Test-Path -LiteralPath $dir)) {
  Write-Host "Directory not found: $dir"
  exit 1
}

$searchPath = Join-Path -Path $dir -ChildPath "*"
$pattern    = "*$type"

Get-ChildItem -Path $searchPath -File -Filter $pattern -ErrorAction SilentlyContinue |
  Select-Object Name, Directory |
  Format-Table -AutoSize
