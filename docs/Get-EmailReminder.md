---
external help file: MyTasks-help.xml
Module Name: MyTasks
online version: http://bit.ly/2PhNtuF
schema: 2.0.0
---

# Get-EmailReminder

## SYNOPSIS

Get the email reminder job.

## SYNTAX

```yaml
Get-EmailReminder [<CommonParameters>]
```

## DESCRIPTION

Use this command to get information about the email reminder job. This command requires the PSScheduledJob module.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-EmailReminder

Task       : myTasksEmail
Frequency  : Daily
At         : 08:00:00
To         : artd@company.com
From       : artd@company.com
MailServer : mail.company.com
Port       : 587
UseSSL     : True
AsHTML     : True
LastRun    : 6/19/2020 8:00:08 AM
LastState  : Completed
Started    : 6/19/2020 8:00:06 AM
Ended      : 6/19/2020 8:00:08 AM
Result     : {[6/19/2020 8:00:08 AM] Message (Tasks Due in the Next 3 Days) sent to artd@company.com from artd@company.com}
Enabled    : True
Errors     :
Warnings   :
```

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Disable-EmailReminder](Disable-EmailReminder.md)

[Enable-EmailReminder](Enable-EmailReminder.md)
