function Update-PSRepositoryCache {

    # updates local package cache, downloads and extracts index.zip file
    # priority 1: expected run time is couple of seconds (1-5 seconds), together with download and extract

    [CmdletBinding()]
    param (

    )

    # function begin phase
    $FunctionName = $MyInvocation.MyCommand.Name
    Write-Log -Message "$FunctionName starting" -TimeStampFormat 'G'
    $LockFileCreated = $false # not yet


    #
    # Prevent too fast updates
    #
    try {
        $Age = [int](((Get-Date) - (Get-Item $IP.Commands -ea Stop).LastWriteTime).TotalSeconds)
    } catch {
        $Age = 11
    }

    if ($Age -lt 10) {
        Write-Log -Message "Skipping download, as index file is $Age seconds old"    
    } elseif (Test-Path $TP.LockFile) {
        Write-Log -Message "Skipping download as another process has lock file $($TP.LockFile)" -Verbosity Warning
    } else {

        #
        # get a index.zip file to $TP.Index
        #

        try {

            CreateTempFolder
            Write-Log -Message "Creating lock file $($TP.LockFile)"
            New-Item $TP.LockFile -ItemType File -Force -ErrorAction Stop | Out-Null
            $LockFileCreated = $true
            Write-Log -Message "Downloading index from the Internet"
            # temporary remove ProgressBar, https://stackoverflow.com/questions/28682642/powershell-why-is-using-invoke-webrequest-much-slower-than-a-browser-download
            $OldProgressPreference = $ProgressPreference
            $ProgressPreference = 'SilentlyContinue'
            $Response = Invoke-WebRequest -Uri 'https://psgallery.blob.core.windows.net/index/PSGalleryIndex.zip' -Verbose:$false -OutFile $TP.Index -PassThru
            $ProgressPreference = $OldProgressPreference
            try {
                [string]$AgeString = [int](((Get-Date)-[datetime]($Response.Headers.'Last-Modified')).TotalMinutes)
            } catch {
                $AgeString = 'unknown'
            }
            Write-Log -Message "Downloading completed, index file is $(size $TP.Index)MB large and $AgeString minutes old"


            #
            # unzip index.zip
            #

            Write-Log -Message "Expanding archive to $($Config.IndexPath)"
            Microsoft.PowerShell.Archive\Expand-Archive $TP.Index -DestinationPath $Config.IndexPath -Force
            Write-Log -Message "Expanded total $((Get-ChildItem $Config.IndexPath).Count) files" # FIXME: This lists also old files from folder

            #
            # Touch one file to prevent too fast/double updates
            #
            
            (Get-Item $IP.Commands).LastWriteTime = Get-Date

            # the end
            
            RemoveTempFolder
        } catch {
            Write-Log -Message "Cache update failed: $_"
        } finally {
            if ($LockFileCreated -and (Test-Path $TP.LockFile)) {
                Remove-Item $TP.LockFile -Force
            }
        }


    }

    Write-Log -Message "$FunctionName completed" -TimeStampFormat 'G'
}

Set-Alias -Name 'psaptgetupdate' -Value Update-PSRepositoryCache
