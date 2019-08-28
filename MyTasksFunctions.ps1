
#region class definition

Class MyTask {

    <#
    A class to define a task or to-do item
    #>

    #Properties
    # ID and OverDue values are calculated at run time.

    [int]$ID
    [string]$Name
    [string]$Description
    [datetime]$DueDate
    [bool]$Overdue
    [String]$Category
    [ValidateRange(0, 100)][int]$Progress
    hidden[bool]$Completed
    hidden[datetime]$TaskCreated = (Get-Date)
    hidden[datetime]$TaskModified
    hidden[guid]$TaskID = (New-Guid)

    #Methods

    #set task as completed

    [void]CompleteTask([datetime]$CompletedDate) {
        write-verbose "[CLASS  ] Completing task: $($this.name)"
        $this.Completed = $True
        $this.Progress = 100
        $this.Overdue = $False
        $this.TaskModified = $CompletedDate
    }

    #check if task is overdue and update
    hidden [void]Refresh() {
        Write-Verbose "[CLASS  ] Refreshing task $($this.name)"
        #only mark as overdue if not completed and today is greater than the due date
        Write-Verbose "[CLASS  ] Comparing $($this.DueDate) due date to $(Get-Date)"

        if ($This.completed) {
            $this.Overdue = $False
        }
        elseif ((Get-Date) -gt $this.DueDate) {
            $this.Overdue = $True
        }
        else {
            $this.Overdue = $False
        }

    } #refresh

    #Constructors
    MyTask([string]$Name) {
        write-verbose "[CLASS  ] Constructing with name: $name"
        $this.Name = $Name
        $this.DueDate = (Get-Date).AddDays(7)
        $this.TaskModified = (Get-Date)
        $this.Refresh()
    }
    #used for importing from XML
    MyTask([string]$Name, [datetime]$DueDate, [string]$Description, [string]$Category, [boolean]$Completed) {
        write-verbose "[CLASS  ] Constructing with due date, description and category"
        $this.Name = $Name
        $this.DueDate = $DueDate
        $this.Description = $Description
        $this.Category = $Category
        $this.TaskModified = $this.TaskCreated
        $this.Completed = $completed
        $this.Refresh()
    }

} #end class definition

#endregion

#this is a private function to the module
Function _ImportTasks {
    [cmdletbinding()]
    Param([string]$Path = $myTaskpath)

    If (Test-Path $myTaskpath) {
        [xml]$In = Get-Content -Path $Path -Encoding UTF8

    }
    else {
        Write-Warning "There are no tasks. Create a new one first."
        #bail out
        Break
    }
    foreach ($obj in $in.Objects.object) {
        $obj.Property | ForEach-Object -Begin {$propHash = [ordered]@{}} -Process {
            $propHash.Add($_.name, $_.'#text')
        }
        $propHash | Out-String | Write-Verbose
        Try {
            $tmp = New-Object -TypeName MyTask -ArgumentList $propHash.Name, $propHash.DueDate, $propHash.Description, $propHash.Category, $propHash.completed

            #set additional properties
            $tmp.TaskID = $prophash.TaskID
            $tmp.Progress = $prophash.Progress -as [int]
            $tmp.TaskCreated = $prophash.TaskCreated -as [datetime]
            $tmp.TaskModified = $prophash.TaskModified -as [datetime]
            $tmp.Completed = [Convert]::ToBoolean($prophash.Completed)

            $tmp.refresh()
            $tmp
        }
        Catch {
            Write-Error $_
        }

    } #foreach

} #_ImportTasks

