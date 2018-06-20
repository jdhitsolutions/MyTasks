---
external help file: MyTasks-help.xml
Module Name: MyTasks
online version:
schema: 2.0.0
---

# Remove-MyTaskCategory

## SYNOPSIS

Remove a custom MyTask category.

## SYNTAX

```
Remove-MyTaskCategory [-Category] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

If you have created custom MyTask categories with Add-MyTaskCategory, and wish to delete them, use this command instead of manually modifying the MyTaskCategory.txt file. It is strongly recommended to not remove any category that is still in use with task in the source XML file. In other words, you should not remove any category if it is still being used.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Remove-MyTaskCategory ProjectX
```

Remove the ProjectX category.

## PARAMETERS

### -Category

Enter a task category name to remove.

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

[Add-MyTaskCategory]()
