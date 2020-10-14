# Change Log for MyTasks

## v2.4.0

+ Restructured module layout
+ Removed `Show-MyTask` and modified default format view for `Get-MyTask` to use ANSI escape sequences instead of `Write-Host`. (Issue #44) *Breaking Change*
+ Added the aliases `Show-MyTask` and `shmt` to `Get-MyTask` to provide some sort of backward compatibility.
+ Modified `Get-EmailReminder` to display a warning if the scheduled job is not found.
+ Updated `Enable-EmailReminder` to better handle text output now that default formatting uses ANSI.
+ Updated Pester tests.
+ Help and documentation updates.

## v2.3.0

+ Updates to `Show-MyTask` to better handle long descriptions. (Issue #40 and #41)
+ Modified `Remove-MyTask` to remove by the ID number. (Issue #42)
+ Added online help links.
+ Updated `README.md`.
+ Updated help documentation.
+ Updated Pester tests.

## v2.2.0

+ Fixed bug where overdue tasks were not displaying in red.
+ Added a Table view called DueDate.
+ Minor help updates.
+ Minor updates to `README.md`.

## v2.1.0

+ Renamed `Set-MyTaskPath` to `Set-MyTaskHome` and set the original name as an alias. (Issue #38)
+ Renamed `Get-MyTaskPath` to `Get-MyTaskHome` and set the original name as an alias. (Issue #38)
+ Restructured module to better accommodate Desktop vs Core PSEditions. (Issue #37)
+ Manifest updates.
+ Documentation updates.
+ Updated Pester tests.

## v2.0.0

+ Updated manifest to require PowerShell 5.1 and support for both Desktop and Core PSEditions *Breaking Change*.
+ Added `Get-MyTaskPath` command.(Issue #36)
+ Added a format.ps1xml file for `Get-MyTaskPath`
+ Modified code to determine home folder to use `[Environment]::GetFolderPath([Environment+SpecialFolder]::MyDocuments)` Thank you @kilasuit and @thecliguy. (Issue #35) *Breaking Change*
+ Fixed bug in `Show-Mytask` where year is displayed in 2 digits instead of 4 on Linux platforms.
+ Documentation updates.

## v1.9.0

+ Updated the auto-completer to get task names and enclose in quotes.
+ Fixed bug in `Get-EmailReminder` to determine if the command is supported.
+ Modified `Save-MyTask` to provide more detail when using -Whatif.
+ Added `Get-MyTaskArchive` command.
+ Updated class and commands to better handle OverDue values.
+ Modified `MyTasks.format.ps1xml` to support myTaskArchive type.
+ Updated help.

## v1.8.2

+ Fixed bugs with the email reminder. Typo in a parameter name.
+ Added parameter validation for `-Days` in `Enable-EmailReminder`.
+ Help updates.

## v1.8.0

+ Fixed Task Category bug. Thank you @shaneis. (Issue #26)
+ Revised Pester test for category fix.
+ Updated `README.md`.

## v1.7.0

+ File cleanup for PowerShell Gallery.
+ M.ved aliases to function definitions
+ Added auto completer for `Get-MyTask`, `Set-MyTask`, `Complete-MyTask`, and `Remove-MyTask`. (Issue #32)
+ Updated `Get-MyTask` to support multiple ID numbers. (Issue #31)
+ Help documentation update.
+ General code cleanup.

## v1.6.0

+ Fixed bug saving XML to non-filesystem paths. (Issue #28)
+ Update `Set-MyTaskPath` to support -Passthru. (Issue #25)
+ Updated `Get-EmailReminder` to include additional details. (Issue #18)
+ Fixed CSS bug in email scriptblock.
+ Updated `Enable-EmailReminder` to allow the user to specify the number of days. (Issue #29)
+ Updated `Enable-EmailReminder` to allow the user to specify an alternate path. (Issue #30)
+ Updated Pester tests.
+ Updated documentation.

## v1.5.1

+ Fixed a bug with MyTaskCategory. (Issue #27)

## v1.5.0

+ Added a patch to store the date in an ISO friendly format. (Issue #23 and Issue #22)
+ Added a new function, `Set-MyTaskPath` to allow you to update the task folder. (Issue #20)
+ Updated documentation.

## v1.4.0

+ Added support for PowerShell scheduled job to email upcoming tasks. (Issue #17)
+ Scheduled reminders will be a Windows-only feature.
+ Added timestamp to verbose messages.

## v1.3.1

+ Fixed a bug with `Show-Task` when no entries are found. (Issue #16)
+ Updated README.

## v1.3.0

+ Updated README.
+ Added 'task' as an alias for `New-MyTask`.
+ Added CompletedDate parameter to `Complete-MyTask`. (Issue #13)
+ Added option to complete a task by ID. (Issue #11)
+ Changed default for `Get-MyTask` and `Show-MyTask` to display tasks due in the next 30 days. (Issue #12)
+ Fixed bug in `Show-MyTask` where completed tasks were displaying in red.
+ Made parameters for `New-MyTask` positional. (Issue #14)
+ Updated help documentation.

## v1.2.0

+ Modified files to support PowerShell Core.
+ Update help documentation.
+ Updated `README.md`.
+ Updated manifest.

## v1.1.0

+ Updated verbose messages.
+ Moved class definition to functions script.
+ Revised Pester tests.

## v1.0.4

+ Explicitly added UTF8 encoding when reading and writing XML content.
+ Explicitly added Unicode encoding when reading and writing task category file. (Issue #4)
+ Modified `Show-MyTask` to format as a table with auto-sizing and string streaming.
+ Updated manifest.

## v1.0.3

+ Modified code when creating a new XML fil to specify encoding as UTF-8.
+ Modified `Get-MyTask` to display a warning when trying to display tasks when none have been defined yet.
+ Modified `Show-MyTask` to work under the Windows 10 PowerShell ISE. (Issue #2)
+ Modified `Remove-MyTask` to accept MyTask as an input object. (Issue #3)
+ Updated `README.md`

## v1.0.2

+ Modified `New-MyTask` so that when using the `-Passthru` parameter, it displays the correct ID. (Issue #1)

## v1.0.1

+ Added Pester tests.
+ Fixed a bug with exported variables.

## v1.0.0

+ Added license file.
+ Initial release

## v0.0.16

+ Added help documentation.
+ Revised `Save-MyTask` to save a single task.
+ Revised `Complete-MyTask` to archive a single task.
+ Modified `Get-MyTask` to allow wildcards for -Name.

## v0.0.15

+ Fixed a regular expression bug in `Show-MyTask` that wasn't properly capturing completed tasks.
+ Modified `Show-MyTask` to display completed tasks in green.
+ Added command `Save-MyTasks` move completed tasks to an archive file.
+ Modified `Complete-MyTask` with an option to archive tasks.

## v0.0.14

+ Modified `Set-MyTask` to use task ID.
+ Fixed a regular expression bug in `Show-MyTask`.

## v0.0.13

+ Renamed Backup-MyTask to `Backup-MyTaskFile`.
+ Modified module to export `Backup-MyTaskFile`.
+ Modified `Remove-MyTask` to use `Backup-MyTaskFile`.

## v0.0.12

+ Added `Backup-MyTask`.
+ Modified the `mytasks.format.ps1xml` file to display DueDate without time when using tables. Format-List will show full DueDate value.
+ Added parameter to `New-MyTask` to allow specifying the number of days instead of an actual date.

## v0.0.11

+ Modified `Get-MyTask` to not include completed tasks when filtering by DaysDue or Category.
+ Added `Get-MyTaskCategory`.
+ Added `Add-MyTaskCategory`.
+ Added `Remove-MyTaskCategory`.

## v0.0.10

+ Modified `Get-MyTask` to support filtering by the number of days due.
+ Modified Refresh() method to not mark a task as overdue if it is completed.
+ Modified `Show-MyTask` to not flag Completed tasks.
+ Modified `Get-MyTask` to automatically sort on DueDate.

## v0.0.9

+ Added comment based help.
+ Changed TaskCategory to a string and used dynamic parameters in functions.
+ Modified `Show-MyTask` to support -Category.
+ Adjusted settings in format.ps1xml file.

## v0.0.8

+ Updated `MyTasks.format.ps1xml` file with new views.
+ Updated `MyTasks.format.ps1xml` to format DueDate.
+ Added verbose output to commands.
+ Modified `Get-MyTask` to support filtering by Category.
+ Modified `Show-MyTask` to display in yellow if the due date is 24 hours or less.

## v0.0.7

+ Added `MyTasks.format.ps1xml`.
+ Fixed a bug in `Set-MyTask` when there was an empty value.
+ Updated module files.

## v0.0.6

+ Added `Complete-MyTask` function.
+ Fixed a bug in `New-MyTask` when the XML file exists but has no objects.
+ Added -WhatIf to `New-MyTask`.

## v0.0.5

+ Added `Set-MyTask` function.
+ Modified `Get-MyTask` to take the task name as a positional parameter.
+ Added command aliases.
+ Updated module files.

## v0.0.4

+ Added `Remove-MyTask` function.

## v0.0.3

+ Added `Show-MyTask` function.

## v0.0.2

+ Import tasks from an XML file.
+ Get tasks from an XML file with options.
+ Separated functions into separate files.
+ Modified class so that OverDue and ID values are calculated at runtime.
+ Added changelog.

## v0.0.1

+ Added core module files.
