---
external help file: PSAptGetUpdate-help.xml
Module Name: psaptgetupdate
online version:
schema: 2.0.0
---

# Find-ScriptFromCache

## SYNOPSIS
Finds PowerShell scripts with given name using local cache.

## SYNTAX

```
Find-ScriptFromCache [-ScriptName] <String[]> [<CommonParameters>]
```

## DESCRIPTION

The Find-ScriptFromCache cmdlet finds PowerShell scripts with given name(s) using local cache.
Local cache is obtained/updated with command `Update-PSRepositoryCache` (or using its alias `psaptgetupdate`).
Searching local cache is about 20-100 times faster than online search performed via `Find-Script` command from PowerShellGet.

## EXAMPLES

### Example 1

```powershell
PS C:\> Find-ScriptFromCache 'Get-FolderAge' | Select Name, Description
```

```
Name          Description
----          -----------
Get-FolderAge Get-FolderAge returns `LastModifiedDate` for a specified folder(s) and if folders were modified after ...
```

## PARAMETERS

### -ScriptName

Specifies the names of one or more scripts to search for.
Only scripts that exactly match the specified names are returned.
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