# region exported functions
Function New-MyTask {

    [cmdletbinding(SupportsShouldProcess, DefaultParameterSetName = "Date")]
    [OutputType("MyTask")]
    [Alias("nmt", "task")]

    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Enter the name of your task",
            ValueFromPipelineByPropertyName
        )]
        [string]$Name,

        [Parameter(Position = 1, ValueFromPipelineByPropertyName, ParameterSetName = "Date")]
        [ValidateNotNullorEmpty()]
        [dateTime]$DueDate = (Get-Date).AddDays(7),

        [Parameter(ParameterSetName = "Days")]
        [int]$Days,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Description,

        [switch]$Passthru
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
        $ParameterAttribute.Mandatory = $true
        $ParameterAttribute.ValueFromPipelineByPropertyName = $True
        $ParameterAttribute.Position = 2

        # Add the attributes to the attributes collection
        $AttributeCollection.Add($ParameterAttribute)

        # Generate and set the ValidateSet
        if (Test-Path -Path $global:myTaskCategory) {
            $arrSet = Get-Content -Path $global:myTaskCategory |
                Where-Object {$_ -match "\w+"} | ForEach-Object {$_.Trim()}
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
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting: $($MyInvocation.Mycommand)"
        #display PSBoundparameters formatted nicely for Verbose output
        [string]$pb = ($PSBoundParameters | Format-Table -AutoSize | Out-String).TrimEnd()
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] PSBoundparameters: `n$($pb.split("`n").Foreach({"$("`t"*4)$_"}) | Out-String) `n"
    }

    Process {
        #display PSBoundparameters formatted nicely for Verbose output
        [string]$pb = ($PSBoundParameters | Format-Table -AutoSize | Out-String).TrimEnd()
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] PSBoundparameters: `n$($pb.split("`n").Foreach({"$("`t"*4)$_"}) | Out-String) `n"

        Write-Verbose "$((Get-Date).TimeofDay) [PROCESS] Using Parameter set: $($pscmdlet.parameterSetName)"

        #create the new task
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Creating new task $Name"

        If ($Days) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Calculating due date in $Days days"
            $DueDate = (Get-Date).AddDays($Days)
        }
        $task = New-Object -TypeName MyTask -ArgumentList $Name, $DueDate, $Description, $Category, $False

        #convert to xml
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Converting to XML"
        $newXML = $task |
            Select-object -property Name,
        Description,
        @{Name = 'DueDate'; Expression = {Get-Date -Date $task.DueDate -Format 's'}},
        Category,
        Progress,
        @{Name = 'TaskCreated'; Expression = {Get-Date -Date $task.TaskCreated -Format 's'}},
        @{Name = 'TaskModified'; Expression = {Get-Date -Date $task.TaskModified -Format 's'}},
        TaskID,
        Completed  |  ConvertTo-Xml

        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($newXML | out-string)"

        #add task to disk via XML file
        if (Test-Path -Path $mytaskPath) {

            #import xml file
            [xml]$in = Get-Content -Path $mytaskPath -Encoding UTF8

            #continue of there are existing objects in the file
            if ($in.objects) {
                #check if TaskID already exists in file and skip
                $id = $task.TaskID
                $result = $in | Select-XML -XPath "//Object/Property[text()='$id']"
                if (-Not $result.node) {
                    #if not,import node
                    $imp = $in.ImportNode($newXML.objects.object, $true)

                    #append node
                    $in.Objects.AppendChild($imp) | Out-Null
                    #update file

                    if ($PSCmdlet.ShouldProcess($task.name)) {
                        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Saving to existing file"
                        #need to save to a filesystem path
                        # $save = Convert-Path $mytaskPath
                        $in.Save($myTaskPath)
                    }
                }
                else {
                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Skipping $id"
                }
            } #if $in.objects
        }
        else {
            #If file doesn't exist create task and save to a file
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Saving first task"
            #must be an empty XML file
            if ($PSCmdlet.ShouldProcess($task.name)) {
                #create an XML declaration section
                write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Creating XML declaration"
                $declare = $newxml.CreateXmlDeclaration("1.0", "UTF-8", "yes")

                #replace declaration
                $newXML.ReplaceChild($declare, $newXML.FirstChild) | Out-Null
                #save the file
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Saving the new file to $myTaskPath"
                #need to save to a filesystem path
                # $save = Convert-Path $mytaskPath
                $newxml.Save($myTaskPath)
            }
        }

        If ($Passthru) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Passing object to the pipeline."
            (get-mytask).where( {$_.taskID -eq $task.taskid})
        }

    } #Process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending: $($MyInvocation.Mycommand)"
    } #end

} #New-MyTask

