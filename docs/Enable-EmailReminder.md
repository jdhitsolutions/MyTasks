---
external help file: MyTasks-help.xml
Module Name: MyTasks
online version:
schema: 2.0.0
---

# Enable-EmailReminder

## SYNOPSIS
Enable a daily scheduled email job

## SYNTAX

```
Enable-EmailReminder [[-Time] <DateTime>] [-SMTPServer <String>] -To <String> [-From <String>] [-UseSSL]
 [-Port <Int32>] [-MailCredential <PSCredential>] [-AsHtml] -TaskCredential <PSCredential> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This command will create a daily PowerShell scheduled job to send you an email with tasks that are due in the next 3 days. The default is a text message but you can send it as HTML which will include color coding for overdue tasks.

## EXAMPLES

### Example 1
```powershell
PS C:\> Enable-EmailReminder -to artd@company.com -UseSSL -Port 587 -mailCredential artd@company.com -SMTPServer smtp.company.com -AsHtml -TaskCredential artd

```

This will enable an email job to send an HTML email to artd@company.com using the specified email settings. The From field will be the same as the To field since it wasn't specified. You have to re-enter your credentials for the TaskCredential paramter in order to access the network.

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
Default value: None
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
Enter your email address

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
### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### None

## NOTES
Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/
## RELATED LINKS
[Disable-EmailReminder]()

[Get-EmailReminder]()