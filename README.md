# PowerShell apt-get update

This module provides functionality for PowerShellGet inspired by apt-get update command. This is only proof-of-concept work.

## Explanation

## Commands

This module provides following commands:

### Server side

- `New-Index` - generates zipped index file and uploads it to storage account

### Client cache

- `Update-Index` - downloads index file and expands it to local cache

### Search operations

- `Find-ModuleInCache`  - finds modules in local cache
- `Find-ScriptInCache`  - finds scripts in local cache
- `Find-CommandInCache` - finds command in local cache

Search operations run on low end computer in less than 100ms.

### Upgrade operations

- `Update-ModuleInCache` - finds updatable modules in local cache, and triggers updates, **it accepts wildcard '*'**; for POC it supports -WhatIf simulation only

## Examples

### Update-Index

```PowerShell
Update-Index
```

Creates local repository cache. Internet connection is required. Should be run first, before other examples.

### Find-Command

```PowerShell
Find-CommandInCache 'Get-Folder' | Select -First 3
```

```
ModuleName                Name       Version         Repository
----------                ----       -------         ----------
VMware.VimAutomation.Core Get-Folder 11.0.0.10336080 PSGallery
WFTools                   Get-Folder 0.1.58          PSGallery
PSFolderSize              Get-Folder 1.6.3           PSGallery
```

### Update all modules

```PowerShell
Update-ModuleInCache * -WhatIf
```

TBD

## Links

- **`apt-get update`** - [man page](https://linux.die.net/man/8/apt-get), [askubuntu.com](https://askubuntu.com/questions/222348/what-does-sudo-apt-get-update-do)
- **`PowerShellGet`** - [MSFT docs](https://docs.microsoft.com/en-us/powershell/module/powershellget), [GitHub repo](https://github.com/PowerShell/PowerShellGet)
