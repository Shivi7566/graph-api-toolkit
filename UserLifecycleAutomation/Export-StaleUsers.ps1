<#
.SYNOPSIS
    Audits inactive / stale Microsoft Entra users based on signInActivity via Microsoft Graph API v2.
.DESCRIPTION
    Scans interactive and non-interactive sign-in timestamps to identify accounts dormant for greater than $InactivityDays.
    Author: Cloud Knowledge | https://cloudknowledge.in
.PARAMETER InactivityDays
    Number of days of inactivity before flagging (Default: 90)
#>
[CmdletBinding()]
param(
    [int]$InactivityDays = 90,
    [string]$ExportPath = ".\Stale-Users-Audit.csv"
)

Write-Host "Connecting to Microsoft Graph (AuditLog.Read.All, User.Read.All)..." -ForegroundColor Cyan
Connect-MgGraph -Scopes "AuditLog.Read.All", "User.Read.All" -NoWelcome

$cutoffDate = (Get-Date).AddDays(-$InactivityDays)
$staleUsers = [System.Collections.Generic.List[PSCustomObject]]::new()

Write-Host "Auditing user sign-in activities..." -ForegroundColor Yellow
$users = Get-MgUser -All -Property Id, DisplayName, UserPrincipalName, AccountEnabled, UserType, SignInActivity

foreach ($u in $users) {
    $lastInteractive = $u.SignInActivity.LastSignInDateTime
    $lastNonInteractive = $u.SignInActivity.LastNonInteractiveSignInDateTime
    
    $mostRecent = $null
    if ($lastInteractive -and $lastNonInteractive) {
        $mostRecent = if ($lastInteractive -ge $lastNonInteractive) { $lastInteractive } else { $lastNonInteractive }
    } elseif ($lastInteractive) {
        $mostRecent = $lastInteractive
    } elseif ($lastNonInteractive) {
        $mostRecent = $lastNonInteractive
    }
    
    $isStale = $false
    $statusText = ""
    
    if ($null -eq $mostRecent) {
        $isStale = $true
        $statusText = "NEVER_LOGGED_IN"
    } elseif ($mostRecent -lt $cutoffDate) {
        $isStale = $true
        $statusText = "INACTIVE_OVER_$InactivityDays`_DAYS"
    }
    
    if ($isStale) {
        $staleUsers.Add([PSCustomObject]@{
            DisplayName               = $u.DisplayName
            UserPrincipalName         = $u.UserPrincipalName
            AccountEnabled            = $u.AccountEnabled
            UserType                  = $u.UserType
            LastSignInDateTime        = $mostRecent
            AuditStatus               = $statusText
        })
    }
}

if ($staleUsers.Count -gt 0) {
    $staleUsers | Export-Csv -Path $ExportPath -NoTypeInformation -Encoding utf8
    Write-Host "[!] Found $($staleUsers.Count) stale accounts." -ForegroundColor Red
    Write-Host "[✓] Exported to $ExportPath" -ForegroundColor Green
} else {
    Write-Host "[✓] No stale users detected beyond $InactivityDays days." -ForegroundColor Green
}
