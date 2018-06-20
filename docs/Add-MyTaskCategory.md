---
external help file: MyTasks-help.xml
Module Name: MyTasks
online version:
schema: 2.0.0
---

# Add-MyTaskCategory

## SYNOPSIS

Add a custom category for MyTasks

## SYNTAX

```
Add-MyTaskCategory [-Category] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

By default the MyTasks module ships with default categories of Work, Personal, Customer and other. But you can add your own categories. They will be stored in the Documents folder in a file called MyCategory.txt. It is recommended that you use the MyTaskCategory commands to modify this file. As soon as you add a custom category, the default categories are discarded. If you wish to use them, then add them back with this command. See examples.

## EXAMPLES

### EXAMPLE 1

```
PS C:\> Add-MyTaskCategory -Category Training
```

Add a Training category.

### EXAMPLE 2

```
PS C:\> Add-MyTaskCategory -Category Other,Work,Personal,Team
PS C:\> Get-MyTaskCategory 

Training
Other
Work
Personal
Team
```

Add several categories and then display them.

## PARAMETERS

### -Category

Enter a new task category.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
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

### System.String[]

## OUTPUTS

### None

## NOTES

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-MyTaskCategory]()

[Remove-MyTaskCategory]()
