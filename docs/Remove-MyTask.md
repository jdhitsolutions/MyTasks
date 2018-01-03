---
external help file: MyTasks-help.xml
Module Name: MyTasks
online version: 
schema: 2.0.0
---

# Remove-MyTask

## SYNOPSIS
Remove a MyTask work item.

## SYNTAX

### Name (Default)
```
Remove-MyTask [-Name] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Object
```
Remove-MyTask -InputObject <MyTask> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Use this command to permanently delete a MyTask work item. This will permanently delete it from the task source XML file. You can remove a task by name or use Get-MyTask to pipe a task object to this command.

As an alternative to deleting tasks you can also archive them.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> remove-mytask -Name "Finish DSC Training" -whatif
What if: Performing the operation "Copy File" on target "Item: C:\Users\Jeff\Documents\myTasks.xml Destination: C:\Users
\Jeff\documents\MyTasks_Backup_201760822.xml".
What if: Performing the operation "Remove-MyTask" on target "2f252083-3c8e-4823-9c7c-df55dd0d135a".
```

The command supports Whatif.

### -------------------------- EXAMPLE 2 --------------------------
```
PS C:\> Get-myTask -Name "Finish DSC Training" | Remove-MyTask
```

Permanently deleting a task.

## PARAMETERS

### -InputObject
A myTask object from Get-MyTask
```yaml
Type: MyTask
Parameter Sets: Object
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Name
Enter task name

```yaml
Type: String
Parameter Sets: Name
Aliases: 

Required: True
Position: 0
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

### System.Guid

## OUTPUTS

### None

## NOTES
Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Save-MyTask]()
