#requires -version 5.0

#region variables

$myTaskCategory = Join-Path -Path $home\Documents\WindowsPowerShell -ChildPath myTaskCatgory.ps1

$mytaskPath = Join-Path -Path "$home\Documents\" -ChildPath myTasks.xml

#define a global variable to track task id
$myTaskID = 0 

$myTasks = @()

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

# ID and OverDue values are calcuated at run time.

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
    $this.Overdue = $False
    $this.TaskModified = Get-Date
}

hidden [void]Refresh() {
  
  if ((Get-Date) -gt $this.DueDate) {
    $this.Overdue = $True 
  } 

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

#dot source functions
. $psscriptroot\myTasksFunctions.ps1

#if existing task XML file is found, import it and create MyTask objects

#saving imported objects to variable

#otherwise don't do anything

Export-ModuleMember -Variable myTaskCategory,myTaskPath,MyTaskID,myTasks -Function "New-MyTask","Set-MyTask","Remove-MyTask","Get-MyTask","Show-MyTask"