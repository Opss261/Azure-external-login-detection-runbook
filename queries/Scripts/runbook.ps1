# Azure External Login Detection Runbook
# Presentation/demo version showing the overall workflow

$DaysToCheck = 30

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
# 5. Send an email alert if required

# Demo data for presentation purposes
$Results = @(
    [PSCustomObject]@{
        UserPrincipalName = "test.user@company.com"
        Country           = "Ghana"
        IPAddress         = "102.176.12.10"
        TimeGenerated     = "2026-04-02 08:15:00"
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

    $EmailBody = @"
External login activity detected.

User: $($Results[0].UserPrincipalName)
Country: $($Results[0].Country)
IP Address: $($Results[0].IPAddress)
Time: $($Results[0].TimeGenerated)

Please review and confirm whether this sign-in activity is expected.
"@

    Write-Output "Prepared email alert:"
    Write-Output $EmailBody

    # Example only:
    # Send-MailMessage -To "itmanager@company.com" `
    #                  -From "alerts@company.com" `
    #                  -Subject "External Login Alert" `
    #                  -Body $EmailBody `
    #                  -SmtpServer "smtp.office365.com"
}
else {
    Write-Output "No external logins detected."
}

Write-Output "Runbook completed."
