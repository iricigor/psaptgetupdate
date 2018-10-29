function Update-ModuleFromCache {

    # searches local cache for information about updatable modules
    # priority 1: it should read index file in range of 100ms (i.e. upto 100ms)

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$false,ValueFromPipeline=$true)][alias('Name')] [string[]]$ModuleName
    )

    BEGIN {
        # function begin phase
        $FunctionName = $MyInvocation.MyCommand.Name
        Write-Verbose -Message "$(Get-Date -f G) $FunctionName starting"
    }

    PROCESS {
        if (!$ModuleName) {
            Write-Verbose -Message "$(Get-Date -f T)  reading list of all modules from system"
            $AllModules = Get-Module -ListAvailable
            $ModuleName = $AllModules.Name | Select -Unique
        }
        foreach ($M1 in $ModuleName) {
            # {"Name":"AzureRM.profile",
            $RegEx = [regex]::Escape('{"Name":"'+$M1+'",')
            Select-String -Path $IP.Modules -Pattern "^$RegEx" | % {
                Write-Verbose -Message "$(Get-Date -f T)  checking $M1 for updatable version"
                $ModuleOnline = ConvertFrom-Json ($_.Line)
                if ($AllModules) {
                    $LocalModule = $AllModules | ? Name -eq $M1 | Sort Version | Select -Last 1
                } else {
                    Write-Verbose -Message "$(Get-Date -f T)  searching for local module"
                    $LocalModule = Get-Module $M1 -List -ea 0 -Verbose:$false | Sort Version | Select -Last 1
                }
                
                if (!$LocalModule) {
                    Write-Error "$FunctionName cannot find module $M1 in local module directories"
                    continue
                }
                if ($ModuleOnline.Version -gt $LocalModule.Version) {
                    $Target = "Module '$M1' version $($LocalModule.Version)"
                    $Action = "Update to version $($ModuleOnline.Version)"
                    Write-Verbose -Message "$(Get-Date -f T)  Performing action $Action on target $Target"
                    if ($PSCmdlet.ShouldProcess($Target,$Action)) {
                        # Update not implemented in POC, run with -WhatIf or -Verbose switch
                    }
                }
            }
        }
    }
    
    END {
        Write-Verbose -Message "$(Get-Date -f G) $FunctionName completed"
    }    

}