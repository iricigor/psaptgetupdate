function Update-PSRepositoryCache {

    # updates local package cache, downloads and extracts index.zip file
    # priority 1: expected run time is couple of seconds (1-5 seconds), together with download and extract

    [CmdletBinding()]
    param (
        [switch]$LocalOnly # if used, index file must be generated with New-PSRepositoryCache
    )
    
    # function begin phase
    $FunctionName = $MyInvocation.MyCommand.Name
    Write-Verbose -Message "$(Get-Date -f G) $FunctionName starting"


    #
    # get a index.zip file to $TP.Index
    #

    if (!$LocalOnly) {
        # download file from the internet
        Write-Verbose -Message "$(Get-Date -f T)  downloading index from the Internet"
        # temporary remove ProgressBar, https://stackoverflow.com/questions/28682642/powershell-why-is-using-invoke-webrequest-much-slower-than-a-browser-download
        $OldProgressPreference = $ProgressPreference; $ProgressPreference = 'SilentlyContinue' 
        Invoke-WebRequest -Uri 'https://psgallery.blob.core.windows.net/index/PSGalleryIndex.zip' -Verbose:$false -OutFile $TP.Index | Out-Null
        $ProgressPreference = $OldProgressPreference
        Write-Verbose -Message "$(Get-Date -f T)  downloading completed, index file $(size $TP.Index)MB large"
    }
    

    #
    # unzip index.zip
    #

    Write-Verbose -Message "$(Get-Date -f T)  expanding archive to $($Config.IndexPath)"
    Expand-Archive $TP.Index -DestinationPath $Config.IndexPath -Force
    Write-Verbose -Message "$(Get-Date -f T)  expanded total $((gci $Config.IndexPath).Count) files" # TODO: This lists also old files from folder

    # the end
    Write-Verbose -Message "$(Get-Date -f G) $FunctionName completed"
}