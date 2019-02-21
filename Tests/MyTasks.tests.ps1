
if (Get-Module -Name MyTasks) {
    Remove-Module -Name MyTasks
}

Import-Module -Name "$PSScriptRoot\..\Mytasks.psd1" -Force

Write-Host "These tests are designed for Windows PowerShell" -ForegroundColor yellow
$current = Get-Module myTasks
write-Host "Testing $($current.name) version $($current.Version)" -ForegroundColor yellow


InModuleScope MyTasks {

    Describe 'Categories' {
        BeforeAll {
            Set-MyTaskHome 'TestDrive:'
        }

        It 'has default categories "Work", "Personal", "Other", and "Customer"' {
            $script:myTaskDefaultCategories.Count | Should -Be 4
            $script:myTaskDefaultCategories -join "-"| Should -Match "Work"
            $script:myTaskDefaultCategories -join "-"| Should -Match "Personal"
            $script:myTaskDefaultCategories -join "-"| Should -Match "Other"
            $script:myTaskDefaultCategories -join "-"| Should -Match "Customer"
        }

        It 'keeps the default categories when a new one is added' {
            Add-MyTaskCategory -Category ToDo
            $Categories = Get-Content -Path $myTaskCategory -Raw

            $Categories | Should -Match 'Work'
            $Categories | Should -Match 'Personal'
            $Categories | Should -Match 'Other'
            $Categories | Should -Match 'Customer'
            $Categories | Should -Match 'ToDo'
        }

        It 'can add a Testing category to $myTaskCategory' {
            Add-MyTaskCategory -Category Testing
            $Categories = Get-Content -Path $myTaskCategory -Raw

            $myTaskCategory | Should -Exist
            $Categories | Should -Match 'Testing'
        }

        It 'can add multiple categories' {
            Add-MyTaskCategory -Category Work, Personal, Other, Training, Demo
            (Get-MyTaskCategory).Count| Should -Be 8
        }

        It 'dynamically recognizes all category values' {
            (Get-Command -Name New-MyTask).Parameters["Category"].Attributes.ValidValues.Count | Should -Be 8
        }

        It 'can remove a category' {
            Remove-MyTaskCategory -Category Demo
            (Get-MyTaskCategory).Count| Should -Be 7
        }

    } #describe my categories

    Describe 'Tasks' {
        <#
        It doesn't appear that you can consistently mock commands that might be used in a class
        so we'll use the actual date
    #>

        $Due = (Get-Date).AddDays(30).Date

        Set-MyTaskHome -path 'TestDrive:'

        Add-MyTaskCategory -Category Work, Personal, Other, Training, Testing

        It 'should create a new task' {
            $Task = New-MyTask -Name Test1 -DueDate $Due -Category Testing -Passthru
            $Task.Id | Should -Be 1
            $mytaskPath | Should -Exist
        }

        It 'should create a new task with a 7 day default due date' {
            $Task = New-MyTask -Name Test2 -Category Testing -Passthru
            $Target = "{0:ddMMyyyy}" -f (Get-Date).AddDays(7)
            $Tested = "{0:ddMMyyyy}" -f $Task.DueDate
            $Tested | Should -Be $Target
        }

        It 'should get tasks by name' {
            $Task = Get-MyTask -Name Test1

            $Task.ID | Should -Be 2
            $Task.Name | Should -Be "Test1"
            $Task.Category | Should -Be 'Testing'
            $Task.DueDate  | Should -Be $Due
            $Task.Overdue | Should -Be $False
        }

        It 'should get tasks by days due' {
            (Get-MyTask -DaysDue 30).Count | Should -Be 2
        }

        #add some other tasks
        New-MyTask -Name Alice -DueDate "12/31" -Category Testing
        New-MyTask -Name Bob -DueDate "10/01" -Category Work
        New-MyTask -Name Carol -DueDate "11/11" -Category Personal
        New-MyTask -Name Dave -DueDate "12/12" -Category Other

        It 'should get tasks by category' {
            (Get-MyTask -Category Testing).Count | Should -Be 3
        }

        It 'should get all tasks' {
            (Get-MyTask -All).Count | Should -Be 6
        }

        It 'should modify a task by name' {
            $Year = (Get-Date).Year + 1
            Set-MyTask -Name "Test1" -Progress 50 -Description "Pester Test" -DueDate "$Year-1-8"
            $Task = Get-MyTask -Name Test1
            $Task.Progress | Should -Be 50
            $Task.Description | Should -Be "Pester Test"
            $Task.DueDate | Should -Be ("$Year-1-8" -as [datetime])
            $Task.OverDue | Should -BeFalse
        }

        It 'should modify a task via the pipeline' {
            Get-MyTask -Name "Test1" | Set-MyTask -Progress 80
            $Task = Get-MyTask -Name Test1
            $Task.Progress | Should -Be 80
        }

        It 'Show-MyTask should write to the host' {
            {Show-MyTask | Get-Member -ErrorAction Stop} | Should -Throw
        }

        It 'should complete a task' {
            {Complete-Mytask -Name Test1 -ErrorAction Stop} | Should -Not -Throw
            (Get-MyTask -Completed | Measure-Object).Count | Should -Be 1
        }

        It 'should complete a task with a completion date' {
            {Complete-MyTask -Name Dave -CompletedDate "12/1"} | Should -Not -Throw
        }

        Context 'Archive' {

            It 'should complete and archive a task' {
                {Complete-Mytask -Name Test2 -Archive -ErrorAction Stop} | Should -Not -Throw
                (Get-MyTask -All | Where-Object {-not $_.Completed}).Count | Should -Be 3
            }

            It "should archive or save a task" {
                Get-MyTask -Completed | Save-MyTask
                $myTaskArchivePath | Should -Exist
                Get-MyTask -Name Test1 -WarningAction SilentlyContinue | Should -BeNull
                (Get-MyTask -All).Count | Should -Be 3
            }

            It 'should have an Archive-MyTask alias for Save-MyTask' {
                $Alias = Get-Alias -Name Archive-Mytask
                $Alias.Name | Should -Be "Archive-MyTask"
                $Alias.Definition | Should -Be "Save-MyTask"
            }
        }

        Context 'Backup' {
            It 'Should remove a task and backup the task file' {
                {Remove-MyTask -Name Alice } | Should -Not -Throw
                {Get-MyTask -Name Bob | Remove-MyTask } | Should -Not -Throw
                (Get-MyTask -All).Count | Should -Be 1
            }

            It 'should backup the task file' {
                {Backup-MyTaskFile -ErrorAction Stop} | Should -Not -Throw
                'TestDrive:\MyTasks_Backup_*.xml' | Should -Exist
            }
        }
    } #describe my tasks

    Describe 'Set-MyTaskHome' -Tag variables {

        BeforeAll {
            $NewFolder = New-Item -path $TestDrive -name MyTasks -ItemType Directory
            Set-MyTaskHome -Path $NewFolder.Fullname
            $target = $NewFolder.FullName.Replace("\", "\\")
        }

        $VariableTests = @(
            @{ Variable = 'myTaskArchivePath' }
            @{ Variable = 'myTaskCategory' }
            @{ Variable = 'mytaskhome' }
            @{ Variable = 'mytaskPath' }
        )

        It "should update <Variable>" -TestCases $VariableTests {
            param($Variable)
            Get-Variable $Variable -ValueOnly | Should -Match "^$target"
        }
    } #describe task variables

    Describe EmailSettings {
        <#
    not mocking New-JobTrigger or New-ScheduledJobOption
    Also assuming Pester test is being run on a platform where this will be true
    if ((Get-Module PSScheduledJob) -And (($PSVersionTable.Platform -eq 'Win32NT') -OR ($PSVersionTable.PSEdition -eq 'Desktop')))
    #>
        Mock Register-ScheduledJob { 1 } -Verifiable
        Mock Unregister-ScheduledJob {} -Verifiable
        Mock Get-ScheduledJob { $False } -ParameterFilter {$Name -eq "myTasksEmail"}

        #create a credential
        $Password = ConvertTo-SecureString -String "Password" -AsPlainText -Force
        $Credential = [PSCredential]::new("localhost\me", $Password)

        It 'should require a standard email address' {
            {Enable-EmailReminder -To foo@company.com -TaskCredential $Credential } | Should -Not -Throw
            {Enable-EmailReminder -To foo -TaskCredential $Credential}  | Should -Throw
        }

        It 'should register a scheduled job' {
            $Reminders = Enable-EmailReminder -To foo@company.com -TaskCredential $Credential
            $Reminders.Count | Should -Be 1

            Assert-MockCalled Register-ScheduledJob
        }
        It 'should fail if a job already exists' {
            Mock Get-ScheduledJob { $True } -ParameterFilter {$Name -eq "myTasksEmail"}
            $Reminders = Enable-EmailReminder -To foo@company.com -TaskCredential $Credential -WarningAction SilentlyContinue
            $reminders | out-string | write-host -ForegroundColor cyan
            $Reminders.Count | Should -Be 0
        }

        It 'should get a job result' {
            Mock Get-ScheduledJob {
                @{
                    ID             = 1
                    Name           = 'myTasksEmail'
                    Enabled        = $true
                    InvocationInfo = @{
                        Parameters = @{
                            ArgumentList = @{
                                SMTPServer = 'mail.foo.com'
                                Port       = 587
                                BodyAsHTML = $true
                                Credential = $cred
                                From       = 'foo@company.com'
                                UseSSL     = $true
                                To         = 'foo@company.com'
                            }
                        }
                    }
                }
            } -ParameterFilter {$Name -eq "myTasksEmail"} -Verifiable

            Mock Get-Job {
                @{
                    ID          = 10
                    Name        = "myTasksEmail"
                    State       = "Completed"
                    PSBeginTime = (Get-Date "6/1/2018 7:00:01AM")
                    PSEndTime   = (Get-Date "6/1/2018 7:00:08AM")
                    Output      = "[6/1/2018 7:00:08 AM] Message (Tasks Due in the Next 3 Days) sent to foo@company.com from foo@company.com"
                }
            } -ParameterFilter {$Name -eq "myTasksEmail" -and $Newest -eq 1} -Verifiable

            $Reminder = Get-EmailReminder

            Assert-MockCalled Get-ScheduledJob
            Assert-MockCalled Get-Job

            $Reminder | Should -BeOfType PSCustomobject
            $Reminder.Task | Should -Be "myTasksEmail"
            $Reminder.LastState | Should -Be "Completed"
        }

        It 'should remove the email job' {
            Mock Get-ScheduledJob {
                return $True
            } -ParameterFilter {$Name -eq 'myTasksEmail'}
            {Disable-EmailReminder} | Should -Not -Throw
            Assert-MockCalled Unregister-ScheduledJob
        }
    }   #describe email settings

} #in module scope

