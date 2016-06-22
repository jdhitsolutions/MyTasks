#requires -version 5.0

Function New-MyTask {

[cmdletbinding(SupportsShouldProcess)]
Param(
[Parameter(
Position = 0, 
Mandatory,
HelpMessage="Enter the name of your task",
ValueFromPipelineByPropertyName
)]
[string]$Name,

[Parameter(
Mandatory,
HelpMessage = "Select a task category",
ValueFromPipelineByPropertyName
)]
[ValidateNotNullorEmpty()]
[TaskCategory]$Category,

[Parameter(ValueFromPipelineByPropertyName)]
[ValidateNotNullorEmpty()]
[dateTime]$DueDate = (Get-Date).AddDays(7),

[Parameter(ValueFromPipelineByPropertyName)]
[string]$Description,

[switch]$Passthru
)

Begin {
    Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"
    #display PSBoundparameters formatted nicely for Verbose output  
    [string]$pb = ($PSBoundParameters | format-table -AutoSize | Out-String).TrimEnd()
    Write-Verbose "[BEGIN  ] PSBoundparameters: `n$($pb.split("`n").Foreach({"$("`t"*4)$_"}) | Out-String) `n" 
}

Process {
    #display PSBoundparameters formatted nicely for Verbose output  
    [string]$pb = ($PSBoundParameters | format-table -AutoSize | Out-String).TrimEnd()
    Write-Verbose "[PROCESS] PSBoundparameters: `n$($pb.split("`n").Foreach({"$("`t"*4)$_"}) | Out-String) `n" 
   
    Write-Verbose "[PROCESS] Using Parameter set: $($pscmdlet.parameterSetName)"

    #create the new task
    Write-Verbose "[PROCESS] Creating new task $Name"

    $task = New-Object -TypeName MyTask -ArgumentList $Name,$DueDate,$Description,$Category

    #convert to xml
    Write-Verbose "[PROCESS] Converting to XML"
    $newXML = $task | 
    Select Name,Description,DueDate,Category,Progress,TaskCreated,TaskModified,TaskID,Completed  | 
    ConvertTo-Xml

    Write-Verbose "[PROCESS] Saving task"
    #add task to disk via XML file
    if (Test-Path -Path $mytaskPath) {

        #import xml file
        [xml]$in = Get-Content -Path $mytaskPath

        #continue of there are existing objects in the file
        if ($in.objects) {
            #check if TaskID already exists in file and skip
            $id = $task.TaskID
            $result = $in | Select-XML -XPath "//Object/Property[text()='$id']"
            if (-Not $result.node) {
                #if not,import node
                $imp = $in.ImportNode($newXML.objects.object,$true)

                #append node
                $in.Objects.AppendChild($imp) | Out-Null
                #update file

                if ($PSCmdlet.ShouldProcess($task.name)) {
                    $in.Save($mytaskPath)
                }
            }
            else {
                Write-Verbose "Skipping $id"
            }
        }
        else {
            #must be an empty XML file
            if ($PSCmdlet.ShouldProcess($task.name)) {
                $newxml.Save($mytaskPath)
            }
        }
    }
    else {
        #If file doesn't exist create task and save to a file
        if ($PSCmdlet.ShouldProcess($task.name)) {
            $newxml.Save($mytaskPath)
        }
    }

    If ($Passthru) {
        Write-Verbose "[PROCESS] Passing object to the pipeline."
        $task
    }

} #Process

End {
    Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
} #end

} #New-MyTask

Function Set-MyTask {

[cmdletbinding(SupportsShouldProcess,DefaultParameterSetName="Name")]
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
[string]$NewName,
[string]$Description,
[datetime]$DueDate,
[ValidateRange(0,100)]
[int]$Progress,
[TaskCategory]$Category,
[switch]$Passthru

)

Begin {
    Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"  
    #display PSBoundparameters formatted nicely for Verbose output  
    [string]$pb = ($PSBoundParameters | format-table -AutoSize | Out-String).TrimEnd()
    Write-Verbose "[BEGIN  ] PSBoundparameters: `n$($pb.split("`n").Foreach({"$("`t"*4)$_"}) | Out-String) `n" 

    Write-Verbose "[BEGIN  ] Cleaning PSBoundparameters"
    $PSBoundParameters.Remove("Verbose")  | Out-Null
    $PSBoundParameters.Remove("WhatIf")   | Out-Null
    $PSBoundParameters.Remove("Confirm")  | Out-Null
    $PSBoundParameters.Remove("Passthru") | Out-Null
    

 } #begin

Process {
    Write-Verbose "[PROCESS] Using parameter set: $($PSCmdlet.ParameterSetName)"

    #remove this as a bound parameter
    $PSBoundParameters.Remove("Task") | Out-Null

    [string]$pb = ($PSBoundParameters | Format-Table -AutoSize | Out-String).TrimEnd()
    Write-Verbose "[PROCESS] PSBoundparameters: `n$($pb.split("`n").Foreach({"$("`t"*4)$_"}) | Out-String) `n" 

    Write-Verbose "[PROCESS] Processing XML"
    Try {
        [xml]$In = Get-Content -Path $MyTaskPath -ErrorAction Stop
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
        $node = ($in | Select-xml -XPath "//Object/Property[@Name='TaskID' and text()='$($task.taskid)']").Node.ParentNode
    }

    if (-Not $Node) {
        Write-Warning "Failed to find task: $Name"
        #abort and bail out
        return
    } 
    
    $taskName = $node.SelectNodes("Property[@Name='Name']").'#text'
    Write-Verbose "[PROCESS] Updating task $taskName"
    Write-Verbose "[PROCESS] $($node.property | Out-String)"

    #go through all PSBoundParameters other than Name or NewName

    $PSBoundParameters.keys | where {$_ -notMatch 'name'} | foreach {
     #update the task property
     Write-Verbose "[PROCESS] Updating $_ to $($PSBoundParameters.item($_))"
     $setting = $node.SelectSingleNode("Property[@Name='$_']")
     $setting.InnerText = $PSBoundParameters.item($_) -as [string]
     
     }   
       
     If ($NewName) {
        Write-Verbose "[PROCESS] Updating to new name: $NewName"
       $node.SelectSingleNode("Property[@Name='Name']").'#text' = $NewName
     }
     
     #update TaskModified
     $node.SelectSingleNode("Property[@Name='TaskModified']").'#text' = (Get-Date).ToString()
   
     If ($PSCmdlet.ShouldProcess($TaskName)) {
         #update source
         Write-Verbose "[PROCESS] Saving task file"
         $in.Save($MyTaskPath)
     
        #pass object to the pipeline
        if ($Passthru) {
            Write-Verbose "[PROCESS] Passing object to the pipeline"
            Get-MyTask -Name $taskName
        }
    } #should process
} #process

End {
    Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
} #end
} #Set-MyTask

Function Remove-MyTask {
[cmdletbinding(SupportsShouldProcess,DefaultParameterSetName = "Name")]
Param(
[Parameter(
Position = 0,
Mandatory,
HelpMessage = "Enter task name",
ValueFromPipeline,
ParameterSetName = "Name"
)]
[ValidateNotNullorEmpty()]
[string]$Name,

[Parameter(
Position = 0,
Mandatory,
HelpMessage = "Enter task guid id",
ValueFromPipelinebyPropertyName,
ParameterSetName = "Guid"
)]
[ValidateNotNullorEmpty()]
[Guid]$TaskID
)


Begin {
    Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"  
    #display PSBoundparameters formatted nicely for Verbose output  
    [string]$pb = ($PSBoundParameters | Format-Table -AutoSize | Out-String).TrimEnd()
    Write-Verbose "[BEGIN  ] PSBoundparameters: `n$($pb.split("`n").Foreach({"$("`t"*4)$_"}) | Out-String) `n" 

    #load tasks from XML
    [xml]$In = Get-Content -Path $MyTaskPath
} #begin

Process {
     Write-Verbose "[PROCESS] Using parameter set: $($PSCmdlet.parameterSetname)"

     if ($Name) {
        Write-Verbose "[PROCESS] Retrieving task: $Name"
        Try {
            $taskID = (Get-MyTask -Name $Name -ErrorAction Stop).TaskID
        }
        Catch {
            Write-Warning "Failed to find a task with a name of $Name"
            #abort and bail out
            return
        }        
     } #if $name

     #select node by TaskID (GUID)
     Write-Verbose "[PROCESS] Identifying task id: $TaskID"
     $node = ($in | select-xml -XPath "//Object/Property[text()='$TaskID']").node.ParentNode

     if ($node) {
         #remove it
         write-Verbose "[PROCESS] Removing: $($node.Property | Out-String)"

         if ($PSCmdlet.ShouldProcess($TaskID)) {
         $node.parentNode.RemoveChild($node) | Out-Null

         $node.ParentNode.objects
         #save file
         Write-Verbose "[PROCESS] Updating $MyTaskPath"
         $in.Save($mytaskPath)
         } #should process
     }
     else {
        Write-Warning "Failed to find a matching task with an id of $TaskID"
        Return
     }
} #process

End {
    Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
} #end

} #Remove-MyTask

Function Get-MyTask {
[cmdletbinding(DefaultParameterSetName="Name")]
Param(

[Parameter(
Position = 0,
ParameterSetName="Name"
)]
[string]$Name,
[Parameter(ParameterSetName="ID")]
[int]$ID,
[Parameter(ParameterSetName="All")]
[switch]$All,
[Parameter(ParameterSetName="Completed")]
[switch]$Completed,
[Parameter(ParameterSetName="Category")]
[TaskCategory]$Category

)

Write-Verbose "Starting: $($MyInvocation.Mycommand)"
Write-Verbose "Using parameter set $($PSCmdlet.ParameterSetName)"
#display PSBoundparameters formatted nicely for Verbose output  
[string]$pb = ($PSBoundParameters | format-table -AutoSize | Out-String).TrimEnd()
Write-Verbose "PSBoundparameters: `n$($pb.split("`n").Foreach({"$("`t"*4)$_"}) | Out-String) `n" 

#import from the XML file
Write-Verbose "Importing tasks from $mytaskPath"
$tasks = _ImportTasks | Sort TaskCreated

Write-Verbose "Imported $($tasks.count) tasks"

#initialize counter
$counter=0
foreach ($task in $tasks ) {
  $counter++
  $task.ID = $counter
}

Switch ($PSCmdlet.ParameterSetName) {

"Name" {
        if ($Name -match "\w+") {
            Write-Verbose "Retrieving task: $Name"
            $tasks.Where({$_.Name -eq $Name})
        }
        else {
            #write all tasks to the pipeline
            Write-Verbose "Retrieving all incomplete tasks"
            $tasks.Where({-Not $_.Completed})
        }
}

"ID" {
        Write-Verbose "Retrieving Task by ID: $ID"
        $tasks.where({$_.id -eq $ID})
}

"All" { 
        Write-Verbose "Retrieving all tasks"
         $Tasks
}

"Completed" {
        Write-Verbose "Retrieving completed tasks"
        $tasks.Where({$_.Completed})
}

"Category" {
        Write-Verbose "Retrieving tasks for category $Category"
        $tasks.Where({$_.Category -eq $Category})
}
} #switch


Write-Verbose "Ending: $($MyInvocation.Mycommand)"
} #Get-MyTask

Function Show-MyTask {

#colorize output using Write-Host

[cmdletbinding()]
Param([switch]$All)

Write-Verbose "Starting: $($MyInvocation.Mycommand)"

#run Get-MyTask
$tasks = Get-MyTask @PSBoundParameters

#convert tasks to a text table
$table = ($tasks | Format-Table | Out-String).split("`n")

#define a regular expression pattern to match the due date
[regex]$rx = "\d{1,2}\/\d{1,2}\/\d{4}.*M"

Write-Host "`n"
Write-Host $table[1] -ForegroundColor Cyan
Write-Host $table[2] -ForegroundColor Cyan
$table[3..$table.count] | foreach {

    #test if DueDate is within 24 hours
    if ($rx.IsMatch($_)) {
        $hours = (($rx.Match($_).Value -as [datetime]) - (Get-Date)).totalhours
    }
    #select a different color for over due tasks
    if ($_ -match "\bTrue\b") {
        $c = "Red"
    }
    elseif ($hours -le 24 ) {
        $c = "Yellow"
        $hours = 999
    }
    else {
        $c = $host.ui.RawUI.ForegroundColor
    }
    Write-Host $_ -ForegroundColor $c
} #foreach

Write-Verbose "Ending: $($MyInvocation.Mycommand)"

} #Show-MyTask

Function Complete-MyTask {

[cmdletbinding(SupportsShouldProcess,DefaultParameterSetName="Name")]
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

[switch]$Passthru
)


Begin {
    Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"  
    #display PSBoundparameters formatted nicely for Verbose output  
    [string]$pb = ($PSBoundParameters | format-table -AutoSize | Out-String).TrimEnd()
    Write-Verbose "[BEGIN  ] PSBoundParameters: `n$($pb.split("`n").Foreach({"$("`t"*4)$_"}) | Out-String) `n" 

} #begin

Process {
    #display PSBoundparameters formatted nicely for Verbose output  
    [string]$pb = ($PSBoundParameters | format-table -AutoSize | Out-String).TrimEnd()
    Write-Verbose "[PROCESS] PSBoundParameters: `n$($pb.split("`n").Foreach({"$("`t"*4)$_"}) | Out-String) `n" 

    if ($Name) {
        #get the task
        Try {
            Write-Verbose "[PROCESS] Retrieving task: $Name"
            $Task = Get-MyTask -Name $Name -ErrorAction Stop
        }
        Catch {
            Write-Error $_
            #bail out
            Return
        }
    }

    If ($Task) {
        Write-Verbose "[PROCESS] Marking task as completed"
        #invoke CompleteTask() method
        $task.CompleteTask()
        Write-Verbose "[PROCESS] $($task | Select *,Completed,TaskModified,TaskID | Out-String)"
        
        #find matching XML node and replace it
        Write-Verbose "[PROCESS] Updating task file"
        #convert current task to XML
        $new = ($task | Select Name,Descriptiong,DueDate,Category,Progress,TaskID,TaskCreated,TaskModified,Completed | ConvertTo-Xml).Objects.Object

        #load tasks from XML
        [xml]$In = Get-Content -Path $MyTaskPath

        #select node by TaskID (GUID)
        $node = ($in | select-xml -XPath "//Object/Property[text()='$($task.TaskID)']").node.ParentNode

        #import the new node
        $imp = $in.ImportNode($new,$true)

        #replace node
        $node.ParentNode.ReplaceChild($imp,$node) | Out-Null

        #save
        If ($PSCmdlet.ShouldProcess($task.name)) {
            $in.Save($MyTaskPath)

            if ($Passthru) {
                Write-Verbose "[PROCESS] Passing task back to the pipeline"
                Get-MyTask -Name $task.name
            }
        }
    }
    else {
        Write-Warning "Failed to find a matching task."
    }
} #process


End {
    Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
} #end

} #Complete-MyTask

#this is a private function to the module
Function _ImportTasks {
[cmdletbinding()]
Param([string]$Path = $myTaskpath)

[xml]$In = Get-Content -Path $Path

foreach ($obj in $in.Objects.object) {
  $obj.Property | foreach -Begin {$propHash = [ordered]@{}} -Process {
    $propHash.Add($_.name,$_.'#text')
  } 
  
  Try {
      $tmp = New-Object -TypeName MyTask -ArgumentList $propHash.Name, $propHash.DueDate, $propHash.Description, $propHash.Category
      $tmp.TaskID = $prophash.TaskID
      $tmp.Progress = $prophash.Progress -as [int]
      $tmp.TaskCreated = $prophash.TaskCreated -as [datetime]
      $tmp.TaskModified = $prophash.TaskModified -as [datetime]
      $tmp.Completed = [Convert]::ToBoolean($prophash.Completed)

      $tmp.Refresh()
      $tmp
  }
  Catch {
    Write-Error $_
  }

} #foreach

} #_ImportTasks
