#requires -version 5.0

#region variables

#path to user defined categories
if ($isLinux) {
    $mytaskhome = $home
}
else {
    $mytaskhome = "$home\Documents" 
}
$myTaskCategory = Join-Path -Path $mytaskhome -ChildPath myTaskCategory.txt

#path to stored tasks
$mytaskPath = Join-Path -Path $mytaskhome -ChildPath myTasks.xml

#path to archived or completed tasks
$myTaskArchivePath = Join-Path -Path $mytaskhome -ChildPath myTasksArchive.xml

#default task categories
$myTaskDefaultCategories = "Work","Personal","Other","Customer"

#endregion

#dot source functions
. $psscriptroot\MyTasksFunctions.ps1

#define some aliases
$aliases = @()
$aliases+= Set-Alias -Name gmt -Value Get-MyTask -PassThru
$aliases+= Set-Alias -Name smt -Value Set-MyTask -PassThru
$aliases+= Set-Alias -Name shmt -Value Show-MyTask -PassThru
$aliases+= Set-Alias -Name rmt -Value Remove-MyTask -PassThru
$aliases+= Set-Alias -Name cmt -Value Complete-MyTask -PassThru
$aliases+= Set-Alias -Name nmt -Value New-MyTask -PassThru
$aliases+= Set-Alias -name task -value New-MyTask -PassThru
$aliases+= Set-Alias -Name Archive-MyTask -Value Save-MyTask -PassThru

#define a hashtable of parameters to splat to Export-ModuleMember
$exportParams = @{
Variable = "myTaskPath","myTaskDefaultCategories","myTaskArchivePath","mytaskhome"
Function = "New-MyTask","Set-MyTask","Remove-MyTask","Get-MyTask",
"Show-MyTask","Complete-MyTask","Get-MyTaskCategory","Add-MyTaskCategory",
"Remove-MyTaskCategory","Backup-MyTaskFile","Save-MyTask","Enable-EmailReminder",
"Disable-EmailReminder","Get-EmailReminder"
Alias = $aliases.Name
}

#exported via manifest
Export-ModuleMember @exportParams