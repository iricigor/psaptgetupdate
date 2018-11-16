function Find-ModuleFromCache {

    # searches local cache for information about modules
    # priority 1: it should read index file in range of 100ms (i.e. upto 100ms)

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)][alias('Name')] [string[]]$ModuleName
    )

    BEGIN {
        $FunctionName = $MyInvocation.MyCommand.Name
        Write-Log -Message "$FunctionName starting" -TimeStampFormat 'G'
    }

    PROCESS {
        foreach ($M1 in $ModuleName) {
            # {"Name":"AzureRM.profile",
            $RegEx = [regex]::Escape('{"Name":"'+$M1+'",')
            $IndexFile = $IP.Modules + (Hash $M1)
            Write-Log -Message "finding module info in $IndexFile"
            Select-String -Path $IndexFile -Pattern "^$RegEx" | ForEach-Object {
                Write-Log -Message "returning info about module $M1" -Verbosity Info
                ConvertFrom-Json ($_.Line)
            }
        }
    }

    END {
        Write-Log -Message "$FunctionName completed" -TimeStampFormat 'G'
    }

}