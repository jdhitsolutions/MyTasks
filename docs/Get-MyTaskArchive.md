---
external help file: MyTasks-help.xml
Module Name: MyTasks
online version: http://bit.ly/2PjoZBd
schema: 2.0.0
---

# Get-MyTaskArchive

## SYNOPSIS

Get tasks from archive file.

## SYNTAX

### Name (Default)

```yaml
Get-MyTaskArchive [[-Name] <String>] [<CommonParameters>]
```

### Category

```yaml
Get-MyTaskArchive [-Category <String>] [<CommonParameters>]
```

## DESCRIPTION

Assuming that you have saved tasks to the archive file, you can use this command to view the contents of that file. You can select completed tasks by name or category.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-myTaskArchive

ID  Name                      Description             Created    DueDate Completed  Category
--  ----                      -----------             -------    ------- ---------  --------
1   PSTweetChat                                      1/3/2020   1/4/2020 1/3/2020   work
2   Training followup                                1/2/2020   1/5/2020 1/3/2020   Work
3   QuickBooks                                       1/2/2020  1/15/2020 1/5/2020   Business
...
```

Display all archived tasks.

### Example 2

```powershell
PS C:\> Get-MytaskArchive -category project

ID  Name                      Description             Created    DueDate Completed  Category
--  ----                      -----------             -------    ------- ---------  --------
8   Update-PSReleaseTools                           1/11/2020  1/18/2020 1/11/2020  project
18  MyTasks                                          1/5/2020   2/4/2020 2/5/2020   Project
27  MyReminder                update module          1/3/2020   8/1/2020 10/22/2020 Project
28  MyNumber                  update module          1/3/2020   7/1/2020 10/22/2020 Project
```

Get completed tasks by category.

## PARAMETERS

### -Category

Specify one of your task categories.

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

### -Name

The name of an archived task

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### String

## OUTPUTS

### MyTaskArchive

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Save-MyTask](Save-MyTask.md)

[Complete-MyTask](Complete-MyTask.md)