---
external help file: PSAptGetUpdate-help.xml
Module Name: PSAptGetUpdate
online version: https://github.com/iricigor/psaptgetupdate/blob/master/Docs/Update-PSRepositoryCache.md
schema: 2.0.0
---

# Update-PSRepositoryCache

## SYNOPSIS
Updates local PS repository cache. Main command in module.

## SYNTAX

```
Update-PSRepositoryCache [<CommonParameters>]
```

## DESCRIPTION

Updates local PS repository cache by downloading and extracting information about modules, commands and scripts.
If cache is not present, it will create one.

This is main command in module psaptgetupdate.
Command have alias named the same as module, psaptgetupdate.
Command functionality is based on Linux command apt-get update.

Command is executed automatically when module is imported.
Command execution lasts only a few seconds.
It has no custom parameters, but it supports common parameters (like -Verbose).

## EXAMPLES

### Example 1

```powershell
PS C:\> psaptgetupdate
```

Downloads zipped index file and extract it to application data location.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
