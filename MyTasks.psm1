
#region variables

#path to user defined categories
if ($isLinux) {
    $global:mytaskhome = $home
}
else {
    $global:mytaskhome = "$home\Documents" 
}

#path to the category file
$global:myTaskCategory = Join-Path -Path $mytaskhome -ChildPath myTaskCategory.txt

#path to stored tasks
$global:mytaskPath = Join-Path -Path $mytaskhome -ChildPath myTasks.xml

#path to archived or completed tasks
$global:myTaskArchivePath = Join-Path -Path $mytaskhome -ChildPath myTasksArchive.xml

#default task categories
$script:myTaskDefaultCategories = "Work", "Personal", "Other", "Customer"

#endregion

#dot source functions
. $psscriptroot\MyTasksFunctions.ps1

$cmd = "Get-MyTask", "Set-MyTask", "Complete-MyTask", "Remove-MyTask"
Register-ArgumentCompleter -CommandName $cmd -ParameterName Name -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    [xml]$In = Get-Content -Path $MyTaskPath -Encoding UTF8

    foreach ($obj in $in.Objects.object) {
        $obj.Property | ForEach-Object -Begin {$propHash = [ordered]@{}} -Process {
            $propHash.Add($_.name, $_.'#text')
        } 
        $propHash  |
        foreach-object {
        # completion text,listitem text,result type,Tooltip
        [System.Management.Automation.CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', "Due: $($_.DueDate) Completed: $($_.completed)")
    }
  }
}