Function Set-MyTask {

    [cmdletbinding(SupportsShouldProcess, DefaultParameterSetName = "Name")]
    [OutputType("None", "MyTask")]
    [Alias("smt")]

    Param (
        [Parameter(
            ParameterSetName = "Task",
            ValueFromPipeline)]
        [MyTask]$Task,

        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Enter the name of a task",
            ParameterSetName = "Name",
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullorEmpty()]
        [string]$Name,
        [Parameter(ParameterSetName = "ID")]
        [int]$ID,
        [string]$NewName,
        [string]$Description,
        [datetime]$DueDate,
        [ValidateRange(0, 100)]
        [int]$Progress,
        [switch]$Passthru

    )

    DynamicParam {
        # Set the dynamic parameters' name
        $ParameterName = "Category"
        # Create the dictionary
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        # Create the collection of attributes
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

        # Create and set the parameters' attributes
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False

        # Add the attributes to the attributes collection
        $AttributeCollection.Add($ParameterAttribute)

        # Generate and set the ValidateSet
        if (Test-Path -Path $global:myTaskCategory) {
            $arrSet = Get-Content -Path $global:myTaskCategory -Encoding Unicode | Where-Object {$_ -match "\w+"} | ForEach-Object {$_.Trim()}
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
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting: $($MyInvocation.Mycommand)"
        #display PSBoundparameters formatted nicely for Verbose output
        [string]$pb = ($PSBoundParameters | format-table -AutoSize | Out-String).TrimEnd()
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] PSBoundparameters: `n$($pb.split("`n").Foreach({"$("`t"*4)$_"}) | Out-String) `n"

        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Cleaning PSBoundParameters"
        $PSBoundParameters.Remove("Verbose")  | Out-Null
        $PSBoundParameters.Remove("WhatIf")   | Out-Null
        $PSBoundParameters.Remove("Confirm")  | Out-Null
        $PSBoundParameters.Remove("Passthru") | Out-Null
        $PSBoundParameters.Remove("ID") | Out-Null

    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Using parameter set: $($PSCmdlet.ParameterSetName)"

        #remove this as a bound parameter
        $PSBoundParameters.Remove("Task") | Out-Null

        [string]$pb = ($PSBoundParameters | Format-Table -AutoSize | Out-String).TrimEnd()
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] PSBoundparameters: `n$($pb.split("`n").Foreach({"$("`t"*4)$_"}) | Out-String) `n"

        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Processing XML"
        Try {
            [xml]$In = Get-Content -Path $MyTaskPath -ErrorAction Stop -Encoding UTF8
        }
        Catch {
            Write-Error "There was a problem loading task data from $myTaskPath."
            #abort and bail out
            return
        }

        #if using a name get the task from the XML file
        if ($Name) {
            $node = ($in | Select-xml -XPath "//Object/Property[@Name='Name' and contains(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'$($name.toLower())')]").Node.ParentNode
        }
        else {
            if ($ID) {
                #get the task by ID
                $task = Get-MyTask -id $ID
            }
            $node = ($in | Select-xml -XPath "//Object/Property[@Name='TaskID' and text()='$($task.taskid)']").Node.ParentNode
        }

        if (-Not $Node) {
            Write-Warning "Failed to find task: $Name"
            #abort and bail out
            return
        }

        $taskName = $node.SelectNodes("Property[@Name='Name']").'#text'
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Updating task $taskName"
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($node.property | Out-String)"

        #go through all PSBoundParameters other than Name or NewName

        $PSBoundParameters.keys | Where-Object {$_ -notMatch 'name'} | ForEach-Object {
            #update the task property
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Updating $_ to $($PSBoundParameters.item($_))"
            $setting = $node.SelectSingleNode("Property[@Name='$_']")
            if ($_ -in 'DueDate', 'TaskCreated', 'TaskModified') {
                $setting.InnerText = Get-Date -Date ($PSBoundParameters.item($_)) -Format 's'
            }
            else {
                $setting.InnerText = $PSBoundParameters.item($_) -as [string]
            }
        }

        If ($NewName) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Updating to new name: $NewName"
            $node.SelectSingleNode("Property[@Name='Name']").'#text' = $NewName
        }

        #update TaskModified
        $node.SelectSingleNode("Property[@Name='TaskModified']").'#text' = (Get-Date -Format 's').ToString()

        If ($PSCmdlet.ShouldProcess($TaskName)) {
            #update source
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Saving task file"
            #need to save to a filesystem path
            #$save = Convert-Path $mytaskPath
            $in.Save($mytaskpath)

            #pass object to the pipeline
            if ($Passthru) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Passing object to the pipeline"
                Get-MyTask -Name $taskName
            }
        } #should process
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending: $($MyInvocation.Mycommand)"
    } #end
} #Set-MyTask

