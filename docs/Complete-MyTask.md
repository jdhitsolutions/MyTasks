---
external help file: MyTasks-help.xml
online version: 
schema: 2.0.0
---

# Complete-MyTask
## SYNOPSIS
Mark a MyTask item as completed.

## SYNTAX

### Name (Default)
```
Complete-MyTask [-Name] <String> [-Archive] [-Passthru] [-WhatIf] [-Confirm]
```

### Task
```
Complete-MyTask [-Task <MyTask>] [-Archive] [-Passthru] [-WhatIf] [-Confirm]
```

## DESCRIPTION
Use this command to mark a MyTask work item as completed. This will automatically set the progress to 100% and mark the item as completed. It will not remove it from the source XML file unless you use the -Archive parameter. This will complete the task and move it to the default archive file, myTasksArchive.xml.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> get-mytask -id 6 | Complete-MyTask -Passthru

ID  Name                      Description             DueDate OverDue Category     Progress
--  ----                      -----------             ------- ------- --------     --------
6   Update Server03                                10/14/2016 False   work              100

```

Get MyTask with an ID of 6 and mark it as complete. By default nothing is written to the pipeline unless you use -Passthru.


### -------------------------- EXAMPLE 2 --------------------------
```
PS C:\> Complete-MyTask -Name "setup CEO laptop" -archive
```

Mark the task as completed and archive it to the myTasksArchive.xml file.

## PARAMETERS

### -Archive
Move the task to the default archive file. There is no provision for specifying an alternate file.

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
Enter the name of a task.

```yaml
Type: String
Parameter Sets: Name
Aliases: 

Required: True
Position: 0
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
```

### -Passthru
{{Fill Passthru Description}}

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

### -Task
A MyTask item.

```yaml
Type: MyTask
Parameter Sets: Task
Aliases: 

Required: False
Position: Named
Default value: 
Accept pipeline input: True (ByValue)
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

### MyTask

## OUTPUTS

### None

## NOTES

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
[Set-MyTask]()
[Save-MyTask]()
