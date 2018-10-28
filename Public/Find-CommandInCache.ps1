function Find-CommandInCache {

    # searches local cache for information about commands
    # priority 1: it should read index file in range of 100ms (i.e. upto 100ms)

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [alias('Name')]
        [string]$CommandName
    )

    # function begin phase
    $FunctionName = $MyInvocation.MyCommand.Name
    Write-Verbose -Message "$(Get-Date -f G) $FunctionName starting"

    $CommandsCache = Join-Path (Join-Path ($env:LOCALAPPDATA) 'PSGalleryIndex') 'Commands.cache' # TODO: Not Linux compatible

    Select-String -Path $CommandsCache -Pattern "^$CommandName" | % {
        $obj = $_.Line -split ' '
        New-Object PSObject -Property @{
            Name = $CommandName
            Version = $obj[2]
            ModuleName = $obj[1]
            Repository = 'PSGallery'
        }
    }

    Write-Verbose -Message "$(Get-Date -f G) $FunctionName completed"
}