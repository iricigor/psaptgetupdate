function Find-ScriptFromCache {

    # searches local cache for information about scripts
    # priority 1: it should read index file in range of 100ms (i.e. upto 100ms)

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [alias('Name')]
        [string]$ScriptName
    )

    # function begin phase
    $FunctionName = $MyInvocation.MyCommand.Name
    Write-Verbose -Message "$(Get-Date -f G) $FunctionName starting"

    $ScriptsCache = Join-Path (Join-Path ($env:LOCALAPPDATA) 'PSGalleryIndex') 'Scripts.cache'

    # {"Name":"Get-WindowsAutoPilotInfo",
    $RegEx = [regex]::Escape('{"Name":"'+$ScriptName+'",')
    Select-String -Path $ScriptsCache -Pattern "^$RegEx" | % {ConvertFrom-Json ($_.Line)}
    
    Write-Verbose -Message "$(Get-Date -f G) $FunctionName completed"
}