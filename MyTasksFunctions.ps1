#requires -version 5.0

Function New-MyTask {

[cmdletbinding()]
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

#create the new task
$task = New-Object -TypeName MyTask -ArgumentList $Name,$DueDate,$Description,$Category

#convert to xml
$newXML = $task | Select *,TaskCreated,TaskModified,TaskID,Completed -ExcludeProperty ID | ConvertTo-Xml

#add task to disk via XML file
if (Test-Path -Path $mytaskPath) {

    #import xml file
    [xml]$in = Get-Content -Path $mytaskPath

    #check if TaskID already exists in file and skip
    $id = $task.TaskID
    $result = $in | Select-XML -XPath "//Object/Property[text()='$id']"
    if (-Not $result.node) {
        #if not,import node
        $imp = $in.ImportNode($newXML.objects.object,$true)

        #append node
        $in.Objects.AppendChild($imp) | Out-Null
        #update file

        $in.Save($mytaskPath)
    }
    else {
        Write-Verbose "Skipping $id"
    }
}
else {
    #If file doesn't exist create task and save to a file
    $newxml.Save($mytaskPath)
}

If ($Passthru) {
    $task
}

} #New-MyTask

Function Set-MyTask {

[cmdletbinding(SupportsShouldProcess)]
Param (
[Parameter(ValueFromPipeline)]
[MyTask]$Task,
[string]$Name,
[string]$Description,
[datetime]$DueDate,
[ValidateRange(0,100)]
[int]$Progress,
[TaskCategory]$Category

)

Begin {
    Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"  
    #display PSBoundparameters formatted nicely for Verbose output  
    [string]$pb = ($PSBoundParameters | format-table -AutoSize | Out-String).TrimEnd()
    Write-Verbose "[BEGIN  ] PSBoundparameters: `n$($pb.split("`n").Foreach({"$("`t"*4)$_"}) | out-string) `n" 

    $PSBoundParameters.Remove("Verbose") | Out-Null
 } #begin

Process {
    Write-Verbose "[PROGRESS] Updating task $($task.Name)"
    #remove Task object from PSBoundParameters
    $PSBoundParameters.Remove("Task") | Out-Null   
    $PSBoundParameters.keys | foreach {
      Write-Verbose "[PROGRESS] Updating $_ = $($psboundParameters.item($_))"

      $task.$($_) = $psboundParameters.item($_)
    }
    #update object
    $task.Refresh()

    #update source

    #pass object to the pipeline
    $task

} #process


End {
    Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
} #end
} #Set-MyTask

Function Remove-MyTask {

} #Remove-MyTask

Function Get-MyTask {
[cmdletbinding(DefaultParameterSetName="Name")]
Param(

[Parameter(ParameterSetName="Name")]
[string]$Name,
[Parameter(ParameterSetName="ID")]
[int]$ID,
[Parameter(ParameterSetName="All")]
[switch]$All,
[Parameter(ParameterSetName="Completed")]
[switch]$Completed

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

} #switch


Write-Verbose "Ending: $($MyInvocation.Mycommand)"
} #Get-MyTask

Function Show-MyTask {
[cmdletbinding()]
Param([switch]$All)

#run Get-MyTask

#colorize output using Write-Host

} #Show-MyTask


#this is a private function to the module
Function _ImportTasks {
[cmdletbinding()]
Param([string]$Path = $myTaskpath)


[xml]$In = Get-Content -Path $Path

foreach ($obj in $in.Objects.object) {
  $obj.Property | foreach -Begin {$propHash = [ordered]@{}} -Process {
    $propHash.Add($_.name,$_.'#text')
  } 
  
  #write-host ($propHash | out-string) -ForegroundColor Cyan

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
