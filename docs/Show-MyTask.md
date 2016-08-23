---
external help file: MyTasks-help.xml
online version: 
schema: 2.0.0
---

# Show-MyTask
## SYNOPSIS
Display all active tasks with color highlights.

## SYNTAX

### none (Default)
```
Show-MyTask
```

### all
```
Show-MyTask [-All]
```

### Category
```
Show-MyTask [-Category <String>]
```

## DESCRIPTION
This command is very similar to Get-MyTask in terms of what it displays. However, this version writes to the console and uses Write-Host to colorize critical tasks. Those that are due in the next 24 hours will be displayed in yellow. Those that are overdue will be displayed in Red. If you use the -All parameter, any completed tasks will be displayed in Green.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Show-MyTask
```

You will get a colorized output of Get-MyTask.

### -------------------------- EXAMPLE 2 --------------------------
```
PS C:\> Show-MyTask -category Work
```

You will get a colorized output of Get-MyTask for all items in the Work category.

## PARAMETERS

### -All
Display all tasks including those that are completed.

```yaml
Type: SwitchParameter
Parameter Sets: all
Aliases: 

Required: False
Position: Named
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
```

### -Category
Display all tasks that belong to the specified category.

```yaml
Type: String
Parameter Sets: Category
Aliases: 
Accepted values: your defined categories

Required: False
Position: Named
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### MyTask

## OUTPUTS

### MyTask

## NOTES

## RELATED LINKS
[Get-MyTask]()
