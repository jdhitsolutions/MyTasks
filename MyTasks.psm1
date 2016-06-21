#requires -version 5.0

#region variables

$myTaskCategory = Join-Path -Path $home\Documents\WindowsPowerShell -ChildPath myTaskCatgory.ps1

$mytaskPath = Join-Path -Path "$home\Documents\" -ChildPath myTasks.xml

#define a global variable to track task id
$myTaskID = 0 

$myTasks = @()

#endregion

#region Definitions

if (Test-Path -Path $myTaskCategory) {
    #dot source user list
    . $userTaskCategory
}
else {
    #define default categories
    enum TaskCategory {
    Work
    Personal
    Customer
    Other
  }
}

Class MyTask {

<#
A class to define a task or to-do item
#>

#region Properties
[int]$ID
[string]$Name
[string]$Description
[datetime]$DueDate
[bool]$Overdue
[TaskCategory]$Category
[ValidateRange(0,100)][int]$Progress
hidden[bool]$Completed
hidden[datetime]$TaskCreated = (Get-Date)
hidden[datetime]$TaskModified
hidden[guid]$TaskID = (New-Guid)


#endregion

#region Methods

#set task as completed

[void]CompleteTask() {
    $this.Completed = $True
    $this.Progress = 100
}

hidden [void]Refresh() {
  if ( (Get-Date) -gt $this.DueDate) {
    $this.Overdue = $True
  }
  else {
    $this.Overdue = $False
  }

  if ($this.Progress -eq 100) {
    $this.Completed = $True
  }

  #update modified property
  $this.TaskModified = Get-Date
} #refresh


#endRegion

#region constructor
MyTask([string]$Name) {
    $this.Name = $Name
    $this.DueDate = (Get-Date).AddDays(7)
    $this.TaskModified = (Get-Date)
    $this.Refresh()
}

MyTask([string]$Name,[datetime]$DueDate,[string]$Description,[TaskCategory]$Category) {
    $this.Name = $Name
    $this.DueDate = $DueDate
    $this.Description = $Description
    $this.Category = $Category
    $this.TaskModified = $this.TaskCreated

    $this.Refresh()
}
#endregion

} #end class definition

#endregion

#endregion

#region Function

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

[Parameter(Mandatory,
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

$task = New-Object -TypeName MyTask -ArgumentList $Name,$DueDate,$Description,$Category

$myTaskID++
$task.id = $myTaskID

#add task to array
$global:myTasks+=$task

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
[cmdletbinding()]
Param(
[string]$Name,
[switch]$All
)

} #Get-MyTask

Function Show-MyTask {
[cmdletbinding()]
Param([switch]$All)

#run Get-MyTask

#colorize output using Write-Host

} #Show-MyTask


#this is a private function to the module
Function _ImportTask {
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
  $tmp.Progress = $prophash.Progress
  $tmp.TaskCreated = $prophash.TaskCreated
  $tmp.TaskModified = $prophash.TaskModified
  $tmp.Completed = $prophash.Completed

  $tmp
  }
  Catch {
    Write-Error $_
  }

}

} #_ImportTask

#endregion

#if existing task XML file is found, import it and create MyTask objects

#saving imported objects to variable

#otherwise don't do anything

Export-ModuleMember -Variable myTaskCategory,myTaskPath,MyTaskID,myTasks -Function "New-MyTask","Set-MyTask","Remove-MyTask","Get-MyTask","Show-MyTask"