---
external help file: MyTasks-help.xml
Module Name: Mytasks
online version:
schema: 2.0.0
---

# Get-MyTaskHome

## SYNOPSIS

Get current values of the myTask variables

## SYNTAX

```yaml
Get-MyTaskHome [<CommonParameters>]
```

## DESCRIPTION

The myTasks module relies on a number of global variables to keep track of the necessary files. While you can use Get-Variable to see the current value, this command simplifies the entire process.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-MyTaskHome


myTaskHome        : C:\Users\Jeff\dropbox\mytasks
myTaskPath        : C:\Users\Jeff\dropbox\mytasks\myTasks.xml
myTaskArchivePath : C:\Users\Jeff\dropbox\mytasks\myTasksArchive.xml
myTaskCategory    : C:\Users\Jeff\dropbox\mytasks\myTaskCategory.txt
```

Display the current locations. You can modify them using Set-MyTaskPath.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### myTaskPath

## NOTES

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Set-MyTaskHome]()