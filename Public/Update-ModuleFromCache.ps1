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
        Write-Log -Message "$FunctionName starting" -TimeStampFormat 'G'
        $SearchAll = $false
    }

    PROCESS {
        if (!$ModuleName) {
            Write-Log -Message "Reading list of all modules from the system"
            $SearchAll = $true
            $AllModules = Get-Module -ListAvailable -Verbose:$false | where {$_.RepositorySourceLocation.Host -eq 'www.powershellgallery.com'}
            $ModuleName = $AllModules.Name | Select -Unique
        }
        foreach ($M1 in $ModuleName) {
            # {"Name":"AzureRM.profile",
            $RegEx = [regex]::Escape('{"Name":"'+$M1+'",')
            $FoundOnline = $false
            $IndexFile = $IP.Modules + (Hash $M1)
            Select-String -Path $IndexFile -Pattern "^$RegEx" | % {
                Write-Log -Message "checking module $M1 for updatable version"
                $FoundOnline = $true
                $ModuleOnline = ConvertFrom-Json ($_.Line)
                if ($AllModules) {
                    $LocalModule = $AllModules | ? Name -eq $M1 | Sort-Object Version | Select -Last 1
                } else {
                    Write-Log -Message "searching for local module $M1"
                    $LocalModule = Get-Module $M1 -List -ea 0 -Verbose:$false | Sort-Object Version | Select -Last 1
                }

                if (!$LocalModule) {
                    Write-Log -Verbosity Error -Message "$FunctionName cannot find module $M1 in local module directories"
                    continue
                }
                if ([version]($ModuleOnline.AdditionalMetadata.NormalizedVersion) -gt $LocalModule.Version) {
                    $Target = "Module '$M1' version $($LocalModule.Version)"
                    $Action = "Update to version $($ModuleOnline.AdditionalMetadata.NormalizedVersion)" # it can be in wierd format, see bug #9
                    Write-Log -Message "Performing action $Action on target $Target"
                    if ($PSCmdlet.ShouldProcess($Target,$Action)) {
                        # Update not implemented in POC, run with -WhatIf or -Verbose switch
                    } else {
                        Write-Log -Message "Skipped performing action $Action on target $Target"
                    }
                }
            }
            if ((!$FoundOnline) -and (!$SearchAll)) {
                Write-Log -Message "Module '$M1' not found in Repository" -Verbosity Error
            }
        }
    }

    END {
        Write-Log -Message "$FunctionName completed" -TimeStampFormat 'G'
    }

}