# PowerShell's apt-get update

This module provides functionality for PowerShellGet inspired by `apt-get update` Linux command. This is only proof-of-concept work.

## Explanation

TBD

## Commands

This module provides following commands:

### Cache Management

- `Update-PSRepositoryCache` - Downloads index file and expands it to local cache, equivalent to `apt-get update` Linux command.
- `New-PSRepositoryCache` - Generates zipped index file and uploads it to storage account. This is running as a scheduled task on dedicated server. Standard users do not need to run it.

### Search and Update Operations

- `Find-ModuleFromCache`   - finds modules in local cache
- `Find-ScriptFromCache`   - finds scripts in local cache
- `Find-CommandFromCache`  - finds command in local cache
- `Update-ModuleFromCache` - finds updatable modules in local cache, it **accepts wildcard '*'**; _for POC it supports -WhatIf simulation only_

## Examples

### Update-Index

```PowerShell
Update-PSRepositoryCache
```

Creates local repository cache. Internet connection is required. Should be run first, before other examples.

### Find-Command

```PowerShell
Find-CommandFromCache 'Get-Folder' | Select -First 3
```

```text
ModuleName                Name       Version         Repository
----------                ----       -------         ----------
VMware.VimAutomation.Core Get-Folder 11.0.0.10336080 PSGallery
WFTools                   Get-Folder 0.1.58          PSGallery
PSFolderSize              Get-Folder 1.6.3           PSGallery
```

### Update all modules

If called without any names, it will update all modules in the system. In this POC, actuall update is not implemented.

Please note from verbose output that commandlet in this mode is processing about 2-3 modules per second!
Standard commandlet `Update-Module` takes about 15 second to check for update of one module.

```PowerShell
Update-ModuleFromCache -Verbose
```

```text
VERBOSE: 29-Oct-18 10:35:26 PM Update-ModuleFromCache starting
VERBOSE: 10:35:26 PM  reading list of all modules from system
VERBOSE: 10:35:40 PM  checking EasyAzureFunction for updatable version
VERBOSE: Performing the operation "Update to version 0.7.1" on target "Module 'EasyAzureFunction' version 0.6".
VERBOSE: 10:35:40 PM  checking fifa2018 for updatable version
VERBOSE: 10:35:41 PM  checking Pester for updatable version
VERBOSE: 10:35:41 PM  checking Posh-SSH for updatable version
VERBOSE: 10:35:42 PM  checking PSCodeHealth for updatable version
VERBOSE: 10:35:42 PM  checking PSScriptAnalyzer for updatable version
VERBOSE: Performing the operation "Update to version 1.17.1" on target "Module 'PSScriptAnalyzer' version 1.17.0".
VERBOSE: 10:35:43 PM  checking ThreadJob for updatable version
VERBOSE: 10:35:43 PM  checking Azure.AnalysisServices for updatable version
VERBOSE: Performing the operation "Update to version 0.5.4" on target "Module 'Azure.AnalysisServices' version 0.5.1".
```

## Speed comparison

This is current speed comparison done from low-end computer located in Europe with 100Mbps Intenet conection.

If further speed improvement is needed, simple indexing can increase speed a few times.

### Find-CommandFromCache

```PowerShell
Measure-Command {1..10 | % {Find-Command 'Read-Credential' -Repository 'PSGallery'}} | Select TotalSeconds
Measure-Command {1..10 | % {Find-CommandFromCache 'Read-Credential'}} | Select TotalSeconds
```

```text
TotalSeconds
------------
  24.1530195
   1.4833271  # Find-CommandFromCache is about 16 times faster
```

### Find-ScriptFromCache

```PowerShell
Measure-Command {1..10 | % {Find-Script 'Get-FolderAge' -Repository 'PSGallery'}} | Select TotalSeconds
Measure-Command {1..10 | % {Find-ScriptFromCache 'Get-FolderAge'}} | Select TotalSeconds
```

```text
TotalSeconds
------------
  22.0200507
   0.6436848  # Find-ScriptFromCache is about 34 times faster
```

### Find-ModuleFromCache

```PowerShell
Measure-Command {1..10 | % {Find-Module 'FIFA2018' -Repository 'PSGallery'}} | Select TotalSeconds
Measure-Command {1..10 | % {Find-ModuleFromCache 'FIFA2018'}} | Select TotalSeconds
```

```text
TotalSeconds
------------
  21.9025661
   4.0735746  # Find-ModuleFromCache is about 5 times faster
```

### Update-ModuleFromCache

```PowerShell
Measure-Command {Update-Module 'EasyAzureFunction' -WhatIf} | Select TotalSeconds
Measure-Command {Update-ModuleFromCache 'EasyAzureFunction' -WhatIf} | Select TotalSeconds
```

```text
What if: Performing the operation "Update-Module" on target "Version '0.6' of module 'EasyAzureFunction', updating to version '0.7.1'".
What if: Performing the operation "Update to version 0.7.1" on target "Module 'EasyAzureFunction' version 0.6".

TotalSeconds
------------
  13.8118098
   0.8705567  # Update-ModuleFromCache is about 16 times faster
```

## Error handling

Module is also updating default `CommandNotFoundAction` error handler. As it is running fast, if it can, it will tell you how to add requested command! Just like in some Linux distros.

![Error Handling](Images/ErrorHandling.png)

## External Links

- **`apt-get update`** - [man page](https://linux.die.net/man/8/apt-get), [askubuntu.com](https://askubuntu.com/questions/222348/what-does-sudo-apt-get-update-do)
- **`PowerShellGet`** - [MSFT docs](https://docs.microsoft.com/en-us/powershell/module/powershellget), [GitHub repo](https://github.com/PowerShell/PowerShellGet)
