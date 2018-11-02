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
        Write-Log -Message "$FunctionName starting" -TimeStampFormat 'G'
    }

    PROCESS {
        foreach ($C1 in $CommandName) {
            Select-String -Path $IP.Commands -Pattern "^$C1 " | % {
                Write-Log -Message "Returning value for $C1" -Verbosity Info
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
        Write-Log -Message "$FunctionName completed" -TimeStampFormat 'G'
    }    
}