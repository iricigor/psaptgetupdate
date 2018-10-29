# PowerShell's apt-get update

This module provides functionality for PowerShellGet inspired by `apt-get update` Linux command. This is only proof-of-concept work.

## Explanation

TBD

## Commands

This module provides following commands:

### Cache Management

- `Update-PSRepositoryCache` - Downloads index file and expands it to local cache, equivalent to `apt-get update`
- `New-PSRepositoryCache` - Generates zipped index file and uploads it to storage account. This is running as a scheduled task on dedicated server. It can be also executed locally.

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

```PowerShell
Update-ModuleFromCache * -WhatIf
```

TBD

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

## External Links

- **`apt-get update`** - [man page](https://linux.die.net/man/8/apt-get), [askubuntu.com](https://askubuntu.com/questions/222348/what-does-sudo-apt-get-update-do)
- **`PowerShellGet`** - [MSFT docs](https://docs.microsoft.com/en-us/powershell/module/powershellget), [GitHub repo](https://github.com/PowerShell/PowerShellGet)
