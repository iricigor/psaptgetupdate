---
external help file: PSAptGetUpdate-help.xml
Module Name: PSAptGetUpdate
online version: https://github.com/iricigor/psaptgetupdate/blob/master/Docs/Update-ModuleFromCache.md
schema: 2.0.0
---

# Update-ModuleFromCache

## SYNOPSIS
Checks if there is newer version of specified modules from a local cache.

## SYNTAX

```
Update-ModuleFromCache [[-ModuleName] <String[]>] [-NamesOnly] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The Update-ModuleFromCache cmdlet finds PowerShell modules with given name(s) which can be updated to newer version using local cache.
If name is omitted, it will search for all locally installed modules.
Local cache is obtained/updated with command `Update-PSRepositoryCache` (or using its alias `psaptgetupdate`).
Searching local cache is about 20-100 times faster than online search performed via `Update-Module` command from PowerShellGet.

As this module is just a proof-of-concept, actual update is not implemented.
You need to run cmdlet with -Verbose or -WhatIf to see actual updatable modules.

## EXAMPLES

### Example 1

```powershell
PS C:\> Update-ModuleFromCache AzureRM -WhatIf
```

It will check if there is newer version of AzureRM module available using local cache.

### Example 2

```powershell
PS C:\> $Names = (Get-Module AzureRM.* -ListAvailable).Name | Select -unique; Update-ModuleFromCache $Names -WhatIf
```

It will check for all AzureRM modules if they can be updated or not
While standard command Update-Module will run for minutes, this command will run for seconds.

### Example 3

```powershell
PS C:\> Update-ModuleFromCache -WhatIf
```

It will check for all locally installed modules if they can be updated or not.
While standard command Update-Module will run for minutes, this command will run for seconds.

## PARAMETERS

### -ModuleName
Specifies the names of one or more modules that should be checked for updates.
If no module names are specified, Update-ModuleFromCache uses Get-Module -ListAvailable to obtain list of all modules.
The only modules that are checked are those that exactly match specified names.
If no matches are found for the specified modules or no newer version is found, no error occurs.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Name

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NamesOnly
If this switch is specified, command will return only names of modules that can be updated. It can be passed via pipeline to standard Update-Module cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
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
