---
external help file: PSAptGetUpdate-help.xml
Module Name: psaptgetupdate
online version:
schema: 2.0.0
---

# New-PSRepositoryCache

## SYNOPSIS

Cmdlet reads information from PS Repository and packs it.

## SYNTAX

```
New-PSRepositoryCache [[-ReadFromPath] <String>] [-Local] [<CommonParameters>]
```

## DESCRIPTION
Cmdlet New-PSRepositoryCache reads information about modules, scripts and commands from PS Repository.
Afterwards, it is packing it for quick download by clients.

Cmdlet is intended to be used on server-side of the system, but it can be used for testing purposes also on local machine. See parameters section for more info.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-PSRepositoryCache
```

Command will read the information from online PS Repository and pack it in temporary location. Notice that reading information will run for a long time (about 5 minutes).


## PARAMETERS

### -Local

By default, cmdlet uploads packed index file to a Storage Account.
If this switch is specified, then it will leave data only on local filesystem.

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

### -ReadFromPath

By default, cmdlet reads live information from PS Repository. This operation can last for couple of minutes.

For testing purposes, you can specify custom local path as string, where from cmdlet will read required information.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

https://github.com/iricigor/psaptgetupdate