
#region variables

#set default location that should work cross platform
$global:myTaskHome = [Environment]::GetFolderPath([Environment+SpecialFolder]::MyDocuments)

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
. $psscriptroot\functions\MyTasksFunctions.ps1
if ($psedition -eq 'Desktop') {
    . $psscriptroot\functions\emailfunctions.ps1
}

$cmd = "Get-MyTask", "Set-MyTask", "Complete-MyTask", "Remove-MyTask"
Register-ArgumentCompleter -CommandName $cmd -ParameterName Name -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    [xml]$In = Get-Content -Path $MyTaskPath -Encoding UTF8
    $tasks = foreach ($obj in $in.Objects.object) {
        $obj.Property | ForEach-Object -Begin {$propHash = [ordered]@{}} -Process {
            $propHash.Add($_.name, $_.'#text')
        } -end {$prophash}
    }
    ($tasks).where( {$_.name -like "$wordToComplete*"}) | foreach-object {
        # completion text,listitem text,result type,Tooltip
        [System.Management.Automation.CompletionResult]::new("'$($_.Name)'", "'$($_.Name)'", 'ParameterValue', "Due: $($_.DueDate -as [datetime]) Completed: $($_.completed)")
    }
}

#define default properties for myTaskArchive

Update-TypeData -TypeName myTaskArchive -MemberType AliasProperty -MemberName Completed -Value TaskModified -force
Update-TypeData -TypeName myTaskArchive -MemberType AliasProperty -MemberName Creeated -Value TaskCreated -force