Function Remove-MyTask {
    [cmdletbinding(SupportsShouldProcess, DefaultParameterSetName = "Name")]
    [OutputType("None")]
    [Alias("rmt")]

    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Enter task name",
            ParameterSetName = "Name"
        )]
        [ValidateNotNullorEmpty()]
        [string]$Name,

        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Enter a task ID number",
            ParameterSetName = "ID"
        )]
        [int]$ID,

        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            ParameterSetName = "Object"
        )]
        [ValidateNotNullorEmpty()]
        [MyTask]$InputObject
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting: $($MyInvocation.Mycommand)"
        #display PSBoundparameters formatted nicely for Verbose output
        [string]$pb = ($PSBoundParameters | Format-Table -AutoSize | Out-String).TrimEnd()
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] PSBoundparameters: `n$($pb.split("`n").Foreach({"$("`t"*4)$_"}) | Out-String) `n"

        if ($PSCmdlet.ShouldProcess($myTaskPath, "Create backup")) {
            Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Creating a backup copy of $myTaskPath"
            Backup-MyTaskFile
        }

        #load tasks from XML
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Loading tasks from XML"
        [xml]$In = Get-Content -Path $MyTaskPath -Encoding UTF8
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Using parameter set: $($PSCmdlet.parameterSetname)"

        Switch ($pscmdlet.ParameterSetName) {
            "Name" {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Retrieving task: $Name"
                Try {
                    $taskID = (Get-MyTask -Name $Name -ErrorAction Stop).TaskID
                }
                Catch {
                    Write-Warning "Failed to find a task with a name of $Name"
                    write-warning $_.exception.message
                    #abort and bail out
                    return
                }
            } #Name
            "ID" {
                $TaskID = (Get-MyTask -id $ID).TaskID
                if (-Not $TaskID) {
                    #bail out
                    return
                }
            } #ID
            "Object" {
                $TaskID = $InputObject.TaskID
            }
        }
        #select node by TaskID (GUID)

        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Identifying task id: $TaskID"
        $node = ($in | Select-Xml -XPath "//Object/Property[text()='$TaskID']").node.ParentNode

        if ($node) {
            #remove it
            write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Removing: $($node.Property | Out-String)"

            if ($PSCmdlet.ShouldProcess($TaskID)) {
                $node.parentNode.RemoveChild($node) | Out-Null

                $node.ParentNode.objects
                #save file
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Updating $MyTaskPath"
                #need to save to a filesystem path
                # $save = Convert-Path $mytaskPath
                $in.Save($mytaskpath)
            } #should process
        }
        else {
            Write-Warning "Failed to find a matching task with an id of $TaskID"
            Return
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending: $($MyInvocation.Mycommand)"
    } #end

} #Remove-MyTask

Function Get-MyTask {
    [cmdletbinding(DefaultParameterSetName = "Days")]
    [OutputType("MyTask")]
    [Alias("gmt")]

    Param(
        [Parameter(
            Position = 0,
            ParameterSetName = "Name"
        )]
        [string]$Name,
        [Parameter(ParameterSetName = "ID")]
        [int[]]$ID,
        [Parameter(ParameterSetName = "All")]
        [switch]$All,
        [Parameter(ParameterSetName = "Completed")]
        [switch]$Completed,
        [Parameter(ParameterSetName = "Days")]
        [int]$DaysDue = 30
    )

    DynamicParam {
        # Set the dynamic parameters' name
        $ParameterName = "Category"
        # Create the dictionary
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        # Create the collection of attributes
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

        # Create and set the parameters' attributes
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $ParameterAttribute.ParameterSetName = "Category"

        # Add the attributes to the attributes collection
        $AttributeCollection.Add($ParameterAttribute)

        # Generate and set the ValidateSet
        if (Test-Path -Path $global:myTaskCategory) {
            $arrSet = Get-Content -Path $global:myTaskCategory | Where-Object {$_ -match "\w+"} | ForEach-Object {$_.Trim()}
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

    }
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($MyInvocation.Mycommand)"
        $Category = $PsBoundParameters[$ParameterName]
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Using parameter set $($PSCmdlet.ParameterSetName)"
        #display PSBoundparameters formatted nicely for Verbose output
        [string]$pb = ($PSBoundParameters | Format-Table -AutoSize | Out-String).TrimEnd()
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] PSBoundparameters: `n$($pb.split("`n").Foreach({"$("`t"*4)$_"}) | Out-String) `n"

        #import from the XML file
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Importing tasks from $mytaskPath"
        $tasks = _ImportTasks | Sort-Object -property DueDate

        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Imported $($tasks.count) tasks"
    }

    Process {
        #initialize counter
        $counter = 0
        foreach ($task in $tasks ) {
            $counter++
            $task.ID = $counter
        }

        Switch ($PSCmdlet.ParameterSetName) {

            "Name" {
                if ($Name -match "\w+") {
                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Retrieving task: $Name"
                    $results = $tasks.Where( {$_.Name -like $Name})
                }
                else {
                    #write all tasks to the pipeline
                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Retrieving all incomplete tasks"
                    $results = $tasks.Where( {-Not $_.Completed})
                }
            } #name

            "ID" {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Retrieving Task by ID: $ID"
                #$results = $tasks.where( {$_.id -eq $ID})
                $results = $tasks.where( {$_.id -match "^($($id -join '|'))$" })
            } #id

            "All" {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Retrieving all tasks"
                $results = $Tasks
            } #all

            "Completed" {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Retrieving completed tasks"
                $results = $tasks.Where( {$_.Completed})
            } #completed

            "Category" {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Retrieving tasks for category $Category"
                $results = $tasks.Where( {$_.Category -eq $Category -AND (-Not $_.Completed)})
            } #category

            "Days" {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Retrieving tasks due in $DaysDue days or before"
                $results = $tasks.Where( {($_.DueDate -le (Get-Date).AddDays($DaysDue)) -AND (-Not $_.Completed)})
            }
        } #switch

        #display tasks if found otherwise display a warning
        if ($results.count -ge 1) {
            $results
        }
        else {
            Write-Warning "No tasks found matching your criteria"
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($MyInvocation.Mycommand)"
    } #end

} #Get-MyTask

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
                Where-Object {$_ -match "\w+"} | ForEach-Object {$_.Trim()}
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

            Write-Host "`n"
            Write-Host $table[1] -ForegroundColor Cyan
            Write-Host $table[2] -ForegroundColor Cyan

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
                    $phash.ForegroundColor = "Green"
                }
                elseif ($_ -match "\bTrue\b") {
                    $phash.ForegroundColor = "Red"
                }
                elseif ($hours -le 24 -AND (-Not $complete)) {
                    $phash.ForegroundColor = "Yellow"
                    $hours = 999
                }
                elseif ($_ -match "^\s+") {
                    #use the existing color for tasks with wrapped descriptions
                }
                else {
                    if ($pHash.ContainsKey("ForegroundColor")) {
                        #remove foreground color so that Write-Host uses
                        #the current default
                        $pHash.Remove("ForegroundColor")
                    }
                }

                Write-Host @pHash

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

