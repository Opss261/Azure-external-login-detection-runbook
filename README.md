# Azure External Login Detection Runbook

## Overview
This project shows how I would design and implement an automated solution in Azure to identify users who have logged into their accounts from outside the UK within the last 30 days.

The aim is to provide visibility into potentially unusual sign-in activity while keeping the solution practical and easy to maintain.

---

## Problem Statement
In any organisation, users may log in from different locations for legitimate reasons, such as working remotely or travelling.

However, sign-ins from outside the UK can also indicate something more serious, such as a compromised account.

Without automation, identifying these events would require manually reviewing logs, which is not efficient or scalable. So the goal here is to automate that visibility.

---

## Architecture
To solve this, I would use Azure-native services:

- Azure Entra ID sign-in logs as the data source
- Log Analytics to query and analyse login activity
- KQL to filter out logins outside the UK
- Azure Automation to run the process
- A PowerShell Runbook to tie everything together
- Email alerts to notify the relevant team *(alert payload prepared — delivery integration planned as next step)*

The idea is to keep everything within Azure so it's simple, integrated, and easy to manage.

---

## Automation
The core of the solution is a PowerShell Runbook.

I would schedule it to run daily, for example at 8 AM, so it consistently checks for any new activity.

Each time it runs, it:
- Queries the sign-in logs
- Filters for non-UK logins
- Pulls out useful details
- Prepares a report

From an operational perspective, this ensures the process is consistent, repeatable, and does not rely on manual intervention.

---

## KQL Query Example
```kql
SigninLogs
| where TimeGenerated > ago(30d)
| where LocationDetails.countryOrRegion != "GB"
| project UserPrincipalName, IPAddress, TimeGenerated, LocationDetails
