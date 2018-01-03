#requires -version 5.0

#region variables

#path to user defined categories
$myTaskCategory = Join-Path -Path $home\Documents\ -ChildPath myTaskCategory.txt

#path to stored tasks
$mytaskPath = Join-Path -Path "$home\Documents\" -ChildPath myTasks.xml

#path to archived or completed tasks
$myTaskArchivePath = Join-Path -Path "$home\Documents\" -ChildPath myTasksArchive.xml

#default task categories
$myTaskDefaultCategories = "Work","Personal","Other","Customer"

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
Set-Alias -Name Archive-MyTask -Value Save-MyTask

#define a hashtable of parameters to splat to Export-ModuleMember
$exportParams = @{
Variable = "myTaskPath","myTaskDefaultCategories","myTaskArchivePath"
Function = "New-MyTask","Set-MyTask","Remove-MyTask","Get-MyTask",
"Show-MyTask","Complete-MyTask","Get-MyTaskCategory","Add-MyTaskCategory",
"Remove-MyTaskCategory","Backup-MyTaskFile","Save-MyTask"
Alias = "gmt","rmt","shmt","smt","cmt","nmt","Archive-MyTask"
}

#exported via manifest
Export-ModuleMember @exportParams