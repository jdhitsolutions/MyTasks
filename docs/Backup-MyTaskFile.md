---
external help file: MyTasks-help.xml
Module Name: MyTasks
online version: http://bit.ly/2Ug1vvU
schema: 2.0.0
---

# Backup-MyTaskFile

## SYNOPSIS

Create a backup copy of the MyTask XML source file.

## SYNTAX

```yaml
Backup-MyTaskFile [[-Destination] <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Use this command to create a backup copy of the source XML file. The default behavior is to create an XML file in your Documents or Home directory with the format MyTasks_Backup_YYYYMMDD.xml. You can also specify an alternate filename.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> backup-mytaskfile -Passthru


    Directory: C:\Users\Jeff\documents


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----        8/19/2020   6:19 PM          16461 MyTasks_Backup_20200819.xml
```

Create a backup copy of the source XML file to the default location,

### EXAMPLE 2

```powershell
PS C:\> Backup-MyTaskFile -Destination c:\work\taskback.xml
```

Create a backup copy of the source XML file to the specified file.

## PARAMETERS

### -Destination

Enter the filename and path for the backup XML file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Passthru

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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

### None

## OUTPUTS

### None

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Save-MyTask](Save-MyTask.md)
