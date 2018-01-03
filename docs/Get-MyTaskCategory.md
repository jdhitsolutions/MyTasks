---
external help file: MyTasks-help.xml
Module Name: MyTasks
online version: 
schema: 2.0.0
---

# Get-MyTaskCategory

## SYNOPSIS
List MyTask categories.

## SYNTAX

```
Get-MyTaskCategory [<CommonParameters>]
```

## DESCRIPTION
Use this command to display all of the current categories for the MyTasks module. If you have added custom categories then those categories will be displayed.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Get-MyTaskCategory
Work
Personal
Other
Customer
```

Display all the current categories.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.String

## NOTES
Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Add-MyTaskCategory]()

[Remove-MyTaskCategory]()
