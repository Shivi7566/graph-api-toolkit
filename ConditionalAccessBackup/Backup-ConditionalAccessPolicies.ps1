<#
.SYNOPSIS
    Automated disaster-recovery backup for Microsoft Entra Conditional Access Policies to versioned JSON.
.DESCRIPTION
    Extracts all Conditional Access policies including state, conditions, grant controls, and session controls via Microsoft Graph API.
    Author: Cloud Knowledge | https://cloudknowledge.in
#>
[CmdletBinding()]
param(
    [string]$BackupDirectory = ".\CAPolicyBackups"
)

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$targetDir = Join-Path $BackupDirectory $timestamp
if (!(Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}

Write-Host "Connecting to Microsoft Graph (Policy.Read.All)..." -ForegroundColor Cyan
Connect-MgGraph -Scopes "Policy.Read.All" -NoWelcome

Write-Host "Fetching Conditional Access policies..." -ForegroundColor Yellow
$policies = Get-MgIdentityConditionalAccessPolicy -All

$index = [System.Collections.Generic.List[PSCustomObject]]::new()

foreach ($pol in $policies) {
    # Clean filename
    $safeName = $pol.DisplayName -replace '[\\/:*?"<>|]', '_'
    $filePath = Join-Path $targetDir "$($safeName)_$($pol.Id).json"
    
    $pol | ConvertTo-Json -Depth 10 | Set-Content -Path $filePath -Encoding utf8
    
    $index.Add([PSCustomObject]@{
        PolicyName = $pol.DisplayName
        PolicyId   = $pol.Id
        State      = $pol.State
        FileName   = "$($safeName)_$($pol.Id).json"
    })
}

$indexFile = Join-Path $targetDir "Manifest.json"
$index | ConvertTo-Json -Depth 5 | Set-Content -Path $indexFile -Encoding utf8

Write-Host "[✓] Successfully backed up $($policies.Count) Conditional Access policies to: $targetDir" -ForegroundColor Green
Write-Host "[✓] Manifest generated: $indexFile" -ForegroundColor Green