Function Complete-MyTask {

    [cmdletbinding(SupportsShouldProcess, DefaultParameterSetName = "Name")]
    [OutputType("None", "MyTask")]
    [Alias("cmt")]

    Param (
        [Parameter(
            ParameterSetName = "Task",
            ValueFromPipeline)]
        [MyTask]$Task,

        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Enter the name of a task",
            ParameterSetName = "Name"
        )]
        [ValidateNotNullorEmpty()]
        [string]$Name,

        [Parameter(
            Mandatory,
            HelpMessage = "Enter the task ID",
            ParameterSetName = "ID"
        )]
        [int32]$ID,

        [datetime]$CompletedDate = $(Get-Date),

        [switch]$Archive,

        [switch]$Passthru
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting: $($MyInvocation.Mycommand)"
        #display PSBoundparameters formatted nicely for Verbose output
        [string]$pb = ($PSBoundParameters | Format-Table -AutoSize | Out-String).TrimEnd()
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] PSBoundParameters: `n$($pb.split("`n").Foreach({"$("`t"*4)$_"}) | Out-String) `n"

    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Using parameter set: $($PSCmdlet.ParameterSetName)"
        #display PSBoundparameters formatted nicely for Verbose output
        [string]$pb = ($PSBoundParameters | Format-Table -AutoSize | Out-String).TrimEnd()
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] PSBoundParameters: `n$($pb.split("`n").Foreach({"$("`t"*4)$_"}) | Out-String) `n"

        if ($Name) {
            #get the task
            Try {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Retrieving task: $Name"
                $Task = Get-MyTask -Name $Name -ErrorAction Stop
            }
            Catch {
                Write-Error $_
                #bail out
                Return
            }
        }
        elseif ($ID) {
            #get the task
            Try {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Retrieving task ID: $ID"
                $Task = Get-MyTask -ID $ID -ErrorAction Stop
            }
            Catch {
                Write-Error $_
                #bail out
                Return
            }
        }

        If ($Task) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Marking task as completed"
            #invoke CompleteTask() method
            $task.CompleteTask($CompletedDate)
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($task | Select-Object *,Completed,TaskModified,TaskID | Out-String)"

            #find matching XML node and replace it
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Updating task file"
            #convert current task to XML
            $new = ($task | Select-object -property Name,
                Description,
                @{Name = 'DueDate'; Expression = {Get-Date -Date $task.DueDate -Format 's'}},
                Category,
                Progress,
                @{Name = 'TaskCreated'; Expression = {Get-Date -Date $task.TaskCreated -Format 's'}},
                @{Name = 'TaskModified'; Expression = {Get-Date -Date $task.TaskModified -Format 's'}},
                TaskID,
                Completed | ConvertTo-Xml).Objects.Object

            #load tasks from XML
            [xml]$In = Get-Content -Path $MyTaskPath -Encoding UTF8

            #select node by TaskID (GUID)
            $node = ($in | Select-Xml -XPath "//Object/Property[text()='$($task.TaskID)']").node.ParentNode

            #import the new node
            $imp = $in.ImportNode($new, $true)

            #replace node
            $node.ParentNode.ReplaceChild($imp, $node) | Out-Null

            #save
            If ($PSCmdlet.ShouldProcess($task.name)) {
                #$save = Convert-Path $mytaskPath

                $in.Save($mytaskpath)

                if ($Archive) {
                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Archiving completed task"
                    Save-MyTask -Task $Task
                }

                if ($Passthru) {
                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Passing task back to the pipeline"
                    Get-MyTask -Name $task.name
                }
            }
        }
        else {
            Write-Warning "Failed to find a matching task."
        }
    } #process


    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending: $($MyInvocation.Mycommand)"
    } #end

} #Complete-MyTask

