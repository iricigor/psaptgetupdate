function Write-Log {
    param (
        
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,Position=0)]
        [string[]]$Message,
        
        [ValidateSet('Info','Verbose','Warning','Debug','Error')]
        [string]$Verbosity = 'Verbose',
        
        [string]$TimeStampFormat = 'T',
        
        [string]$LogFileLocation = $IP.Log

        # TODO: Add ParameterSets to simplify usage
    )

    BEGIN {
        $TimeStamp = Get-Date -Format $TimeStampFormat
        #TODO: Implement log rotation, daily or after size?
        if (!(Test-Path $LogFileLocation)) {
            New-Item $LogFileLocation -ItemType File -Force
        }
    }

    PROCESS {
        foreach ($M1 in $Message) {
            
            # screen output
            $M = "$TimeStamp $M1"
            switch ($Verbosity) {
                'Verbose' {Write-Verbose $M}
                'Warning' {Write-Warning $M}
                'Debug'   {Write-Debug $M}
                'Error'   {Write-Error $M}
            }

            # log file output
            if ($LogFileLocation) {
                "$TimeStamp $($Verbosity.ToUpper()) $Message" | Out-File -LiteralPath $LogFileLocation -Encoding utf8 -Append -Force
            }            
        }
    }

    END {

    }
    
}

Set-Alias -Name wLog -Value Write-Log