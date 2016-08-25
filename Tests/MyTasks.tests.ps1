

import-module ..\Mytasks -Force

InModuleScope MyTasks {

Describe "The module" {

$theModule = get-module -name mytasks
    It "Should have 11 functions" {
        $theModule.exportedfunctions.count | should be 11
    }

    It "Should have 7 aliases command" {
        $theModule.ExportedAliases.count | should be 7
    }

    It "Should export 3 variables by default" {
        $theModule.ExportedVariables.Count | Should be 3
    }

    It "Should have a formatting xml file" {
        $theModule.ExportedFormatFiles.Count | Should be 1
    }

    It "Requires PowerShell 5.0" {
        $theModule.PowerShellVersion | Should be '5.0'
    }
} 


Describe Categories {

$myTaskCategory = "TestDrive:\myTaskCategory.txt"

    It "Default categories are Work,Personal,Other, and Customer" {
       $myTaskDefaultCategories.count | Should be 4
       $myTaskDefaultCategories -join "-"| Should Match "Work"
       $myTaskDefaultCategories -join "-"| Should Match "Personal"
       $myTaskDefaultCategories -join "-"| Should Match "Other"
       $myTaskDefaultCategories -join "-"| Should Match "Customer"
    }

    It "Adds a Testing category to $myTaskCategory" {
        Add-MyTaskCategory -Category Testing
        $c =  Get-Content -path $myTaskCategory -raw
        Test-Path -path $myTaskCategory | Should Be $True
        $c | Should match "Testing"
    }

    It "Adds multiple categories" {
        Add-MyTaskCategory -Category Work,Personal,Other,Training,Demo
        (Get-MyTaskCategory).count| Should be 6
    }

    It "Should dynamically recognize all category values" {
        (get-command new-mytask).parameters["Category"].attributes.validvalues.count | Should be 6
    }

    It "Can remove a category" {
        Remove-MyTaskCategory -Category Demo
         (Get-MyTaskCategory).count| Should be 5
    }
    
}

Describe Tasks {

Mock Get-Date { return ("9/1/2016 12:01:00PM" -as [datetime])  }


#need absolute path for XML files
$mytaskPath = Join-Path $TestDrive -child "myTasks.xml" 
$myTaskArchivePath = Join-Path -Path $TestDrive -ChildPath myTasksArchive.xml

$myTaskCategory = "TestDrive:\myTaskCategory.txt"

Add-MyTaskCategory -Category Work,Personal,Other,Training,Testing

    It "Should create a new task" {
        $a = New-MyTask -Name Test1 -DueDate 12/31/2016 -Category Testing -Passthru
        $a.id | Should be 0
        Test-Path $mytaskPath | Should Be $True
    }

    It "Should create a new task with a 7 day default due date" {
        $b = New-MyTask -Name Test2 -Category Testing -Passthru
        $b.DueDate | Should Be "09/08/2016 12:01:00"
    }

    It "Should get tasks" {
        $t = Get-MyTask -name Test1
        $t.ID | Should be 2
        $t.name | Should be "Test1"
        $t.duedate | Should match "12/31/2016"
        $t.Category | Should be "Testing"
        $t.OverDue | Should Be $False
    }

    #add some other tasks
    New-MyTask -Name A -DueDate 12/31/2016 -Category Testing
    New-MyTask -Name B -DueDate 10/01/2016 -Category Work
    New-MyTask -Name C -DueDate 11/11/2016 -Category Personal

    It "Should get tasks by category" {
        (Get-Mytask -Category Testing).count | should be 3
    }

    It "Should get tasks by days due" {
        (Get-MyTask -DaysDue 30).count | Should be 2
    }

    It "Should get all tasks" {
        (Get-MyTask -All).count | Should be 5
    }

    It "Should modify a task by name" {
        Set-MyTask -Name "Test1" -Progress 50 -Description "Pester Test" -DueDate "8/1/2016"
         $t = Get-MyTask -name Test1
         $t.Progress | should be 50
         $t.description | should be "Pester Test"
         $t.duedate | Should be ("8/1/2016" -as [datetime])
         $t.OverDue | Should be $true
    }

    It "Should modify a task via the pipeline" {
        Get-MyTask -Name "Test1" | Set-MyTask -Progress 80 
         $t = Get-MyTask -name  Test1
         $t.Progress | should be 80
    }

    It "Show-MyTask should write to the host" {
        {Show-MyTask | Get-Membet} | Should Throw
    }

    It "Should Complete a task" {

        {Complete-Mytask -Name Test1 -ErrorAction Stop} | Should Not Throw
        (Get-MyTask | Measure-Object).Count | Should be 4
        (Get-MyTask -Completed | Measure-Object).Count | Should be 1

    }

    It "Should complete and archive a task" {

        {Complete-Mytask -Name Test2 -Archive -ErrorAction Stop} | Should Not Throw
         (Get-MyTask).count | Should be 3
    }

    It "Should archive or save a task" {
        $save = Join-path $TestDrive -ChildPath "Archive.xml"
        Get-MyTask -Completed | Save-MyTask -Path $save
        Test-Path $save | should Be $True
        Get-MyTask -Name Test1 | Should Be $null
        (Get-MyTask).count | Should be 3
    }

    It "Should have an Archive-MyTask alias for Save-MyTask" {
        $c = get-command Archive-Mytask
        $c.Displayname | should be "Archive-MyTask"
        $c.ReferencedCommand | Should be "Save-MyTask"
    }

    It "Should remove a task and backup the task file" {

        Mock Get-Date { return "20160901"  } -ParameterFilter {format -eq "yyyyMMdd"} 
        $home = $TestDrive
        mkdir $home\documents
    
        {Remove-myTask -Name A} | Should not Throw
        {Get-MyTask -Name B | Remove-MyTask } | should not Throw
        (Get-MyTask).count | Should be 1
        Test-Path $TestDrive\documents\MyTasks_Backup_20160901.xml | Should be $True
    }

}

} #in module