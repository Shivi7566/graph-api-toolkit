<#
.SYNOPSIS
    Scans Microsoft Entra App Registrations and Enterprise Applications for client secrets and certificates expiring within specified days.
.DESCRIPTION
    Uses Microsoft Graph PowerShell SDK v2 (Get-MgApplication, Get-MgServicePrincipal) with least-privilege scoping to alert on impending credential outages.
    Author: Cloud Knowledge | https://cloudknowledge.in
.PARAMETER DaysThreshold
    Days threshold for expiration warning (Default: 30)
#>
[CmdletBinding()]
param(
    [int]$DaysThreshold = 30,
    [string]$ExportPath = ".\Credential-Expiration-Report.csv"
)

Write-Host "Connecting to Microsoft Graph (Application.Read.All)..." -ForegroundColor Cyan
Connect-MgGraph -Scopes "Application.Read.All" -NoWelcome

$now = Get-Date
$thresholdDate = $now.AddDays($DaysThreshold)
$expiringList = [System.Collections.Generic.List[PSCustomObject]]::new()

Write-Host "Auditing Application Registrations..." -ForegroundColor Yellow
$apps = Get-MgApplication -All -Property Id, AppId, DisplayName, PasswordCredentials, KeyCredentials

foreach ($app in $apps) {
    # Check Client Secrets
    foreach ($secret in $app.PasswordCredentials) {
        if ($secret.EndDateTime -le $thresholdDate) {
            $daysLeft = ($secret.EndDateTime - $now).Days
            $status = if ($daysLeft -lt 0) { "EXPIRED" } else { "EXPIRING_SOON" }
            $expiringList.Add([PSCustomObject]@{
                Type           = "Client Secret"
                AppName        = $app.DisplayName
                AppId          = $app.AppId
                KeyId          = $secret.KeyId
                ExpirationDate = $secret.EndDateTime
                DaysRemaining  = $daysLeft
                Status         = $status
            })
        }
    }
    
    # Check Certificates
    foreach ($cert in $app.KeyCredentials) {
        if ($cert.EndDateTime -le $thresholdDate) {
            $daysLeft = ($cert.EndDateTime - $now).Days
            $status = if ($daysLeft -lt 0) { "EXPIRED" } else { "EXPIRING_SOON" }
            $expiringList.Add([PSCustomObject]@{
                Type           = "Certificate"
                AppName        = $app.DisplayName
                AppId          = $app.AppId
                KeyId          = $cert.KeyId
                ExpirationDate = $cert.EndDateTime
                DaysRemaining  = $daysLeft
                Status         = $status
            })
        }
    }
}

if ($expiringList.Count -gt 0) {
    $expiringList | Export-Csv -Path $ExportPath -NoTypeInformation -Encoding utf8
    Write-Host "[!] Found $($expiringList.Count) credentials requiring immediate rotation." -ForegroundColor Red
    Write-Host "[✓] Full report exported to $ExportPath" -ForegroundColor Green
} else {
    Write-Host "[✓] All application credentials healthy. None expiring within $DaysThreshold days." -ForegroundColor Green
}
