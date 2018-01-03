# MyTasks #

This PowerShell module is designed as a task or simple To-Do manager. The module contains several commands for working with tasks. Task data is stored in an XML file in the user's Documents folder. Here are a few highlights.

## Class based ##
This module requires PowerShell version 5.0 since is uses a class definition for the task object. While you could use the object's properties and methods directly, you should use the appropriate module command.

## Categories ##
The Task object includes a Category property. The module will define a default set of categories, but users can create their own by using the MyTaskCategory commands:

+ Add-MyTaskCategory
+ Get-MyTaskCategory
+ Remove-MyTaskCategory

## Colorized Output ##
Normally, you will use Get-MyTask to display tasks, all, some or a single item:

```
PS S:\> get-mytask -name MemoryTools

ID  Name         Description                DueDate OverDue Category  Progress
--  ----         -----------                ------- ------- --------  --------
8   MemoryTools  update module         ```7/22/2018 False   Projects        10
```
But there is also a command called *Show-MyTask* which will write output directly to the host. Incomplete tasks that are overdue will be displayed in red text. Tasks that will be due in 24 hours will be displayed in yellow. If you select all tasks then completed items will be displayed in green. This command may not work in the PowerShell ISE.

## Archiving and Removing ##
Over time your task file might get quite large. Even though the default behavior is to ignore completed tasks, you have an option to archive them to a separate XML file using Save-MyTask or when you run Complete-MyTask. Or you can completely delete a task with Remove-MyTask.

You should read full help and examples for all commands as well as the about_MyTasks help file.

- [Add-MyTaskCategory](https://github.com/jdhitsolutions/MyTasks/blob/master/docs/Add-MyTaskCategory.md)
- [Backup-MyTaskFile](https://github.com/jdhitsolutions/MyTasks/blob/master/docs/Backup-MyTaskFile.md)
- [Complete-MyTask](https://github.com/jdhitsolutions/MyTasks/blob/master/docs/Complete-MyTask.md)
- [Get-MyTask](https://github.com/jdhitsolutions/MyTasks/blob/master/docs/Get-MyTask.md)
- [Get-MyTaskCategory](https://github.com/jdhitsolutions/MyTasks/blob/master/docs/Get-MyTaskCategory.md)
- [New-MyTask](https://github.com/jdhitsolutions/MyTasks/blob/master/docs/New-MyTask.md)
- [Remove-MyTask](https://github.com/jdhitsolutions/MyTasks/blob/master/docs/Remove-MyTask.md)
- [Remove-MyTaskCategory](https://github.com/jdhitsolutions/MyTasks/blob/master/docs/Remove-MyTaskCategory.md)
- [Save-MyTask](https://github.com/jdhitsolutions/MyTasks/blob/master/docs/Save-MyTask.md)
- [Set-MyTask](https://github.com/jdhitsolutions/MyTasks/blob/master/docs/Set-MyTask.md)
- [Show-MyTask](https://github.com/jdhitsolutions/MyTasks/blob/master/docs/Show-MyTask.md)

## Limitations
This module is currently not intended or supported on PowerShell Core running on Linux or macOS..

Please post any issues, questions or feature requests in the [Issues](https://github.com/jdhitsolutions/MyTasks/issues) section.


*last updated 2 January 2018*