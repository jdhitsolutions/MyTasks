---
external help file: MyTasks-help.xml
Module Name: mytasks
online version:
schema: 2.0.0
---

# Get-MyTask

## SYNOPSIS

Get MyTask work items.

## SYNTAX

### Days (Default)

```yaml
Get-MyTask [-DaysDue <Int32>] [<CommonParameters>]
```

### Name

```yaml
Get-MyTask [[-Name] <String>] [<CommonParameters>]
```

### ID

```yaml
Get-MyTask [-ID <Int32[]>] [<CommonParameters>]
```

### All

```yaml
Get-MyTask [-All] [<CommonParameters>]
```

### Completed

```yaml
Get-MyTask [-Completed] [<CommonParameters>]
```

### Category

```yaml
Get-MyTask [-Category <String>] [<CommonParameters>]
```

## DESCRIPTION

This command reads MyTask items from the source XML file and creates a list of MyTask objects. The default behavior is to display uncompleted tasks for all categories due in the next 30 days. But you can limit the results through different parameters.

Note that the the ID property will be assigned to all tasks in the source XML file, so depending on what parameters you use, you probably won't see a consecutive list of ID numbers.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Get-MyTask

ID  Name                      Description             DueDate OverDue Category     Progress
--  ----                      -----------             ------- ------- --------     --------
2   Order books               Month of Lunches       8/1/2017 True    Personal            0
4   Apache Install            Ubuntu 16             9/13/2017 False   work               10
```

Get active tasks due in the next 30 days.

### EXAMPLE 2

```powershell
PS C:\> Get-MyTask -all

ID  Name                      Description             DueDate OverDue Category     Progress
--  ----                      -----------             ------- ------- --------     --------
1   Update Server02                                 7/14/2017 False   work              100
2   Order books               Month of Lunches       8/1/2017 True    Personal            0
3   Update Server01                                 8/30/2017 False   Work              100
4   Apache Install            Ubuntu 16             9/13/2017 False   work               10
5   2018 Training Budget                            10/1/2017 False   Personal            0
6   Conferences                                     10/7/2017 False   other               0
7   Update Server03                                10/14/2017 False   work                0
8   Finish DSC Training                            12/31/2017 False   Personal           80
```

Get all tasks including completed.

### EXAMPLE 3

```powershell
PS C:\>get-mytask -Category work

ID  Name                      Description             DueDate OverDue Category     Progress
--  ----                      -----------             ------- ------- --------     --------
4   Apache Install            Ubuntu 16             9/13/2017 False   work               10
7   Update Server03                                10/14/2017 False   work                0
```

Get all active tasks in the Work category.

### EXAMPLE 4

```powershell
PS C:\> get-mytask -daysdue 90

ID  Name                      Description             DueDate OverDue Category     Progress
--  ----                      -----------             ------- ------- --------     --------
2   Order books               Month of Lunches       8/1/2017 True    Personal            0
4   Apache Install            Ubuntu 16             9/13/2017 False   work               10
```

Get all active tasks due in the next 90 days

### EXAMPLE 5

```powershell
PS C:\> get-mytask -id 4 | format-list -View all


ID           : 4
Name         : Apache Install
Description  : Ubuntu 16
DueDate      : 9/13/2017 8:39:46 AM
Overdue      : False
Category     : work
Progress     : 10
TaskCreated  : 8/23/2017 8:39:46 AM
TaskModified : 8/23/2017 8:41:56 AM
Completed    : False
TaskID       : c6fdf70c-a2f7-42c2-8e7d-93e4faa669fd
```

Get a single task and view all properties using the custom list view

## PARAMETERS

### -All

Display all tasks from the source XML file.

```yaml
Type: SwitchParameter
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Category

Display active tasks from the specified category.

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

### -Completed

Display only completed tasks from the source XML file.

```yaml
Type: SwitchParameter
Parameter Sets: Completed
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DaysDue

Display active tasks due in the next specified number of days

```yaml
Type: Int32
Parameter Sets: Days
Aliases:

Required: False
Position: Named
Default value: 30
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID

Display a given task by its ID number.

```yaml
Type: Int32[]
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

The name of a given task.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: True
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### MyTask

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Show-MyTask]()

[New-MyTask]()

[Set-MyTask]()

[Complete-MyTask]()
