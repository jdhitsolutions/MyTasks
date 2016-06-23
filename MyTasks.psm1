#requires -version 5.0

#region variables

#path to user defined categories
$myTaskCategory = Join-Path -Path $home\Documents\ -ChildPath myTaskCategory.txt

#path to stored tasks
$mytaskPath = Join-Path -Path "$home\Documents\" -ChildPath myTasks.xml

#default task categories
$myTaskDefaultCategories = "Work","Personal","Other","Customer"

#endregion

#region class definition

Class MyTask {

<#
A class to define a task or to-do item
#>

#Properties
# ID and OverDue values are calcuated at run time.

[int]$ID
[string]$Name
[string]$Description
[datetime]$DueDate
[bool]$Overdue
[String]$Category
[ValidateRange(0,100)][int]$Progress
hidden[bool]$Completed
hidden[datetime]$TaskCreated = (Get-Date)
hidden[datetime]$TaskModified
hidden[guid]$TaskID = (New-Guid)

#Methods

#set task as completed

[void]CompleteTask() {
    $this.Completed = $True
    $this.Progress = 100
    $this.Overdue = $False
    $this.TaskModified = Get-Date
}

#check if task is overdue and update
hidden [void]Refresh() {
  
  #only mark as overdue if not completed and today is
  #greater than the due date
  if (((Get-Date) -gt $this.DueDate) -AND (-Not $this.completed)) {
    $this.Overdue = $True 
  } 
  else {
    $this.Overdue = $False
  }

} #refresh


#Constructors
MyTask([string]$Name) {
    $this.Name = $Name
    $this.DueDate = (Get-Date).AddDays(7)
    $this.TaskModified = (Get-Date)
    $this.Refresh()
}

MyTask([string]$Name,[datetime]$DueDate,[string]$Description,[string]$Category) {
    $this.Name = $Name
    $this.DueDate = $DueDate
    $this.Description = $Description
    $this.Category = $Category
    $this.TaskModified = $this.TaskCreated
    $this.Refresh()
}

} #end class definition

#endregion

#dot source functions
. $psscriptroot\myTasksFunctions.ps1

#define some aliases
Set-Alias -Name gmt -Value Get-MyTask
Set-Alias -Name smt -Value Set-MyTask
Set-Alias -Name shmt -Value Show-MyTask
Set-Alias -Name rmt -Value Remove-MyTask
Set-Alias -Name cmt -Value Complete-MyTask
Set-Alias -Name nmt -Value New-MyTask

#define a hashtable of parameters to splat to Export-ModuleMember
$exportParams = @{
Variable = "myTaskPath","myTaskDefaultCategories"
Function = "New-MyTask","Set-MyTask","Remove-MyTask","Get-MyTask","Show-MyTask","Complete-MyTask"
Alias = "gmt","rmt","shmt","smt","cmt","nmt"
}

Export-ModuleMember @exportParams