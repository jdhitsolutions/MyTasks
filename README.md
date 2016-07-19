# MyTasks #

This PowerShell module is designed as a task or simple To-Do manager. The
module contains several commands for working with tasks. Task data is stored
in an XML file in the user's Documents folder. Here are a few highlights.

## Class based ##
This module requires PowerShell version 5.0 since is uses a class definition
for the task object. While you could use the object's properties and methods
directly, you should use the appropriate module command.

## Categories ##
The Task object includes a Category property. The module will define a default
set of categories, but users can create their own by using the MyTaskCategory
commands:

+ Add-MyTaskCategory
+ Get-MyTaskCategory
+ Remove-MyTaskCategory

## Colorized Output ##
Normally, you will use Get-MyTask to display tasks, all, some or a single item:

```
PS S:\> get-mytask -name MemoryTools

ID  Name         Description                DueDate OverDue Category  Progress
--  ----         -----------                ------- ------- --------  --------
8   MemoryTools  update module   7/22/2016 02:18 PM False   Projects        10
```
But there is also a command called *Show-MyTask* which will write output directly
to the host. Incomplete tasks that are overdue will be displayed in red text.
Tasks that will be due in 24 hours will be displayed in yellow.

Read full help and examples for all commands as well as the about_MyTasks help
file.

****************************************************************
DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED 
THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK. IF YOU DO 
NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, DO NOT USE
OUTSIDE OF A SECURE, TEST SETTING.      
****************************************************************

*updated July 19, 2016*