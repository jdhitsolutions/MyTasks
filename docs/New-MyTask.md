---
external help file: MyTasks-help.xml
Module Name: mytasks
online version:
schema: 2.0.0
---

# New-MyTask

## SYNOPSIS

Create a new MyTask item

## SYNTAX

### Date (Default)

```yaml
New-MyTask [-Name] <String> [-DueDate <DateTime>] [-Description <String>] [-Passthru] [-WhatIf] [-Confirm]
 -Category <String> [<CommonParameters>]
```

### Days

```yaml
New-MyTask [-Name] <String> [-Days <Int32>] [-Description <String>] [-Passthru] [-WhatIf] [-Confirm]
 -Category <String> [<CommonParameters>]
```

## DESCRIPTION

Use this command to create a new task or work item. At a minimum you must provide a name and category. If you don't specify a deadline, either by a date or number of days, the default will be 7 days from now.

The command will not write anything to the pipeline unless you use -Passthru. If you do, ignore the task ID. You won't get a valid ID until you run Get-MyTask.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> New-MyTask -Name "Finish DSC Training" -days 30 -Category Personal -Passthru

ID  Name                      Description             DueDate OverDue Category     Progress
--  ----                      -----------             ------- ------- --------     --------
0   Finish DSC Training                             9/21/2017 False   Personal            0
```

Create a new task using the Training category that is due 30 days from now.

### EXAMPLE 2

```powershell
PS C:\> task reboot-router "1/18/2018 5:00PM" other
```

Create a task using the alias and positional parameters for the task name, due date and category.

## PARAMETERS

### -Category

A task category. The Get-MyTaskCategory command should display all available categories.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: your defined categories

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Days

The deadline for the task set this number of days from now.

```yaml
Type: Int32
Parameter Sets: Days
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description

Additional information or a brief description for your task.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DueDate

When you task is due to be completed.

```yaml
Type: DateTime
Parameter Sets: Date
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name

Enter the name of your task.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Passthru

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### MyTask

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-MyTask]()

[Get-MyTaskCategory]()

[Set-MyTask]()
