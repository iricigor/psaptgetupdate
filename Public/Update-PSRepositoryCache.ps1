function Update-PSRepositoryCache {

    # updates local package cache, downloads and extracts index.zip file
    # priority 1: expected run time is couple of seconds (1-5 seconds), together with download and extract

    [CmdletBinding()]
    param (
        [switch]$LocalOnly = $true # for testing only we use this default
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
        # https://docs.microsoft.com/en-us/azure/storage/blobs/storage-manage-access-to-resources
        # CloudBlockBlob blob = new CloudBlockBlob(new Uri(@"https://storagesample.blob.core.windows.net/sample-container/logfile.txt"));
        # blob.DownloadToFile(@"C:\Temp\logfile.txt", System.IO.FileMode.Create);
        Write-Verbose -Message "$(Get-Date -f T)  downloading completed"
    }
    

    #
    # unzip index.zip
    #

    Write-Verbose -Message "$(Get-Date -f T)  expanding archive to $($Config.IndexPath)"
    # $IndexPath = Join-Path ($env:LOCALAPPDATA) 'PSGalleryIndex'
    Expand-Archive $TP.Index -DestinationPath $Config.IndexPath -Force
    Write-Verbose -Message "$(Get-Date -f T)  expanded total $((gci $Config.IndexPath).Count) files" # TODO: This lists also old files from folder


    Write-Verbose -Message "$(Get-Date -f G) $FunctionName completed"
}