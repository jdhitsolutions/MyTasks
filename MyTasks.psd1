#
# Module manifest for module 'MyTasks'
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule           = 'MyTasks.psm1'

    # Version number of this module.
    ModuleVersion        = '2.1.0'

    CompatiblePSEditions = @("Desktop", "Core")

    # ID used to uniquely identify this module
    GUID                 = '6a5db6e0-9669-4178-a176-54b4931aa4e2'

    # Author of this module
    Author               = 'Jeff Hicks'

    # Company or vendor of this module
    CompanyName          = 'JDH Information Technology Solutions, Inc.'

    # Copyright statement for this module
    Copyright            = '(c) 2016-2019 JDH Information Technology Solutions, Inc. All rights reserved.'

    # Description of the functionality provided by this module
    Description          = 'A tool set for managing tasks or to-do projects in PowerShell. Task data is stored in XML and managed through a PowerShell class.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion    = '5.1'

    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the Windows PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module
    # CLRVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess     = "MyTasks.format.ps1xml", "mytaskpath.format.ps1xml"

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module

   FunctionsToExport    = if ($PSEdition -eq 'Desktop') {

   @("New-MyTask", "Set-MyTask", "Remove-MyTask", "Get-MyTask",
        "Show-MyTask", "Complete-MyTask", "Get-MyTaskCategory", "Add-MyTaskCategory",
        "Remove-MyTaskCategory", "Backup-MyTaskFile", "Save-MyTask", "Enable-EmailReminder",
        "Disable-EmailReminder", "Get-EmailReminder", "Set-MyTaskHome", "Get-MyTaskArchive",
        "Get-MyTaskHome")

} else {
        @("New-MyTask", "Set-MyTask", "Remove-MyTask", "Get-MyTask",
            "Show-MyTask", "Complete-MyTask", "Get-MyTaskCategory", "Add-MyTaskCategory",
            "Remove-MyTaskCategory", "Backup-MyTaskFile", "Save-MyTask", "Set-MyTaskHome",
            "Get-MyTaskArchive","Get-MyTaskHome")
}

    # Cmdlets to export from this module
    # CmdletsToExport = '*'

    # Variables to export from this module
    VariablesToExport    = @()
    #'myTaskPath','myTaskDefaultCategories','myTaskArchivePath','mytaskhome','myTaskCategory'

    # Aliases to export from this module
    AliasesToExport      = 'gmt', 'smt', 'shmt', 'rmt', 'cmt', 'nmt', 'Archive-MyTask', 'task',
    'Get-MyTaskPath', 'Set-MyTaskPath'

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData          = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = 'XML', 'ToDo', 'Projects', 'Tasks'

            # A URL to the license for this module.
            LicenseUri   = 'https://github.com/jdhitsolutions/MyTasks/blob/master/LICENSE.txt'

            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/jdhitsolutions/MyTasks/'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            ReleaseNotes = 'https://github.com/jdhitsolutions/MyTasks/blob/master/docs/about_MyTasks.md'

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}

