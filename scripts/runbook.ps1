# Azure External Login Detection Runbook
# Presentation/demo version showing the overall workflow
# Updated to send a single consolidated alert to a Logic App webhook

$DaysToCheck = 30
$LogicAppUrl = "<REDACTED_LOGIC_APP_URL>"
Write-Output "Starting Azure external login detection runbook..."
Write-Output "Checking sign-in activity from the past $DaysToCheck days."

$Query = @"
SigninLogs
| where TimeGenerated > ago(30d)
| where LocationDetails.countryOrRegion != "GB"
| project UserPrincipalName, IPAddress, TimeGenerated, LocationDetails
"@

Write-Output "KQL query prepared successfully."

# In a live environment, the runbook would:
# 1. Connect to Azure / Log Analytics
# 2. Execute the KQL query
# 3. Process any returned sign-in events
# 4. Format a report
# 5. Send a single consolidated email alert if required

# Demo data for presentation purposes
$Results = @(
    [PSCustomObject]@{
        UserPrincipalName = "test.user@company.com"
        Country           = "Ghana"
        IPAddress         = "102.176.12.10"
        TimeGenerated     = "2026-04-02 08:15:00"
    },
    [PSCustomObject]@{
        UserPrincipalName = "jane.doe@company.com"
        Country           = "Nigeria"
        IPAddress         = "197.210.54.33"
        TimeGenerated     = "2026-04-03 11:42:00"
    },
    [PSCustomObject]@{
        UserPrincipalName = "mark.smith@company.com"
        Country           = "Netherlands"
        IPAddress         = "185.220.101.45"
        TimeGenerated     = "2026-04-04 16:08:00"
    }
)

if ($Results.Count -gt 0) {
    Write-Output "External login activity detected."

    foreach ($Result in $Results) {
        Write-Output "User: $($Result.UserPrincipalName)"
        Write-Output "Country: $($Result.Country)"
        Write-Output "IP Address: $($Result.IPAddress)"
        Write-Output "Time: $($Result.TimeGenerated)"
        Write-Output "-----------------------------"
    }

    $EmailBody = "External login activity detected.`n`n"
    $EmailBody += "The following users have signed in from outside the UK in the past 30 days:`n`n"

    foreach ($Result in $Results) {
        $EmailBody += "User: $($Result.UserPrincipalName)`n"
        $EmailBody += "Country: $($Result.Country)`n"
        $EmailBody += "IP Address: $($Result.IPAddress)`n"
        $EmailBody += "Time: $($Result.TimeGenerated)`n"
        $EmailBody += "-----------------------------`n"
    }

    $EmailBody += "`nPlease review and confirm whether this sign-in activity is expected."

    Write-Output "Prepared consolidated email alert:"
    Write-Output $EmailBody

    $body = @{
        AlertMessage = $EmailBody
    } | ConvertTo-Json -Depth 3

    Invoke-RestMethod -Uri $LogicAppUrl `
                      -Method POST `
                      -Body $body `
                      -ContentType "application/json"

    Write-Output "Consolidated alert sent to Logic App successfully."
}
else {
    Write-Output "No external logins detected."
}

Write-Output "Runbook completed."
