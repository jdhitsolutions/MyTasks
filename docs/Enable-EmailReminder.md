---
external help file: MyTasks-help.xml
Module Name: mytasks
online version:
schema: 2.0.0
---

# Enable-EmailReminder

## SYNOPSIS

Enable a daily scheduled email job

## SYNTAX

```yaml
Enable-EmailReminder [[-Time] <DateTime>] [-SMTPServer <String>] -To <String> [-From <String>] [-UseSSL]
 [-Port <Int32>] [-MailCredential <PSCredential>] [-AsHtml] [-Days <Int32>] -TaskCredential <PSCredential>
 [-TaskPath <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

This command will create a daily PowerShell scheduled job to send you an email with tasks that are due in the next 3 days. You can specify a different number of days. The default mail message is a text message but you can send it as HTML which will include color coding for overdue tasks. If you are using a custom path for your tasks, be sure you have run Set-MyTaskPath first and verified the settings before enabling an email reminder.

This command requires the PSScheduledJob module.

## EXAMPLES

### Example 1

```powershell
PS C:\> Enable-EmailReminder -to artd@company.com -UseSSL -Port 587 -mailCredential artd@company.com -SMTPServer smtp.company.com -AsHtml -TaskCredential mycomputer\artd
```

This will enable an email job to send an HTML email to artd@company.com using the specified email settings. The From field will be the same as the To field since it wasn't specified. You have to re-enter your credentials for the TaskCredential parameter in order to access the network.

## PARAMETERS

### -AsHtml

Send an HTML body email

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

### -From

Enter the FROM email address. If you don't specify one, the TO address will be used.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MailCredential

Specify any credential you need to authenticate to your mail server.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port

Specify the port to use for your email server

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 25
Accept pipeline input: False
Accept wildcard characters: False
```

### -SMTPServer

What is your email server name or address?

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $PSEmailServer
Accept pipeline input: False
Accept wildcard characters: False
```

### -TaskCredential

Re-enter your local user credentials for the scheduled job task.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Time

What time do you want to send your daily email reminder?

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: 8:00AM
Accept pipeline input: False
Accept wildcard characters: False
```

### -To

Enter your email address.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseSSL

Include if you need to use SSL?

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

### -Days

Specify the number of days that tasks are due.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 3
Accept pipeline input: False
Accept wildcard characters: False
```

### -TaskPath

If you use an alternate path for task files that you normally set with Set-myTaskPath, enter it here.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $myTaskHome
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### ScheduledJob

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Disable-EmailReminder]()

[Get-EmailReminder]()