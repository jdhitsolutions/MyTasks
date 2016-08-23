---
external help file: MyTasks-help.xml
online version: 
schema: 2.0.0
---

# New-MyTask
## SYNOPSIS
Create a new MyTask itemn

## SYNTAX

### Date (Default)
```
New-MyTask [-Name] <String> [-DueDate <DateTime>] [-Description <String>] [-Passthru] [-WhatIf] [-Confirm]
 -Category <String>
```

### Days
```
New-MyTask [-Name] <String> [-Days <Int32>] [-Description <String>] [-Passthru] [-WhatIf] [-Confirm]
 -Category <String>
```

## DESCRIPTION
Use this command to create a new task or work item. At a minimum you must provide a name and category. If you don't specify a deadline, either by a date or number of days, the default will be 7 days from now.

The command will not write anything to the pipeline unless you use -Passthru. If you do, ignore the task ID. You won't get a valid ID until you run Get-MyTask.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> New-MyTask -Name "Finish DSC Training" -days 30 -Category Personal -Passthru

ID  Name                      Description             DueDate OverDue Category     Progress
--  ----                      -----------             ------- ------- --------     --------
0   Finish DSC Training                             9/21/2016 False   Personal            0
```

Create a new task using the Training category that is due 30 days from now.
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
Default value: 
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Confirm

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: 
Accept pipeline input: False
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
Default value: 
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
Default value: 
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
Default value: 
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
Default value: 
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
Default value: 
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
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

### MyTask

## NOTES
Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
[Get-MyTask]()
[Get-MyTaskCategory]()
[Set-MyTask]()
