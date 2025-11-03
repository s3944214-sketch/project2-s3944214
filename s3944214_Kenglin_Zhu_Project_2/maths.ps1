# Student Number: s3944214
# Student Name  : Kenglin Zhu
# Script       : maths.ps1
# Purpose: CLI calculator with validation & loop

# function: numeric check
function Test-Number($s) { [double]::TryParse($s, [ref]0) }

# function: integer check (for modulo)
function Test-Integer($s) { $null -ne ($s -as [int]) -and ($s -as [string]) -notmatch '\.' }

while ($true) {
  Write-Host "===== Simple Calculator ====="
  Write-Host "1) Add"
  Write-Host "2) Subtract"
  Write-Host "3) Multiply"
  Write-Host "4) Divide"
  Write-Host "5) Modulo"
  Write-Host "6) Exit"
  $op = Read-Host "Select option (1-6)"

  if ($op -eq '6') { Write-Host "Bye."; break }
  if ($op -notin '1','2','3','4','5') { Write-Host "Invalid option."; continue }

  $a = Read-Host "Enter first number"
  $b = Read-Host "Enter second number"

  if (-not (Test-Number $a) -or -not (Test-Number $b)) {
    Write-Host "Error: both inputs must be numeric."; continue
  }

  if (($op -in '4','5') -and ([double]$b -eq 0)) {
    Write-Host "Error: division/modulo by zero is not allowed."; continue
  }

  if ($op -eq '5' -and (-not (Test-Integer $a) -or -not (Test-Integer $b))) {
    Write-Host "Error: modulo requires integer inputs."; continue
  }

  # compute and print result (debugging: use Write-Host "op=$op a=$a b=$b")
  switch ($op) {
    '1' { $res = [double]$a + [double]$b; $sym = '+' }
    '2' { $res = [double]$a - [double]$b; $sym = '-' }
    '3' { $res = [double]$a * [double]$b; $sym = '*' }
    '4' { $res = [double]$a / [double]$b; $sym = '/' }
    '5' { $res = [int]$a % [int]$b;        $sym = '%' }
  }
  Write-Host ("Result: {0} {1} {2} = {3}" -f $a, $sym, $b, $res)
  Write-Host
}

# debugging tips:
# 1) Set-PSDebug -Trace 1   # show each statement
# 2) Write-Host variables when needed
# 3) Use-StrictMode -Version Latest   # stricter checks
