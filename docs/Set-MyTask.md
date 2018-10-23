---
external help file: MyTasks-help.xml
Module Name: mytasks
online version:
schema: 2.0.0
---

# Set-MyTask

## SYNOPSIS

Modify or change a MyTask work item.

## SYNTAX

### Name (Default)

```yaml
Set-MyTask [-Name] <String> [-NewName <String>] [-Description <String>] [-DueDate <DateTime>]
 [-Progress <Int32>] [-Passthru] [-WhatIf] [-Confirm] [-Category <String>] [<CommonParameters>]
```

### Task

```yaml
Set-MyTask [-Task <MyTask>] [-NewName <String>] [-Description <String>] [-DueDate <DateTime>]
 [-Progress <Int32>] [-Passthru] [-WhatIf] [-Confirm] [-Category <String>] [<CommonParameters>]
```

### ID

```yaml
Set-MyTask [-ID <Int32>] [-NewName <String>] [-Description <String>] [-DueDate <DateTime>] [-Progress <Int32>]
 [-Passthru] [-WhatIf] [-Confirm] [-Category <String>] [<CommonParameters>]
```

## DESCRIPTION

Use this command to change a MyTask work item. You can specify a task by name or ID, although it might be just as easy to pipe from Get-MyTask.

Use Complete-MyTask to mark an item as completed.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> PS S:\> Set-MyTask -Name "Finish DSC Training" -Progress 70 -duedate "12/31/2017" -Passthru

ID  Name                      Description             DueDate OverDue Category     Progress
--  ----                      -----------             ------- ------- --------     --------
16  Finish DSC Training                            12/31/2017 False   Personal           70
```

Set the progress value and a new due date for the 'Finish DSC Training' task.

### EXAMPLE 2

```powershell
PS C:\> get-mytask -ID 9 | set-mytask -Progress 10 -Category Projects
```

Get the task with ID 9 and pipe to Set-MyTask which changes the progress value and category.

## PARAMETERS

### -Category

Set the task category.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: your defined categories

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description

Set the comment or description for the task.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DueDate

Set when the task is due for completion.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID

Enter the task ID to identify task you wish to modify.

```yaml
Type: Int32
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

Enter the name of a task to modify.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -NewName

Give the task a new name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
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

### -Progress

Set a progress completion value between 0 and 100.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Task

A task object usually piped from Get-MyTask.

```yaml
Type: MyTask
Parameter Sets: Task
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
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

### System.Int

### MyTask

## OUTPUTS

### MyTask

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-MyTask]()

[Complete-MyTask]()