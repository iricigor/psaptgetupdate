# PowerShell's apt-get update

This module provides functionality for PowerShellGet inspired by `apt-get update` Linux command. This is only proof-of-concept work.

## Explanation

TBD

## Commands

This module provides following commands:

### Cache Management

- `Update-PSRepositoryCache` - Downloads index file and expands it to local cache, equivalent to `apt-get update`
- `New-PSRepositoryCache` - Generates zipped index file and uploads it to storage account. This is running as scheduled task on dedicated server. It can be also executed locally.

### Search and Update Operations

- `Find-ModuleFromCache`  - finds modules in local cache
- `Find-ScriptFromCache`  - finds scripts in local cache
- `Find-CommandFromCache` - finds command in local cache

Search operations run on low end computer in less than 100ms. In future, these might be implemented as extension to equivalent commands from PowerShellGet.

### Update operations

- `Update-ModuleFromCache` - finds updatable modules in local cache, it **accepts wildcard '*'**; for POC it supports -WhatIf simulation only

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

```
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

## External Links

- **`apt-get update`** - [man page](https://linux.die.net/man/8/apt-get), [askubuntu.com](https://askubuntu.com/questions/222348/what-does-sudo-apt-get-update-do)
- **`PowerShellGet`** - [MSFT docs](https://docs.microsoft.com/en-us/powershell/module/powershellget), [GitHub repo](https://github.com/PowerShell/PowerShellGet)
