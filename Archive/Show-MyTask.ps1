
#this command has been removed
Function Show-MyTask {

    #colorize output using Write-Host
    #this may not work in the PowerShell ISE

    [cmdletbinding(DefaultParameterSetName = "Days")]
    [OutputType("None")]
    [Alias("shmt")]

    Param(
        [Parameter(ParameterSetName = "all")]
        [switch]$All,
        [Parameter(ParameterSetName = "Days")]
        [int32]$DaysDue = 30
    )

    DynamicParam {
        # Set the dynamic parameters' name
        $ParameterName = 'Category'
        # Create the dictionary
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        # Create the collection of attributes
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

        # Create and set the parameters' attributes
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $false
        $ParameterAttribute.ParameterSetName = "Category"
        # Add the attributes to the attributes collection
        $AttributeCollection.Add($ParameterAttribute)

        # Generate and set the ValidateSet
        if (Test-Path -Path $global:myTaskCategory) {
            $arrSet = Get-Content -Path $global:myTaskCategory -Encoding Unicode |
                Where-Object { $_ -match "\w+" } | ForEach-Object { $_.Trim() }
        }
        else {
            $arrSet = $script:myTaskDefaultCategories
        }
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)

        # Add the ValidateSet to the attributes collection
        $AttributeCollection.Add($ValidateSetAttribute)

        # Create and return the dynamic parameter
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
        return $RuntimeParameterDictionary
    } #Dynamic Param

    Begin {
        $Category = $PsBoundParameters[$ParameterName]
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($MyInvocation.Mycommand)"

        #display PSBoundparameters formatted nicely for Verbose output
        [string]$pb = ($PSBoundParameters | Format-Table -AutoSize | Out-String).TrimEnd()
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] PSBoundparameters: `n$($pb.split("`n").Foreach({"$("`t"*4)$_"}) | Out-String) `n"
    }

    Process {
        #run Get-MyTask
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Getting Tasks"
        $tasks = Get-MyTask @PSBoundParameters
        if ($tasks.count -gt 0) {
            #convert tasks to a text table
            $table = ($tasks | Format-Table | Out-String -Stream).split("`r`n")

            #define a regular expression pattern to match the due date
            [regex]$rx = "\b\d{1,2}\/\d{1,2}\/(\d{2}|\d{4})\b"

            #Write-Host "`n"
            "`n"
            "$([char]0x1b)[38;5;51m$($table[1])$([char]0x1b)[0m"
            "$([char]0x1b)[38;5;51m$($table[2])$([char]0x1b)[0m"
            #Write-Host $table[1] -ForegroundColor Cyan
            #Write-Host $table[2] -ForegroundColor Cyan

            #define a parameter hashtable to splat to Write-Host to better
            #handle colors in the PowerShell ISE under Windows 10
            $phash = @{
                object = $Null
            }
            $table[3..$table.count] | ForEach-Object {

                #add the incoming object as the object for Write-Host
                $pHash.object = $_
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Analyzing $_ "
                #test if DueDate is within 24 hours
                if ($rx.IsMatch($_)) {
                    $hours = (($rx.Match($_).Value -as [datetime]) - (Get-Date)).totalhours
                }

                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Hours = $hours"

                #test if task is complete
                if ($_ -match '\b100\b$') {
                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Detected as completed"
                    $complete = $True
                }
                else {
                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Detected as incomplete"
                    $complete = $False
                }

                #select a different color for overdue tasks
                if ($complete) {
                    #display completed tasks in green
                    $phash.ForegroundColor = "$([char]0x1b)[92m" #"Green"
                }
                elseif ($_ -match "\bTrue\b") {
                    $phash.ForegroundColor = "$([char]0x1b)[91m" # "Red"
                }
                elseif ($hours -le 24 -AND (-Not $complete)) {
                    $phash.ForegroundColor = "$([char]0x1b)[38;5;208m" #"Yellow"
                    $hours = 999
                }
                elseif ($_ -match "^\s+") {
                    #use the existing color for tasks with wrapped descriptions
                }
                else {
                    if ($pHash.ContainsKey("ForegroundColor")) {
                        #remove foreground color so that Write-Host uses
                        #the current default
                        #  $pHash.Remove("ForegroundColor")
                        $phash.ForeGroundColor = "$([char]0x1b)[37m"
                    }
                }

                # Write-Host @pHash
                "{0}{1}{2}" -f $phash.ForegroundColor, $phash.object, "$([char]0x1b)[0m"

            } #foreach
        } #if tasks are found
        else {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] No tasks returned from Get-MyTask."
        }
    } #Process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($MyInvocation.Mycommand)"
    } #End
} #Show-MyTask