if (Get-Module -Name MyTasks) {
    Remove-Module -Name MyTasks
}

Import-Module -Name "$PSScriptRoot\..\Mytasks.psd1" -Force

Describe 'MyTasks' {

    $Module = Get-Module -Name MyTasks
    It 'should have 15 functions' {
        $Module.ExportedFunctions.count | Should -Be 16
    }

    It 'should have 8 aliases command' {
        $Module.ExportedAliases.Count | Should -Be 8
    }

    It 'should not export any variables' {
        $Module.ExportedVariables.Count | Should -Be 0
    }

    $modvariables = @(
        @{Variable = 'myTaskArchivePath'}
        @{Variable = 'myTaskCategory'}
        @{Variable = 'mytaskhome'}
        @{Variable = 'mytaskPath'}
    )

    It 'should define a global variable called <Variable>' -TestCases $modVariables {
        param ($Variable)
        {Get-Variable -Name $variable -Scope global} | Should -Not -Throw
    }
    It 'should have a formatting xml file' {
        $Module.ExportedFormatFiles.Count | Should -Be 1
    }

    It 'should have an about help topic' {
        {Get-Help about_mytasks} | Should -Not -Throw
    }

    It 'requires PowerShell 5.0' {
        $Module.PowerShellVersion | Should -Be '5.0'
    }
} #describe my module

Describe "Functions" {

    $cmds = @(
        @{Name = 'Disable-EmailReminder'}
        @{Name = 'Enable-EmailReminder'}
        @{Name = 'Get-EmailReminder'}
        @{Name = 'New-MyTask'}
        @{Name = 'Set-MyTask'}
        @{Name = 'Save-MyTask'}
        @{Name = 'Remove-MyTask'}
        @{Name = 'Complete-MyTask'}
        @{Name = 'Show-MyTask'}
        @{Name = 'Get-MyTask'}
        @{Name = 'Add-MyTaskCategory'}
        @{Name = 'Get-MyTaskCategory'}
        @{Name = 'Remove-MyTaskCategory'}
        @{Name = 'Backup-MyTaskFile'}
        @{Name = 'Set-MyTaskPath'}
        @{Name = 'Get-myTaskArchive'}
    )

    It "<Name> has external help defined with at least one example" -TestCases $cmds {
        param($Name)
        $help = Get-Help $Name
        $help.Description | Should -Not -BeNullOrEmpty
        $help.Examples | Should -Not -BeNullOrEmpty
    }

    Context 'Enable-EmailReminder' {
        $cmd = Get-Command -Name Enable-EmailReminder
        $params = "TO", "TASKCREDENTIAL"
        Foreach ($item in $params) {
            It "should have a mandatory $item parameter" {
                ($cmd.parameters["$item"].Attributes).where( {$_.typeid.name -match 'parameterAttribute'}).Mandatory | Should -be $True
            }
        }
    }

    Context 'New-MyTask' {
        $cmd = Get-Command -Name New-MyTask
        $params = "NAME", "CATEGORY"
        Foreach ($item in $params) {
            It "should have a mandatory $item parameter" {
                ($cmd.parameters["$item"].Attributes).where( {$_.typeid.name -match 'parameterAttribute'}).Mandatory | Should -be $True
            }
        }
        $params = 'NAME'.'DUEDATE'.'DESCRIPTION'.'CATEGORY'
        Foreach ($item in $params) {
            It "should have a $item parameter that accepts pipeline input by name" {
                ($cmd.parameters["$item"].Attributes).where( {$_.typeid.name -match 'parameterAttribute'}).ValueFromPipelineByPropertyName | Should -be $True
            }
        }
    }
    Context 'Set-MyTask' {
        $cmd = Get-Command -Name Set-MyTask
        $params = "NAME"
        Foreach ($item in $params) {
            It "should have a mandatory $item parameter" {
                ($cmd.parameters["$item"].Attributes).where( {$_.typeid.name -match 'parameterAttribute'}).Mandatory | Should -be $True
            }
        }

        $params = "NAME"
        Foreach ($item in $params) {
            It "should have a $item parameter that accepts pipeline input by name" {
                ($cmd.parameters["$item"].Attributes).where( {$_.typeid.name -match 'parameterAttribute'}).ValueFromPipelineByPropertyName | Should -be $True
            }
        }
    }
    Context 'Save-MyTask' {
        $cmd = Get-Command -Name Save-MyTask
        $params = "TASK"
        Foreach ($item in $params) {
            It "should have a $item parameter that accepts pipeline input by value" {
                ($cmd.parameters["$item"].Attributes).where( {$_.typeid.name -match 'parameterAttribute'}).ValueFromPipeline| Should -be $True
            }
        }
    }
    Context 'Remove-MyTask' {
        $cmd = Get-Command -Name Remove-MyTask
        $params = "NAME", 'INPUTOBJECT'
        Foreach ($item in $params) {
            It "should have a mandatory $item parameter" {
                ($cmd.parameters["$item"].Attributes).where( {$_.typeid.name -match 'parameterAttribute'}).Mandatory | Should -be $True
            }
        }
    }
    Context 'Complete-MyTask' {
        $cmd = Get-Command -Name Complete-MyTask
        $params = "NAME", 'ID'
        Foreach ($item in $params) {
            It "should have a mandatory $item parameter" {
                ($cmd.parameters["$item"].Attributes).where( {$_.typeid.name -match 'parameterAttribute'}).Mandatory | Should -be $True
            }
        }
    }

    Context 'Add-MyTaskCategory' {
        $cmd = Get-Command -Name Add-MyTaskCategory
        $params = "CATEGORY"
        Foreach ($item in $params) {
            It "should have a mandatory $item parameter" {
                ($cmd.parameters["$item"].Attributes).where( {$_.typeid.name -match 'parameterAttribute'}).Mandatory | Should -be $True
            }
        }
        Foreach ($item in $params) {
            It "should have a $item parameter that accepts pipeline input by value" {
                ($cmd.parameters["$item"].Attributes).where( {$_.typeid.name -match 'parameterAttribute'}).ValueFromPipeline| Should -be $True
            }
        }
    }

    Context 'Remove-MyTaskCategory' {
        $cmd = Get-Command -Name Remove-MyTaskCategory
        $params = "CATEGORY"
        Foreach ($item in $params) {
            It "should have a mandatory $item parameter" {
                ($cmd.parameters["$item"].Attributes).where( {$_.typeid.name -match 'parameterAttribute'}).Mandatory | Should -be $True
            }
        }
        Foreach ($item in $params) {
            It "should have a $item parameter that accepts pipeline input by value" {
                ($cmd.parameters["$item"].Attributes).where( {$_.typeid.name -match 'parameterAttribute'}).ValueFromPipeline| Should -be $True
            }
        }
    }

    Context 'Set-MyTaskPath' {
        $cmd = Get-Command -Name Set-MyTaskPath
        $params = "PATH"
        Foreach ($item in $params) {
            It "should have a mandatory $item parameter" {
                ($cmd.parameters["$item"].Attributes).where( {$_.typeid.name -match 'parameterAttribute'}).Mandatory | Should -be $True
            }
        }
    }

    Context 'Get-MyTaskArchive' {
        
    }

} #describe functions