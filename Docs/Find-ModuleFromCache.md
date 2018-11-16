---
external help file: PSAptGetUpdate-help.xml
Module Name: PSAptGetUpdate
online version: https://github.com/iricigor/psaptgetupdate/blob/master/Docs/Find-ModuleFromCache.md
schema: 2.0.0
---

# Find-ModuleFromCache

## SYNOPSIS
Finds PowerShell modules with given name using local cache.

## SYNTAX

```
Find-ModuleFromCache [-ModuleName] <String[]> [<CommonParameters>]
```

## DESCRIPTION

The Find-ModuleFromCache cmdlet finds PowerShell modules with given name(s) using local cache.
Local cache is obtained/updated with command `Update-PSRepositoryCache` (or using its alias `psaptgetupdate`).
Searching local cache is about 20-100 times faster than online search performed via `Find-Module` command from PowerShellGet.

## EXAMPLES

### Example 1

```powershell
PS C:\> Find-ModuleFromCache FIFA2018,OutlookConnector | Select Name, Description
```

```text
Name             Description
----             -----------
fifa2018         Module gives result (including live), fixtures, team standings and others for FIFA 2018 - Football ...
OutlookConnector The module Outlook Connector will enable you to connect to MS Outlook session on your computer via ...
```

Returns information about modules from local cache. Search is not case sensitive.

## PARAMETERS

### -ModuleName

Specifies the names of one or more modules to search for.
Only modules that exactly match the specified names are returned.
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

### System.String[]

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
