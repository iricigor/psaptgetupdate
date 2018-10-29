function Find-CommandFromCache {

    # searches local cache for information about commands
    # priority 1: it should read index file in range of 100ms (i.e. upto 100ms)

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)][alias('Name')] [string]$CommandName
    )

    BEGIN {
        # function begin phase
        $FunctionName = $MyInvocation.MyCommand.Name
        Write-Verbose -Message "$(Get-Date -f G) $FunctionName starting"    
    }

    PROCESS {
        foreach ($C1 in $CommandName) {
            Select-String -Path $IP.Commands -Pattern "^$C1" | % {
                $obj = $_.Line -split ' '
                New-Object PSObject -Property @{
                    Name = $C1
                    Version = $obj[2]
                    ModuleName = $obj[1]
                    Repository = 'PSGallery'
                }        
            }
        }
    }

    END {
        Write-Verbose -Message "$(Get-Date -f G) $FunctionName completed"
    }    
}