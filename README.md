# PowerShell's apt-get update

This module provides functionality for PowerShellGet inspired by `apt-get update` Linux command. This is only proof-of-concept work, though it is (almost) fully functional. 

## Explanation

Currently PowerShell and PowerShellGet are having following two issues\feature requests which are related to each other:

- Finding information about modules and scripts is very slow. It is running over the Internet and last about two seconds. This implementation speeds search commands 100 times, downto 20 ms!
- When user types command which they do not have installed on the system, we can instruct them how to install it in some cases.

Core of the module is local index (cache) of all modules, scripts and commands which is just simply downloaded from the repository.
Generated index file is prepared (generated and zipped) on a dedicated cloud VM, but command for that is also included in the module.
For verification, it can be also executed locally.

It would be good to implement this functionality in PowerShellGet and PowerShell Gallery directly.

For more details, see (illustrated) [design page](Design.md).

## Speed comparison

Actual speed will depend on your local system, namely of a disk and processor speed.
Results below are from medium class personal computer.
On low end machines, results will not be more than 2-3 times slower, which is still 20-50 times faster than already existing commands.

If further speed improvement is needed, simple indexing can increase speed a few times.

### Results for 10 repetitions (in seconds)

 10x executed | Find-Command | Find-Script | Find-Module
-- | -- | -- | --
old commands | 22.9751159 | 23.0243 | 23.4820757
new commands | 0.2507481 | 0.188659 | 0.1713624

### How testing was done

Testing was done executing commands similar to the ones below.
Test was repeated 5 times and middle result was recorded.

```PowerShell
Measure-Command {1..10 | % {Find-Command 'Read-Credential' -Repository 'PSGallery'}} | Select TotalSeconds
Measure-Command {1..10 | % {Find-CommandFromCache 'Read-Credential'}} | Select TotalSeconds
```

## Error handling

Module is also updating default `CommandNotFoundAction` error handler. As it is running fast, if it can, it will tell you how to add requested command! Just like in some Linux distros.

![Error Handling](Images/ErrorHandling.png)

## How to install

You can install this module in a couple of ways listed below.

- **From PowerShell Gallery** _(preferred way)_:

Module can be installed from [PS Gallery](https://www.powershellgallery.com/packages/psaptgetupdate) using the command 

```PowerShell
Install-Module psaptgetupdate -Scope CurrentUser
```

- **Clone repository:**

If you want to see the entire GitHub repository, just clone it and import module afterwards.

```PowerShell
git clone https://github.com/iricigor/psaptgetupdate.git
Import-Module .\psaptgetupdate.psd1 -Force
```



## Commands

This module provides following commands:

### Cache Management

- `Update-PSRepositoryCache` (alias PSAptGetUpdate)- Downloads index file and expands it to local cache, equivalent to `apt-get update` Linux command.
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

Creates local repository cache. Internet connection is required. Should be run first, before other examples. Command runs for about 4-5 seconds.
If executed with -Verbose switch, you may actually see how old is server version of index file.

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

This command runs in about 20 milliseconds, which is about 100 times faster than standard `Find-Command`.

### Update all modules

If called without any names, this command will update all modules in the system. In this POC, actual update is not implemented, so you need to run it with `-Verbose` or -`WhatIf` to see actual updatable modules.

Please note from verbose output that commandlet in this mode is processing dozens of modules per second!
Standard commandlet `Update-Module` takes about 15 second to check for update of one module.

```PowerShell
Update-ModuleFromCache -Verbose
```

```text
VERBOSE: 31-Oct-18 10:47:50 PM Update-ModuleFromCache starting
VERBOSE: 10:47:50 PM Reading list of all modules from the system
VERBOSE: 10:48:12 PM checking module ClipboardText for updatable version
VERBOSE: 10:48:12 PM Performing action Update to version 0.1.7 on target Module 'ClipboardText' version 0.1.1
VERBOSE: Performing the operation "Update to version 0.1.7" on target "Module 'ClipboardText' version 0.1.1".
VERBOSE: 10:48:12 PM checking module EasyAzureFunction for updatable version
VERBOSE: 10:48:12 PM Performing action Update to version 0.7.1 on target Module 'EasyAzureFunction' version 0.6
VERBOSE: Performing the operation "Update to version 0.7.1" on target "Module 'EasyAzureFunction' version 0.6".
VERBOSE: 10:48:12 PM checking module fifa2018 for updatable version
VERBOSE: 10:48:12 PM Performing action Update to version 0.2.45 on target Module 'fifa2018' version 0.1.11
VERBOSE: Performing the operation "Update to version 0.2.45" on target "Module 'fifa2018' version 0.1.11".
VERBOSE: 10:48:12 PM checking module Plaster for updatable version
VERBOSE: 10:48:12 PM checking module platyPS for updatable version
VERBOSE: 10:48:12 PM Performing action Update to version 0.12.0 on target Module 'platyPS' version 0.11.1
VERBOSE: Performing the operation "Update to version 0.12.0" on target "Module 'platyPS' version 0.11.1".
```

## External Links

- **`apt-get update`** - [man page](https://linux.die.net/man/8/apt-get), [askubuntu.com](https://askubuntu.com/questions/222348/what-does-sudo-apt-get-update-do)
- **`PowerShellGet`** - [MSFT docs](https://docs.microsoft.com/en-us/powershell/module/powershellget), [GitHub repo](https://github.com/PowerShell/PowerShellGet)

## Build status

Each commit or PR to master is checked on [Azure DevOps](https://azure.microsoft.com/en-us/services/devops/) [Pipelines](https://azure.microsoft.com/en-us/services/devops/pipelines/) on two build systems:


1. Ubuntu **Linux** v.16.04 LTS host running PowerShell (Core) v.6.1 [![Windows Build Status](https://dev.azure.com/iiric/PSAptGetUpdate/_apis/build/status/PSAptGetUpdate-CI-Linux)](https://dev.azure.com/iiric/PSAptGetUpdate/_build/latest?definitionId=9)
2. **Windows** host running Windows PowerShell v.5.1 [![Windows Build Status](https://dev.azure.com/iiric/PSAptGetUpdate/_apis/build/status/PSAptGetUpdate-CI-Win)](https://dev.azure.com/iiric/PSAptGetUpdate/_build/latest?definitionId=8)

## Support

You can chat about this commandlet via [Skype](https://www.skype.com) _(no Skype ID required)_, by clicking a link below.

[![chat on Skype](https://img.shields.io/badge/chat-on%20Skype-blue.svg?style=flat)](https://join.skype.com/hQMRyp7kwjd2)

## Contributing

If you find any problems, feel free to open a new issue.

![GitHub open issues](https://img.shields.io/github/issues/iricigor/psaptgetupdate.svg?style=flat)
![GitHub closed issues](https://img.shields.io/github/issues-closed/iricigor/psaptgetupdate.svg?style=flat)

If you want to contribute, please fork the code and make a new PR after!

![GitHub](https://img.shields.io/github/license/iricigor/psaptgetupdate.svg?style=flat)
![GitHub top language](https://img.shields.io/github/languages/top/iricigor/psaptgetupdate.svg?style=flat)


## Module icon

Module icon represents **faster update symbol** in PowerShell similar colors.

![Fast Update icon](Images/psaptgetupdate-icon-256.png "Fast Update icon")