---
external help file: MyTasks-help.xml
online version: 
schema: 2.0.0
---

# Remove-MyTask
## SYNOPSIS
Remove a MyTask work item.

## SYNTAX

### Name (Default)
```
Remove-MyTask [-Name] <String> [-WhatIf] [-Confirm]
```

### Guid
```
Remove-MyTask [-TaskID] <Guid> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Use this command to permanently delete a MyTask work item. This will permanently delete it from the task source XML file. You can remove a task by name or use Get-MyTask to pipe a task object to this command.

As an alternative to deleting tasks you can also archive them.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> remove-mytask -Name "Finish DSC Training" -whatif
What if: Performing the operation "Copy File" on target "Item: C:\Users\Jeff\Documents\myTasks.xml Destination: C:\Users
\Jeff\documents\MyTasks_Backup_20160822.xml".
What if: Performing the operation "Remove-MyTask" on target "2f252083-3c8e-4823-9c7c-df55dd0d135a".
```

The command supports Whatif.

### -------------------------- EXAMPLE 2 --------------------------
```
PS C:\> Get-myTask -Name "Finish DSC Training" | Remove-MyTask
```

Permanently deleting a task.
## PARAMETERS

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

### -Name
Enter task name

```yaml
Type: String
Parameter Sets: Name
Aliases: 

Required: True
Position: 0
Default value: 
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -TaskID
Enter task guid id or pipe a task to this command.

```yaml
Type: Guid
Parameter Sets: Guid
Aliases: 

Required: True
Position: 0
Default value: 
Accept pipeline input: True (ByPropertyName)
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
### System.Guid


## OUTPUTS

### None

## NOTES

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
[Save-MyTask]()
