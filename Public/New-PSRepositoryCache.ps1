function New-PSRepositoryCache {

    # creates zipped index of all modules and scripts from PSGallery
    # priority 1: downloadable zipped index file should have size in range of megabytes (1-5MB)
    # running time is not so important, it should be in range of minutes (i.e. 1-15 minutes)
    # on home computer, downloading modules and scripts takes 6 minutes

    [CmdletBinding()]

    param (
        [switch]$SkipUpload
    )
 
    # function begin phase
    $FunctionName = $MyInvocation.MyCommand.Name
    Write-Log -Message "$FunctionName starting" -TimeStampFormat 'G'

    
    #
    # load data from PowerShell Gallery
    #

    Write-Log -Message "Starting to read data from PSGallery"
    $Modules = Find-Module * -Repository PSGallery
    Write-Log -Message "Found $($Modules.Count) modules"
    $Scripts = Find-Script * -Repository PSGallery
    Write-Log -Message "Found $($Scripts.Count) scripts"


    CreateTempFolder

    #
    # create modules index
    #

    Write-Log -Message "Packing modules to $($TP.Modules)..."
    $Lines = foreach ($M1 in $Modules) {ConvertTo-Json $M1 -Compress}
    Set-Content -Path $TP.Modules -Value $Lines
    Write-Log -Message "Modules packed to $(size $TP.Modules)MB large file"


    #
    # create scripts index
    #

    Write-Log -Message "Packing scripts to $($TP.Scripts)..."
    $Lines = foreach ($S1 in $Scripts) {ConvertTo-Json $S1 -Compress}
    Set-Content -Path $TP.Scripts -Value $Lines
    Write-Log -Message "Scripts packed to $(size $TP.Scripts)MB large file"



    #
    # create commands index
    #

    Write-Log -Message "Packing commands to $($TP.Commands)..."
    $Lines = foreach ($M1 in $Modules) {($M1.Includes.Command -split ' ') -replace '$'," $($M1.Name) $($M1.Version)"}
    # generated lines are in following format: Command Module Version
    Set-Content -Path $TP.Commands -Value $Lines
    Write-Log -Message "Commands packed to $(size $TP.Commands)MB large file"
    

    #
    # pack all files
    #

    Compress-Archive -Path $TP.Modules,$TP.Scripts,$TP.Commands -DestinationPath $TP.Index -CompressionLevel Optimal -Force
    Write-Log -Message "Index packed to $(size $TP.Index)MB large file"


    #
    # upload new index
    #

    if ($SkipUpload) {
        Write-Log -Message "Skipping upload due to switch"
    } elseif ($Storage.Key) {
        # Upload zip to storage account
        Write-Log -Message "Connecting to cloud storage"
        $StorageContext = New-AzureStorageContext -StorageAccountName $Storage.Account -StorageAccountKey $Storage.Key -Protocol HTTPS
        if (!(Get-AzureStorageContainer -Context $StorageContext -Container 'index' -ea 0)) {
            Write-Log -Verbosity Warning "Creating new storage container 'index'"
            New-AzureStorageContainer -Context $StorageContext -Container 'index' -PublicAccess Container | Out-Null
        }
        Write-Log -Message "Uploading index to cloud storage"
        Set-AzureStorageBlobContent -Context $StorageContext -Container 'index' -File $TP.Index -Force -Verbose:$false | Out-Null
        Write-Log -Message "New index uploaded to cloud storage"
    } else {
        Write-Log -Message "No Storage Key present, skipping upload to cloud storage"
    }
       

    RemoveTempFolder
    Write-Log -Message "$FunctionName completed" -TimeStampFormat 'G'
}