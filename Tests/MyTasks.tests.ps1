
import-module $PSScriptRoot\..\Mytasks.psd1 -Force

InModuleScope MyTasks {

    Describe "The module" {

        $theModule = get-module -name mytasks
        It "Should have 15 functions" {
            $theModule.exportedfunctions.count | should be 15
        }

        It "Should have 8 aliases command" {
            $theModule.ExportedAliases.count | should be 8
        }

        It "Should not export any variables" {
            $theModule.ExportedVariables.Count | Should be 0
        } 

        It "Should have a formatting xml file" {
            $theModule.ExportedFormatFiles.Count | Should be 1
        }

        It "Requires PowerShell 5.0" {
            $theModule.PowerShellVersion | Should be '5.0'
        }
    } #describe my module


    Describe Categories {

        #$myTaskCategory = "TestDrive:\myTaskCategory.txt"
        Set-MyTaskPath TestDrive:

        It "Default categories are Work,Personal,Other, and Customer" {
            $script:myTaskDefaultCategories.count | Should be 4
            $script:myTaskDefaultCategories -join "-"| Should Match "Work"
            $script:myTaskDefaultCategories -join "-"| Should Match "Personal"
            $script:myTaskDefaultCategories -join "-"| Should Match "Other"
            $script:myTaskDefaultCategories -join "-"| Should Match "Customer"
        }
        
        
        It "keeps the default categories when a new one is added" {
            Add-MyTaskCategory -Category 'ToDo'
            $c = Get-Content -Path $myTaskCategory -Raw
            $c | Should Match 'Work'
            $c | Should Match 'Personal'
            $c | Should Match 'Other'
            $c | Should Match 'Customer'
            $c | Should Match 'ToDo'
        }

        It "Adds a Testing category to $myTaskCategory" {
            Add-MyTaskCategory -Category Testing
            $c = Get-Content -path $myTaskCategory -raw
            Test-Path -path $myTaskCategory | Should Be $True
            $c | Should match "Testing"
        }

        It "Adds multiple categories" {
            Add-MyTaskCategory -Category Work, Personal, Other, Training, Demo
            (Get-MyTaskCategory).count| Should be 8
        }

        It "Should dynamically recognize all category values" {
            (get-command new-mytask).parameters["Category"].attributes.validvalues.count | Should be 8
        }

        It "Can remove a category" {
            Remove-MyTaskCategory -Category Demo
            (Get-MyTaskCategory).count| Should be 7
        }
    
    } #describe my categories

    Describe Tasks {

        <#
        It doesn't appear that you can consistently mock commands that might be used in a class
        so we'll use the actual date
    #>

        $Due = (Get-Date).AddDays(30).Date
    
        Set-MyTaskPath TestDrive:

        <#  #need absolute path for XML files
new-Item -Name Documents -ItemType Directory -path TestDrive:
$home = $TestDrive
$mytaskhome = Join-Path $home -childpath Documents
$mytaskPath = Join-Path $home\Documents -child "myTasks.xml" 
$myTaskArchivePath = Join-Path -Path $home\Documents -ChildPath "myTasksArchive.xml"
$myTaskCategory = Join-Path -path $home\Documents -childpath "myTaskCategory.txt" #>

        Add-MyTaskCategory -Category Work, Personal, Other, Training, Testing


        It "Should create a new task" {
            $a = New-MyTask -Name Test1 -DueDate $Due -Category Testing -Passthru
            $a.id | Should be 1
            Test-Path $mytaskPath | Should Be $True
        }

        It "Should create a new task with a 7 day default due date" {
            $b = New-MyTask -Name Test2 -Category Testing -Passthru
            $target = "{0:ddMMyyyy}" -f (get-date).adddays(7)
            $tested = "{0:ddMMyyyy}" -f $b.duedate
            $tested | Should Be $target
        }

        It "Should get tasks by name" {
            $t = Get-MyTask -name Test1 
            $t.ID | Should be 2
            $t.name | Should be "Test1"
            $t.duedate.year | Should match (Get-Date).year
            $t.Category | Should be "Testing"
            $t.duedate  | Should be $Due
            $t.Overdue | Should Be $False
        }

        It "Should get tasks by days due" {
            (Get-MyTask -DaysDue 30).count | Should be 2
        }

        #add some other tasks
        New-MyTask -Name Alice -DueDate "12/31" -Category Testing
        New-MyTask -Name Bob -DueDate "10/01" -Category Work
        New-MyTask -Name Carol -DueDate "11/11" -Category Personal
        New-MyTask -Name Dave -dueDate "12/12" -category other

        It "Should get tasks by category" {
            (Get-Mytask -Category Testing).count | should be 3
        }

        It "Should get all tasks" {
            (Get-MyTask -All).count | Should be 6
        }

        It "Should modify a task by name" {
            $yr = (Get-Date).year + 1
            Set-MyTask -Name "Test1" -Progress 50 -Description "Pester Test" -DueDate "$yr-1-8"
            $t = Get-MyTask -name Test1
            $t.Progress | should be 50
            $t.description | should be "Pester Test"
            $t.duedate | Should be ("$yr-1-8" -as [datetime])
            $t.OverDue | Should be $false
        }

        It "Should modify a task via the pipeline" {
            Get-MyTask -Name "Test1" | Set-MyTask -Progress 80 
            $t = Get-MyTask -name  Test1
            $t.Progress | should be 80
        }

        It "Show-MyTask should write to the host" {
            {Show-MyTask | Get-Member -ErrorAction stop} | Should Throw
        }

        It "Should Complete a task" {
            {Complete-Mytask -Name Test1 -ErrorAction Stop} | Should Not Throw
            (Get-MyTask -Completed | Measure-Object).Count | Should be 1
        }

        It "Should complete a task with a completion date" {
            {Complete-mytask -Name Dave -CompletedDate "12/1"} | Should Not throw
        }

        Context Archive {

            $save = Join-path $TestDrive -ChildPath "Archive.xml"
            It "Should complete and archive a task" {
                {Complete-Mytask -Name Test2 -Archive -ErrorAction Stop} | Should Not Throw
                (Get-MyTask -all | where-object {-not $_.completed}).count | Should be 3
            }

            It "Should archive or save a task" {
                Get-MyTask -Completed | Save-MyTask -Path $save
                Test-Path $save | should Be $True
                Get-MyTask -Name Test1 -WarningAction SilentlyContinue | Should Be $null
                (Get-MyTask -all).count | Should be 3
            }

            It "Should have an Archive-MyTask alias for Save-MyTask" {
                $c = get-command Archive-Mytask
                $c.Displayname | should be "Archive-MyTask"
                $c.ReferencedCommand | Should be "Save-MyTask"
            }
        } 
        Context Backup {
            It "Should remove a task and backup the task file" {
                {Remove-myTask -Name Alice } | Should not Throw
                {Get-MyTask -Name Bob | Remove-MyTask } | should not Throw
                (Get-MyTask -all).count | Should be 1
            }
    
            It "Should backup the task file" {
                {Backup-MyTaskFile -ErrorAction Stop} | Should Not Throw
                #dir TestDrive: -Recurse | out-string | write-host
                Test-Path TestDrive:\MyTasks_Backup_*.xml | Should be $True
            }
        }
    } #describe my tasks

    Describe TaskVariables {

        It "Set-MyTaskPath should change the global module variables" {
            $new = Join-Path -Path $TestDrive -ChildPath MyTasks
            new-item $new -ItemType Directory
            {Set-MyTaskPath -path $new }
        }
        $vars = 'myTaskArchivePath', 'myTaskCategory', 'mytaskhome', 'mytaskPath'
        foreach ($var in $vars) {
            It "Should update $var" {
                (get-variable var).value | Should match $new
            }
        }
    } #describe task variables
    Describe EmailSettings {

        <#
    not mocking New-JobTrigger or New-ScheduledJobOption
    Also assuming Pester test is being run on a platform where this will be true
    if ((Get-Module PSScheduledJob) -And (($PSVersionTable.Platform -eq 'Win32NT') -OR ($PSVersionTable.PSEdition -eq 'Desktop'))) 
    #>
        Mock Register-ScheduledJob {
            return 1
        } -Verifiable
        Mock Unregister-ScheduledJob {} -Verifiable
    
        #create a credential
        $p = ConvertTo-SecureString -String "Password" -AsPlainText -Force
        $cred = New-Object PSCredential "localhost\me", $p
    
        It "Should require a standard email address" {
            Mock Get-ScheduledJob { } -ParameterFilter {$Name -eq "myTasksEmail"}
            {Enable-EmailReminder -to foo@company.com -taskcredential $cred }| Should Not Throw
            {Enable-EmailReminder -to foo -taskcredential $cred}  | Should Throw
        } 

        It "Should fail if a job already exists" {
            Mock Get-ScheduledJob {
                return $True
            } -ParameterFilter {$Name -eq "myTasksEmail"}
            $r = Enable-EmailReminder -to foo@company.com -taskcredential $cred -WarningAction SilentlyContinue
            $r.count | Should Be 0
        } 

        It "Should register a scheduled job" {
            Mock Get-ScheduledJob {
                return $False
            } -ParameterFilter {$Name -eq "myTasksEmail"}
            $r = Enable-EmailReminder -to foo@company.com -taskcredential $cred 
            $r | Should Be 1
            Assert-MockCalled Register-ScheduledJob
        } 

        It "Should get a job result" {
            Mock Get-ScheduledJob {
         
                $result = @{
                    ID             = 1
                    Name           = "myTasksEmail"
                    Enabled        = $True
                    InvocationInfo = @{
                        Parameters = @{
                            ArgumentList = @{
                                SMTPServer = "mail.foo.com"
                                Port       = 587
                                BodyAsHTML = $True
                                Credential = $cred
                                From       = "foo@company.com"
                                UseSSL     = $True
                                To         = "foo@company.com"
                            }
                        }
                    }
                }
                return $result
            } -ParameterFilter {$Name -eq "myTasksEmail"} -Verifiable

            Mock Get-Job {
                $result = @{
                    ID          = 10
                    Name        = "myTasksEmail"
                    State       = "Completed"
                    PSBeginTime = (Get-Date "6/1/2018 7:00:01AM")
                    PSEndTime   = (Get-Date "6/1/2018 7:00:08AM")
                    Output      = "[6/1/2018 7:00:08 AM] Message (Tasks Due in the Next 3 Days) sent to foo@company.com from foo@company.com"
                }
                return $result
            } -ParameterFilter {$Name -eq "myTasksEmail" -AND $Newest -eq 1} -Verifiable

            $r = Get-EmailReminder
         
            Assert-MockCalled Get-ScheduledJob
            Assert-MockCalled Get-Job
            #$r | out-string | write-host -ForegroundColor CYAN
            $r | Should beoftype PSCustomobject
            $r.Task | Should be "myTasksEmail"
            $r.laststate | Should be "Completed"
        } 

        It "Should remove the email job" {
            Mock Get-ScheduledJob {
                return $True
            } -ParameterFilter {$Name -eq "myTasksEmail"}
            {Disable-EmailReminder} | Should Not Throw
            Assert-MockCalled Unregister-ScheduledJob
        } 
    }   #describe email settings 
} #in module
