function Update-PSRepositoryCache {

    # updates local package cache, downloads and extracts index.zip file
    # priority 1: expected run time is couple of seconds (1-5 seconds), together with download and extract

    [CmdletBinding()]
    param (

    )
    
    # function begin phase
    $FunctionName = $MyInvocation.MyCommand.Name
    Write-Log -Message "$FunctionName starting" -TimeStampFormat 'G'


    #
    # get a index.zip file to $TP.Index
    #

    Write-Log -Message "Downloading index from the Internet"
    # temporary remove ProgressBar, https://stackoverflow.com/questions/28682642/powershell-why-is-using-invoke-webrequest-much-slower-than-a-browser-download
    $OldProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'
    CreateTempFolder
    Invoke-WebRequest -Uri 'https://psgallery.blob.core.windows.net/index/PSGalleryIndex.zip' -Verbose:$false -OutFile $TP.Index | Out-Null
    $ProgressPreference = $OldProgressPreference
    Write-Log -Message "Downloading completed, index file $(size $TP.Index)MB large"
    

    #
    # unzip index.zip
    #

    Write-Log -Message "Expanding archive to $($Config.IndexPath)"
    Expand-Archive $TP.Index -DestinationPath $Config.IndexPath -Force
    Write-Log -Message "expanded total $((gci $Config.IndexPath).Count) files" # TODO: This lists also old files from folder

    # the end
    RemoveTempFolder
    Write-Log -Message "$FunctionName completed" -TimeStampFormat 'G'
}