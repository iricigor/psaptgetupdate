function Find-ModuleFromCache {

    # searches local cache for information about modules
    # priority 1: it should read index file in range of 100ms (i.e. upto 100ms)

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [alias('Name')]
        [string]$ModuleName
    )

    # function begin phase
    $FunctionName = $MyInvocation.MyCommand.Name
    Write-Verbose -Message "$(Get-Date -f G) $FunctionName starting"

    $ModulesCache = Join-Path (Join-Path ($env:LOCALAPPDATA) 'PSGalleryIndex') 'Modules.cache'

    # {"Name":"AzureRM.profile",
    $RegEx = [regex]::Escape('{"Name":"'+$ModuleName+'",')
    Select-String -Path $ModulesCache -Pattern "^$RegEx" | % {ConvertFrom-Json ($_.Line)}
    
    Write-Verbose -Message "$(Get-Date -f G) $FunctionName completed"
}