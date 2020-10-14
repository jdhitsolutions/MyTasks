---
external help file: MyTasks-help.xml
Module Name: MyTasks
online version: http://bit.ly/2Pmy4JE
schema: 2.0.0
---

# Disable-EmailReminder

## SYNOPSIS

Remove the task email reminder job.

## SYNTAX

```yaml
Disable-EmailReminder [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

This command will delete the scheduled email reminder job. This command is only available in Windows PowerShell.

## EXAMPLES

### Example 1

```powershell
PS C:\> Disable-EmailReminder
```

Delete the job. This command does not write anything to the pipeline.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

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

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

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

[Enable-EmailReminder](Enable-EmailReminder.md)

[Get-EmailReminder](Get-EmailReminder.md)
