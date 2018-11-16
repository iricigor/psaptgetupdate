---
external help file: PSAptGetUpdate-help.xml
Module Name: PSAptGetUpdate
online version:
schema: 2.0.0
---

# Find-CommandFromCache

## SYNOPSIS
Finds PowerShell commands with given name using local cache.

## SYNTAX

```
Find-CommandFromCache [-CommandName] <String[]> [<CommonParameters>]
```

## DESCRIPTION

The Find-CommandFromCache cmdlet finds PowerShell commands such as cmdlets using local cache.
Local cache is obtained/updated with command `Update-PSRepositoryCache` (or using its alias `psaptgetupdate`).
Searching local cache is about 20-100 times faster than online search performed via `Find-Command` command from PowerShellGet.

## EXAMPLES

### Example 1

```powershell
PS C:\> Find-CommandFromCache 'Get-Folder' | Select -First 3
```

```text
ModuleName                Name       Version         Repository
----------                ----       -------         ----------
VMware.VimAutomation.Core Get-Folder 11.0.0.10336080 PSGallery
WFTools                   Get-Folder 0.1.58          PSGallery
PSFolderSize              Get-Folder 1.6.3           PSGallery
```

This command runs in about 20 milliseconds, which is about 100 times faster than standard Find-Command.

## PARAMETERS

### -CommandName

Specifies the names of one or more commands to search for.
Only commands that exactly match the specified names are returned.
If no matches are found, no error is returned.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