Function Get-MyTaskCategory {
    [cmdletbinding()]
    [OutputType([System.String])]

    Param()

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting: $($MyInvocation.Mycommand)"

    } #begin
    Process {
        If (Test-Path -Path $global:myTaskCategory) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Retrieving user categories from $global:myTaskCategory"
            Get-Content -Path $global:myTaskCategory -Encoding Unicode | Where-Object {$_ -match "\w+"}
        }
        else {
            #Display the defaults
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Retrieving module default categories"
            $script:myTaskDefaultCategories
        }
    } #process
    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending: $($MyInvocation.Mycommand)"
    } #end
}

Function Add-MyTaskCategory {

    [cmdletbinding(SupportsShouldProcess)]
    [OutputType("None")]

    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Enter a new task category",
            ValueFromPipeline
        )]
        [ValidateNotNullorEmpty()]
        [string[]]$Category
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting: $($MyInvocation.Mycommand)"
        #test if user category file already exists and if not, then
        #create it
        if (-Not (Test-Path -Path $global:myTaskCategory)) {
            Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Creating new user category file $global:myTaskCategory"
            Set-Content -Value $script:myTaskDefaultCategories -Path $global:myTaskCategory -Encoding Unicode
        }
        #get current contents
        $current = Get-Content -Path $global:myTaskCategory -Encoding Unicode | Where-Object {$_ -match "\w+"}
    } #begin

    Process {
        foreach ($item in $Category) {
            if ($current -contains $($item.trim())) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Skipping duplicate item $item"
            }
            else {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Adding $item"
                Add-Content -Value $item.Trim() -Path $global:myTaskCategory -Encoding Unicode
            }
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending: $($MyInvocation.Mycommand)"
    } #end
}

Function Remove-MyTaskCategory {

    [cmdletbinding(SupportsShouldProcess)]
    [OutputType("None")]

    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Enter a task category to remove",
            ValueFromPipeline
        )]
        [ValidateNotNullorEmpty()]
        [string[]]$Category
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting: $($MyInvocation.Mycommand)"

        #get current contents
        $current = Get-Content -Path $global:myTaskCategory -Encoding Unicode| Where-Object {$_ -match "\w+"}
        #create backup
        $back = Join-Path -path $mytaskhome -ChildPath MyTaskCategory.bak
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Creating backup copy"
        Copy-Item -Path $global:myTaskCategory -Destination $back -Force
    } #begin

    Process {
        foreach ($item in $Category) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Removing category $item"
            $current = ($current).Where( {$_ -notcontains $item})
        }

    } #process

    End {
        #update file
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Updating: $global:myTaskCategory"
        Set-Content -Value $current -Path $global:myTaskCategory -Encoding Unicode
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending: $($MyInvocation.Mycommand)"
    } #end
}

