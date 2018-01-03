---
external help file: MyTasks-help.xml
Module Name: MyTasks
online version: 
schema: 2.0.0
---

# Show-MyTask

## SYNOPSIS
Display all active tasks with color highlights.

## SYNTAX

### none (Default)
```
Show-MyTask [<CommonParameters>]
```

### all
```
Show-MyTask [-All] [<CommonParameters>]
```

### Category
```
Show-MyTask [-Category <String>] [<CommonParameters>]
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
Default value: None
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
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### MyTask

## OUTPUTS

### MyTask

## NOTES

## RELATED LINKS

[Get-MyTask]()
