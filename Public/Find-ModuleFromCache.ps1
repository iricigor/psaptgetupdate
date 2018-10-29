function Find-ModuleFromCache {

    # searches local cache for information about modules
    # priority 1: it should read index file in range of 100ms (i.e. upto 100ms)

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)][alias('Name')] [string[]]$ModuleName
    )

    BEGIN {
        # function begin phase
        $FunctionName = $MyInvocation.MyCommand.Name
        Write-Verbose -Message "$(Get-Date -f G) $FunctionName starting"
    }

    PROCESS {
        foreach ($M1 in $ModuleName) {
            # {"Name":"AzureRM.profile",
            $RegEx = [regex]::Escape('{"Name":"'+$M1+'",')
            Select-String -Path $IP.Modules -Pattern "^$RegEx" | % {ConvertFrom-Json ($_.Line)}
        }
    }
    
    END {
        Write-Verbose -Message "$(Get-Date -f G) $FunctionName completed"
    }    

}