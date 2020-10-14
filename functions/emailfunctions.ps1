Function Enable-EmailReminder {
    #this function requires the PSScheduledJob module
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType("None")]

    Param(
        [Parameter(Position = 0, HelpMessage = "What time do you want to send your daily email reminder?")]
        [ValidateNotNullOrEmpty()]
        [datetime]$Time = "8:00AM",
        [Parameter(HelpMessage = "What is your email server name or address?")]
        [ValidateNotNullOrEmpty()]
        [string]$SMTPServer = $PSEmailServer,
        [Parameter(Mandatory, HelpMessage = "Enter your email address")]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("\S+@*.\.\w{2,4}")]
        [string]$To,
        [Parameter(HelpMessage = "Enter the FROM email address. If you don't specify one, the TO address will be used.")]
        [ValidatePattern("\S+@*.\.\w{2,4}")]
        [string]$From,
        [Parameter(HelpMessage = "Include if you need to use SSL?")]
        [switch]$UseSSL,
        [Parameter(HelpMessage = "Specify the port to use for your email server")]
        [ValidateNotNullOrEmpty()]
        [int32]$Port = 25,
        [Parameter(HelpMessage = "Specify any credential you need to authenticate to your mail server.")]
        [PSCredential]$MailCredential,
        [Parameter(HelpMessage = "Send an HTML body email")]
        [switch]$AsHtml,
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { $_ -gt 0 })]
        [int]$Days = 3,
        [Parameter(Mandatory, HelpMessage = "Re-enter your local user credentials for the scheduled job task")]
        [ValidateNotNullOrEmpty()]
        [PSCredential]$TaskCredential,
        [ValidateNotNullOrEmpty()]
        [string]$TaskPath = $mytaskHome
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Using these mail parameters:"

        if (-Not $From) {
            $From = $To
        }
        $hash = @{
            To         = $To
            From       = $From
            SMTPServer = $SMTPServer
            Port       = $Port
        }
        if ($MailCredential) {
            $hash.Add("Credential", $MailCredential)
        }
        If ($UseSSL) {
            $hash.add("UseSSL", $True)
        }

        $hash | Out-String | Write-Verbose
        #define the job scriptblock
        $sb = {
            Param([hashtable]$Hash, [int]$Days, [string]$myPath)
            #uncomment Write-Host lines for troubleshooting
            #$PSBoundParameters | out-string | write-host -ForegroundColor cyan
            #get tasks for the next 3 days as the body

            Set-MyTaskPath -Path $myPath
            #get-variable mytask* | out-string | Write-Host
            Write-Host "[$((Get-Date).ToString())] Getting tasks for the next $days days."
            $data = Get-MyTask -Days $Days
            if ($data) {
                if ($hash.BodyAsHTML) {
                    Write-Host "[$((Get-Date).ToString())] Sending as HTML" -ForegroundColor green
                    #css to be embedded in the html document
                    $head = @"
<Title>Upcoming Tasks</Title>
<style>
body { background-color:rgb(199, 194, 194);
    font-family:Tahoma;
    font-size:12pt; }
td, th { border:1px solid black;
            border-collapse:collapse; }
th { color:white;
        background-color:black; }
table, tr, td, th { padding: 2px; margin: 0px }
tr:nth-child(odd) {background-color: lightgray}
table { width:95%;margin-left:5px; margin-bottom:20px;}
.alert {color: red ;}
.warn {color:#ff8c00;}
</style>
<br>
<H1>My Tasks</H1>
"@
                    [xml]$html = $data | ConvertTo-Html -Fragment

                    #parse html to add color attributes
                    for ($i = 1; $i -le $html.table.tr.count - 1; $i++) {
                        $class = $html.CreateAttribute("class")
                        #check the value of the percent free memory column and assign a class to the row
                        if ($html.table.tr[$i].td[4] -eq 'True') {
                            $class.value = "alert"
                            $html.table.tr[$i].Attributes.Append($class) | Out-Null
                        }
                        elseif ((($html.table.tr[$i].td[3] -as [DateTime]) - (Get-Date)).totalHours -le 24 ) {
                            $class.value = "warn"
                            $html.table.tr[$i].Attributes.Append($class) | Out-Null
                        }
                    }

                    $Body = ConvertTo-Html -Body $html.InnerXml -Head $head | Out-String

                }
                else {
                    Write-Host "[$((Get-Date).ToString())] Sending as TEXT" -ForegroundColor Green
                    # 10/14/2020 Modified to explictly select properties because
                    # default formatting uses ANSI which distorts the converted output.
                    $body = $data | Select-Object -property ID, Name, Description, DueDate, OverDue | Format-Table | Out-String
                }
            }
            else {
                Write-Warning "No tasks found due in the next $days days."
                #bail out
                return
            }
            $hash.Add("Body", $body)
            $hash.Add("Subject", "Tasks Due in the Next $days Days")
            $hash.Add("ErrorAction", "Stop")
            Try {
                Send-MailMessage @hash
                #if you receive the job I wanted to display some sort of result
                Write-Output "[$((Get-Date).ToString())] Message ($($hash.subject)) sent to $($hash.to) from $($hash.from)"
            }
            Catch {
                throw $_
            }
        } #define scriptblock
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Testing for an existing job"
        Try {
            $job = Get-ScheduledJob -Name myTasksEmail -ErrorAction stop
            if ($job) {
                Write-Warning "An existing mail job was found. Please remove it first with Disable-EmailReminder and try again."
                #bail out
                return
            }
        }
        Catch {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] No existing job found"
        }
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Validating Requirements"
        if ((Get-Module PSScheduledJob) -And (($PSVersionTable.Platform -eq 'Win32NT') -OR ($PSVersionTable.PSEdition -eq 'Desktop'))) {

            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Creating a Daily job trigger for $($Time.TimeofDay)"
            $trigger = New-JobTrigger -Daily -At $Time

            $opt = New-ScheduledJobOption -RunElevated -RequireNetwork
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Registering the scheduled job"
            if ($AsHtml) {
                $hash.Add("BodyAsHTML", $True)
            }
            #hash table of parameters to splat Register-ScheduledJob
            $regParams = @{
                ScriptBlock        = $sb
                Name               = "myTasksEmail"
                Trigger            = $Trigger
                ArgumentList       = $hash, $Days, $TaskPath
                MaxResultCount     = 5
                ScheduledJobOption = $opt
                Credential         = $TaskCredential
            }
            $regParams | Out-String | Write-Verbose
            Register-ScheduledJob  @regParams
        }
        else {
            Write-Warning "This command requires the PSScheduledJob module on a Windows platform."
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close Enable-MailReminder

Function Disable-EmailReminder {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType("None")]

    Param()
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Processing"
        if ((Get-Module PSScheduledJob) -And (($PSVersionTable.Platform -eq 'Win32NT') -OR ($PSVersionTable.PSEdition -eq 'Desktop'))) {
            Try {
                if (Get-ScheduledJob -Name myTasksEmail -ErrorAction stop) {
                    #The cmdlet appears to ignore -WhatIf so I'll handle it myself
                    if ($PSCmdlet.ShouldProcess("myTasksEmail")) {
                        Unregister-ScheduledJob -Name myTasksEmail -ErrorAction stop
                    } #should process
                } #if task found
            }
            Catch {
                Write-Warning "Can't find any matching scheduled jobs with the name 'myTasksEmail'."
            }
        }
        else {
            Write-Warning "This command requires the PSScheduledJob module on a Windows platform."
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close Disable-EmailReminder

Function Get-EmailReminder {
    [cmdletbinding()]
    Param ()

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"

    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Getting scheduled job myTasksEmail"
        if ((Get-Module PSScheduledJob -ListAvailable) -And (($PSVersionTable.Platform -eq 'Win32NT') -OR ($PSVersionTable.PSEdition -eq 'Desktop'))) {
            Try {
                $t = Get-ScheduledJob myTasksEmail -erroraction Stop
            }
            Catch {
                Write-Warning "Could not find the Scheduled Job myTasksEmail"
            }

            if ($t) {
                $hash = $t.InvocationInfo.Parameters[0].where( { $_.name -eq "argumentlist" }).value

                Try {
                    #get the last run
                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Getting last job run"
                    $last = Get-Job -Name $t.name -Newest 1 -ErrorAction stop
                }
                Catch {
                    $last = [PSCustomObject]@{
                        PSEndTime = "11/30/1999" -as [datetime]
                        State     = "The task has not yet run"
                    }
                }
                [pscustomobject]@{
                    Task       = $t.Name
                    Frequency  = $t.JobTriggers.Frequency
                    At         = $t.JobTriggers.at.TimeOfDay
                    To         = $hash.To
                    From       = $hash.From
                    MailServer = $hash.SMTPServer
                    Port       = $hash.Port
                    UseSSL     = $hash.UseSSL
                    AsHTML     = $hash.BodyAsHTML
                    LastRun    = $last.PSEndTime
                    LastState  = $last.State
                    Started    = $last.psBeginTime
                    Ended      = $last.psEndTime
                    Result     = $last.output
                    Enabled    = $t.Enabled
                    Errors     = $last.Errors
                    Warnings   = $last.warnings
                }
            }
        }
        else {
            Write-Warning "This command requires the PSScheduledJob module on a Windows platform."
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"

    } #end

} #close Get-EmailReminder