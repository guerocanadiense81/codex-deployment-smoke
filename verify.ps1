[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSCommandPath
$checks = 0

function Assert-True {
    param(
        [Parameter(Mandatory)]
        [bool]$Condition,

        [Parameter(Mandatory)]
        [string]$Message
    )

    if (-not $Condition) {
        throw $Message
    }

    $script:checks++
}

$requiredFiles = @('index.html', 'README.md', '.nojekyll')
foreach ($name in $requiredFiles) {
    Assert-True -Condition (Test-Path -LiteralPath (Join-Path $root $name) -PathType Leaf) -Message "Missing required file: $name"
}

$utf8 = [System.Text.UTF8Encoding]::new($false, $true)
$indexPath = Join-Path $root 'index.html'
$readmePath = Join-Path $root 'README.md'
$index = $utf8.GetString([System.IO.File]::ReadAllBytes($indexPath))
$readme = $utf8.GetString([System.IO.File]::ReadAllBytes($readmePath))

Assert-True -Condition $index.StartsWith('<!doctype html>', [System.StringComparison]::OrdinalIgnoreCase) -Message 'index.html must begin with an HTML5 doctype.'
Assert-True -Condition $index.Contains('<meta charset="utf-8">') -Message 'index.html must declare UTF-8.'
Assert-True -Condition $index.Contains('name="viewport"') -Message 'index.html must include responsive viewport metadata.'
Assert-True -Condition $index.Contains('<title>Deployment verification</title>') -Message 'index.html must retain the expected title.'
Assert-True -Condition $readme.Contains('GitHub Pages') -Message 'README.md must document the selected deployment target.'

$combined = $index + "`n" + $readme
$secretPatterns = @(
    '-----BEGIN PRIVATE KEY-----',
    'ghp_[A-Za-z0-9]{20,}',
    'hf_[A-Za-z0-9]{20,}',
    'AIza[0-9A-Za-z_-]{20,}',
    '(?i)FIREBASE_TOKEN\s*=',
    '(?i)VERCEL_TOKEN\s*=',
    '(?i)RENDER_API_KEY\s*='
)
foreach ($pattern in $secretPatterns) {
    Assert-True -Condition (-not [regex]::IsMatch($combined, $pattern)) -Message "Potential credential pattern found: $pattern"
}

Write-Output "DEPLOYMENT_SMOKE_LOCAL_PASS: $checks checks"