#create a backup copy of task xml file
Function Backup-MyTaskFile {

    [cmdletbinding(SupportsShouldProcess)]
    [OutputType("None", "System.IO.FileInfo")]

    Param(
        [Parameter(
            Position = 0,
            HelpMessage = "Enter the filename and path for the backup xml file"
        )]
        [ValidateNotNullorEmpty()]
        [string]$Destination = (Join-Path -Path $mytaskhome -ChildPath "MyTasks_Backup_$(Get-Date -format "yyyyMMdd").xml" ),
        [switch]$Passthru

    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting: $($MyInvocation.Mycommand)"
        #display PSBoundparameters formatted nicely for Verbose output
        [string]$pb = ($PSBoundParameters | Format-Table -AutoSize | Out-String).TrimEnd()
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] PSBoundparameters: `n$($pb.split("`n").Foreach({"$("`t"*4)$_"}) | Out-String) `n"
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Creating backup file $Destination"

        #add MyTaskPath to PSBoundparameters so it can be splatted to Copy-Item
        $PSBoundParameters.Add("Path", $myTaskPath)

        #explicitly add Destination if not already part of PSBoundParameters
        if (-Not ($PSBoundParameters.ContainsKey("Destination"))) {
            $PSBoundParameters.Add("Destination", $Destination)
        }
    } #begin

    Process {
        If (Test-Path -Path $myTaskPath) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Copy parameters"
            Write-Verbose ($PSBoundParameters | format-list | Out-String)
            Copy-Item @psBoundParameters

            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Adding comment to backup XML file"
            #insert a comment into the XML file
            [xml]$doc = Get-Content -Path $Destination -Encoding UTF8
            $comment = $doc.CreateComment("Backup of $MytaskPath created on $(Get-Date)")
            $doc.InsertAfter($comment, $doc.FirstChild) | Out-Null
            $doc.Save($Destination)
        }
        else {
            Write-Warning "Failed to find $myTaskPath"
        }

    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending: $($MyInvocation.Mycommand)"
    } #end

}

