# MyTasks

## about_MyTasks

## SHORT DESCRIPTION

The commands in the module are intended to be used as a simple solution for
personal project management or as a more extensive To-Do list. The goal is
to put all of your work items at your fingertips in a PowerShell session. At
a glance you should be able to see project status and update your tasks.

## LONG DESCRIPTION

The core of this module is an object defined in a PowerShell class. The
class has a number of properties, some of which are hidden, meaning you won't
see them unless you specify the property name.

Note: ID and OverDue values are calculated at run time.

    [int]$ID
    [string]$Name
    [string]$Description
    [datetime]$DueDate
    [bool]$Overdue
    [String]$Category
    [ValidateRange(0,100)][int]$Progress
    hidden[bool]$Completed
    hidden[datetime]$TaskCreated = (Get-Date)
    hidden[datetime]$TaskModified
    hidden[guid]$TaskID = (New-Guid)

A MyTask object might look like this:

    ID           : 8
    Name         : Lab Setup
    Description  : DSC Labs
    DueDate      : 9/1/2018 12:00:00 AM
    Overdue      : False
    Category     : Work
    Progress     : 0

The class methods are invoked by the different functions within this module.
The ID property is calculated at run time when all the tasks are loaded
into the PowerShell session. These numbers might change in the same way
that job numbers change from session to session. The hidden TaskID is the
unique id for each task.

### Design

All task information is stored in an XML file which is created in the user's
documents folder. On Linux with PowerShell Core the $home folder will be used.
This path is stored as a global variable myTaskPath and will have a value like:
C:\Users\Jeff\Documents\myTasks.xml. There is also an XML file for archiving
completed tasks. This too is in the Documents or $home folder and can be
referenced via the myTaskArchivePath variable.

NOTE: Starting with version 2.0.0 of this module the home location is determined
by using [Environment]::GetFolderPath([Environment+SpecialFolder]::MyDocuments)
Use the `Get-MyTaskHome` command to view your current settings. Use the
`Set-MyTaskHome` to modify the home variable. All other variables will be set
from that.


As tasks are created, modified, completed and archived, these XML files are
updated. `Select-XML` is used extensively to make this process as efficient as
possible.

### Categories

The MyTask object has a provision to tag or label each task with a category.
By default the class includes an enumeration with a default set of categories:

+ Work
+ Personal
+ Other
+ Customer

Or you can create your own text list of categories which override the
default settings. For example, you might want to add a priority category
such as High, Medium and Low.

The module is designed to look for a specific text file of category names.
Instead of manually creating the text file, it is strongly recommended to
use the MyTaskCategory commands.

+ Add-MyTaskCategory
+ Get-MyTaskCategory
+ Remove-MyTaskCategory

The commands should be self-explanatory. It is also recommended to keep your
custom category list as short as possible as several commands have a dynamic
parameter to expand this list. You should avoid removing any item from a
custom category list as long as you have an active task with that category.

### Creating a Task

Use the `New-MyTask` command to create a new task. The required parameters are
Name and Category. You can specify a deadline date or a number of days in
which to complete the task. If you don't specify anything the default is 7
days from the current date.

    New-MyTask -Name "Rebuild DC02" -Category Work -Days 30

### Displaying a Task

The `Get-MyTask` command will read all tasks from the task XML file and create
mytask objects. During this process the OverDue property is calculated based
on comparing the current date to the DueDate. All tasks will be assigned an
ID value. Tasks are sorted by due date in descending order and completed
tasks are filtered out by default. This means that you might see gaps in the
IDs. Use the -All property to display everything or -Completed to see only
completed tasks.

The module includes a custom format type extension file which includes
several custom views. You can try commands like these:

    Get-Mytask | Sort-Object Category | format-table -view Category
    Get-Mytask | format-list -view All

The second command is especially useful as it will display all properties,
even hidden ones.

An alternative to `Get-MyTask` is `Show-MyTask`. This command behaves the same
as `Get-MyTask` except that output is written directly to the console using
`Write- Host` so that it can be colorized. Overdue tasks will be displayed in
Red. Items that are due in the next 24 hours will be displayed in Yellow.
Completed tasks will be displayed in Green.

### Modifying a Task

Use `Set-MyTask` to modify an existing task. You can update any combination of
these properties:

+ Name
+ Category
+ DueDate
+ Description
+ Progress

You can specify a task by its name or ID, although it might be easiest to
use `Get-MyTask` and pipe to `Set-MyTask`.

    Get-MyTask -id 6 | Set-MyTask -Progress 33 -DueDate 8/20/2018 -Passthru

    ID  Name            Description          DueDate OverDue Category     Progress
    --  ----            -----------          ------- ------- --------     --------
    6   Rebuild DC02                       8/20/2018 False   Work               33

### Completing a Task

When a task if finished, use `Complete-MyTask` to mark it as complete. This
will set the Progress to 100 and set the hidden Completed property to TRUE.

    Get-MyTask -id 6 | Complete-MyTask

The completed task will remain in the task XML file until you archive it or
delete it. You can delete any task from the XML file with `Remove-MyTask`.

### Archive and Backup

If you will be making changes to your tasks, you might want to backup the
XML task file. Instead of manually copying the file use the `Backup-MyTask`
command. By default the command will create a backup copy in your documents
folder using a timestamp filename.

    PS C:\> backup-mytaskfile -Passthru

        Directory: C:\Users\Jeff\documents


    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    -a----        7/19/2018   6:19 PM          16461 MyTasks_Backup_20180719.xml

Or you can specify your own location and file name.

Finally, if you have a number of completed tasks that you wish to save but
not be imported every time you run `Get-MyTask`, you can archive them to a
separate XML file. The command is technically called `Save-MyTask` but you
can also use its alias `Archive-MyTask`.

    PS C:\> archive-mytask

By default all completed tasks will be removed from the tasks XML file and
stored in a file called myTasksArchive.xml in the user's documents folder.
You also have the option of archiving specific tasks. This will move the
task to the new file in its current state.

    PS C:\> get-mytask TaskX | save-mytask -Path C:\Work\Other.xml

You can also archive a file when completing it.

    Complete-MyTask -Name "setup CEO laptop" -archive

Although this will automatically archive it to the myTasksArchive.xml file.
There is no provision to specify an alternate location like `Save-MyTask`.
Use the `Get-MyTaskArchive` to retrieve archived tasks.

### Email Reminder

If you are running this module on Windows PowerShell with the PSScheduled
jobs module you can create a scheduled PowerShell job to send a daily email
message showing tasks that are due in the next 3 days or whatever you choose.
The default behavior is to send a text message but you can send an HTML
message which will add color coding to highlight overdue and impending tasks.

Use `Enable-EmailReminder` to set up the scheduled job. The default time is
8:00AM daily but you can pick a different time. The job name is hard coded.
You will need to re-enter your current credentials for the task so that the
task scheduler has access to the network. Run `Disable-EmailReminder` to remove
the task in case you want to change it. `Get-EmailReminder` will show you the
current state of the task.

## NOTE

This module is not intended as a full-feature project management tool. It is
intended to serve as a light-weight reminder or to-do list system. However,
feature requests and comments are welcome on the project's GitHub site at
https://github.com/jdhitsolutions/MyTasks.

## TROUBLESHOOTING NOTE

There are no known issues at this time.

## SEE ALSO

## KEYWORDS

+ task
+ project
+ to-do
