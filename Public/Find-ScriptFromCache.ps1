function Find-ScriptFromCache {

    # searches local cache for information about scripts
    # priority 1: it should read index file in range of 100ms (i.e. upto 100ms)

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)][alias('Name')] [string[]]$ScriptName
    )

    BEGIN {
        # function begin phase
        $FunctionName = $MyInvocation.MyCommand.Name
        Write-Log -Message "$FunctionName starting" -TimeStampFormat 'G'
    }

    PROCESS {
        foreach ($S1 in $ScriptName) {
            # {"Name":"Get-WindowsAutoPilotInfo",
            $RegEx = [regex]::Escape('{"Name":"'+$S1+'",')
            Select-String -Path $IP.Scripts -Pattern "^$RegEx" | % {
                Write-Log -Message "Returning value for $S1" -Verbosity Info
                ConvertFrom-Json ($_.Line)
            }
        }
    }

    END {
        Write-Log -Message "$FunctionName completed" -TimeStampFormat 'G'
    }

}