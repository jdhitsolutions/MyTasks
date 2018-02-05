---
external help file: MyTasks-help.xml
Module Name: MyTasks
online version:
schema: 2.0.0
---

# Get-EmailReminder

## SYNOPSIS
Get the email reminder job

## SYNTAX

```
Get-EmailReminder [<CommonParameters>]
```

## DESCRIPTION
Use this command to get information about email reminder job.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-EmailReminder

Task       : myTasksEmail
Frequency  : Daily
At         : 08:00:00
To         : artd@company.com
From       : artd@company.com
MailServer : smtp.company.com
Port       : 587
UseSSL     : True
AsHTML     : True
LastRun    : 2/5/2018 10:31:41 AM
LastState  : Completed
Enabled    : True
```


## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES
Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/
## RELATED LINKS
[Disable-EmailReminder]()

[Enable-EmailReminder]()