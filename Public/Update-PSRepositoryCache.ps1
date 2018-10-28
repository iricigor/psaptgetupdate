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
    # get a index.zip file
    #

    $IndexZip = Join-Path ($env:LOCALAPPDATA) 'PSGalleryIndex.zip'
    if (!$LocalOnly) {
        # download file from the internet
        Write-Verbose -Message "$(Get-Date -f G) $FunctionName downloading index from the Internet"
        # https://docs.microsoft.com/en-us/azure/storage/blobs/storage-manage-access-to-resources
        # CloudBlockBlob blob = new CloudBlockBlob(new Uri(@"https://storagesample.blob.core.windows.net/sample-container/logfile.txt"));
        # blob.DownloadToFile(@"C:\Temp\logfile.txt", System.IO.FileMode.Create);
        Write-Verbose -Message "$(Get-Date -f G) $FunctionName downloading completed"
    }
    

    #
    # unzip index.zip
    #

    Write-Verbose -Message "$(Get-Date -f G) $FunctionName expanding archive"
    $IndexPath = Join-Path ($env:LOCALAPPDATA) 'PSGalleryIndex'
    Expand-Archive $IndexZip -DestinationPath $IndexPath -Force
    Write-Verbose -Message "$(Get-Date -f G) $FunctionName expanded total $((gci $IndexPath).Count) files" # TODO: This lists also old files from folder


    Write-Verbose -Message "$(Get-Date -f G) $FunctionName completed"
}