#archive completed tasks
Function Save-MyTask {

    [cmdletbinding(SupportsShouldProcess)]
    [OutputType("None", "myTask")]
    [Alias("Archive-MyTask")]

    Param(
        [Parameter(Position = 0)]
        [ValidateNotNullorEmpty()]
        [string]$Path = $myTaskArchivePath,

        [Parameter(ValueFromPipeline)]
        [ValidateNotNullorEmpty()]
        [MyTask[]]$Task,

        [switch]$Passthru

    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting: $($MyInvocation.Mycommand)"
        #display PSBoundparameters formatted nicely for Verbose output
        [string]$pb = ($PSBoundParameters | Format-Table -AutoSize | Out-String).TrimEnd()
        Write-Verbose "[$((Get-Date).TimeofDay) EGIN  ] PSBoundparameters: `n$($pb.split("`n").Foreach({"$("`t"*4)$_"}) | Out-String) `n"
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Using parameter set $($PSCmdlet.ParameterSetName)"

    }

    Process {

        [xml]$In = Get-Content -Path $mytaskPath -Encoding UTF8

        if ($Task) {
            $taskID = $task.TaskID
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Archiving task $($task.name) [$($task.taskID)]"
            $completed = $in.Objects | Select-XML -XPath "//Object/Property[text()='$taskID']"
        }
        else {
            #get completed tasks
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Getting completed tasks"

            $completed = $In.Objects | Select-XML -XPath "//Property[@Name='Completed' and text()='True']"
        }
        if ($completed) {
            #save to $myTaskArchivePath
            if (Test-Path -Path $Path) {
                #append to existing document
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Appending to $Path"
                [xml]$Out = Get-Content -Path $Path -Encoding UTF8
                $parent = $Out.Objects
            }
            else {
                #create a new document
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Creating $Path"
                $out = [xml]::new()
                $ver = $out.CreateXmlDeclaration("1.0", "UTF-8", $null)
                $out.AppendChild($ver) | Out-Null
                $objects = $out.CreateNode("element", "Objects", $null)
                $parent = $out.AppendChild($objects)
            }

            #import
            foreach ($node in $completed.node) {
                $imp = $out.ImportNode($node.ParentNode, $True)
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Archiving $($node.parentnode.property[0].'#text')"
                if ($PSCmdlet.ShouldProcess( $($node.parentnode.property[0].'#text') , "Archiving")) {
                    $parent.AppendChild($imp) | Out-Null
                    #remove from existing file
                    $in.objects.RemoveChild($node.parentnode) | Out-Null
                }
            }

            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Saving $Path"
            if ($PSCmdlet.ShouldProcess($Path)) {
                $out.Save($Path)

                #save task file after saving archive
                #need to save to a filesystem path
                #$save = Convert-Path $mytaskPath
                $in.Save($mytaskpath)
                If ($Passthru) {
                    Get-Item -Path $Path
                }
            }
        }
        else {
            Write-Host "Didn't find any completed tasks." -ForegroundColor Magenta
        }
    } #Process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending: $($MyInvocation.Mycommand)"
    }
}


Function Set-MyTaskHome {
    [cmdletbinding(SupportsShouldProcess)]
    [alias("Set-MyTaskPath")]
    [OutputType("None", [System.Management.Automation.PSVariable])]

    Param(
        [Parameter(Mandatory, HelpMessage = "Enter the path to your new myTaskHome directory")]
        [ValidateScript( {Test-Path $_})]
        [string]$Path,
        [switch]$Passthru
    )

    If ($pscmdlet.ShouldProcess("$path", "Update task path")) {
        $global:mytaskhome = Convert-Path $Path

        #path to the category file
        $global:myTaskCategory = Join-Path -Path $mytaskhome -ChildPath myTaskCategory.txt

        #path to stored tasks
        $global:mytaskPath = Join-Path -Path $mytaskhome -ChildPath myTasks.xml

        #path to archived or completed tasks
        $global:myTaskArchivePath = Join-Path -Path $mytaskhome -ChildPath myTasksArchive.xml

        if ($passthru) {
            Get-Variable myTaskHome, myTaskPath, myTaskArchivePath, myTaskCategory
        }
    }
} #close Set-MyTaskPath

Function Get-MyTaskHome {
    [cmdletbinding()]
    [Alias("Get-MyTaskPath")]
    Param()

    [PSCustomObject]@{
        PSTypeName = "myTaskPath"
        myTaskHome        = $global:mytaskhome
        myTaskPath        = $global:myTaskPath
        myTaskArchivePath = $global:myTaskArchivePath
        myTaskCategory    = $global:myTaskCategory
    }
}


Function Get-MyTaskArchive {
    [cmdletbinding(DefaultParameterSetName = "Name")]
    [OutputType("MyTaskArchive")]


    Param(
        [Parameter(
            Position = 0,
            ParameterSetName = "Name"
        )]
        [string]$Name
    )

    DynamicParam {
        # Set the dynamic parameters' name
        $ParameterName = "Category"
        # Create the dictionary
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        # Create the collection of attributes
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

        # Create and set the parameters' attributes
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $False
        $ParameterAttribute.ParameterSetName = "Category"

        # Add the attributes to the attributes collection
        $AttributeCollection.Add($ParameterAttribute)

        # Generate and set the ValidateSet
        if (Test-Path -Path $global:myTaskCategory) {
            $arrSet = Get-Content -Path $global:myTaskCategory | Where-Object {$_ -match "\w+"} | ForEach-Object {$_.Trim()}
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

    }
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($MyInvocation.Mycommand)"
        $Category = $PsBoundParameters[$ParameterName]
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Using parameter set $($PSCmdlet.ParameterSetName)"
        #display PSBoundparameters formatted nicely for Verbose output
        [string]$pb = ($PSBoundParameters | Format-Table -AutoSize | Out-String).TrimEnd()
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] PSBoundparameters: `n$($pb.split("`n").Foreach({"$("`t"*4)$_"}) | Out-String) `n"

        #import from the XML file
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Importing tasks from $mytaskPath"
        $tasks = _ImportTasks -Path $myTaskArchivePath | Sort-Object -property {$_.TaskModified -as [datetime]}

        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Imported $($tasks.count) tasks"
    }

    Process {
        #initialize counter
        $counter = 0
        foreach ($task in $tasks ) {
            $counter++
            $task.ID = $counter
        }

        Switch ($PSCmdlet.ParameterSetName) {

            "Name" {
                if ($Name -match "\w+") {
                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Retrieving task: $Name"
                    $results = $tasks.Where( {$_.Name -like $Name})
                }
                else {
                    #write all tasks to the pipeline
                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Retrieving all tasks"
                    $results = $tasks
                }
            } #name

            "Category" {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Retrieving tasks for category $Category"
                $results = $tasks.Where( {$_.Category -eq $Category})
            } #category

        } #switch

        #display tasks if found otherwise display a warning
        if ($results.count -ge 1) {
            $results.foreach( {
                    $_.psobject.typenames.insert(0, "myTaskArchive")})
            $results
        }
        else {
            Write-Warning "No tasks found matching your criteria"
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($MyInvocation.Mycommand)"
    } #end

} #Get-MyTask



#endregion

