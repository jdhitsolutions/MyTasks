---
external help file: MyTasks-help.xml
online version: 
schema: 2.0.0
---

# Backup-MyTaskFile
## SYNOPSIS
Create a backup copy of the MyTask XML source file.

## SYNTAX

```
Backup-MyTaskFile [[-Destination] <String>] [-Passthru] [-WhatIf] [-Confirm]
```

## DESCRIPTION
Use this command to create a backup copy of the source XML file. The default behavior is to create an XML file in your Documents directory with the format MyTasks_Backup_YYYYMMDD.xml. You can also specify an alternate filename.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> backup-mytaskfile -Passthru


    Directory: C:\Users\Jeff\documents


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----        8/19/2016   6:19 PM          16461 MyTasks_Backup_20160819.xml
```

Create a backup copy of the source XML file to the default location,

### -------------------------- EXAMPLE 2 --------------------------
```
PS C:\> Backup-MyTaskFile -Destination c:\work\taskback.xm

```

Create a backup copy of the source XML file to specified file.

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

### -Destination
Enter the filename and path for the backup xml file.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 0
Default value: 
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
Default value: 
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
Default value: 
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### None

## OUTPUTS

### None

## NOTES

## RELATED LINKS
[Save-MyTask]()
