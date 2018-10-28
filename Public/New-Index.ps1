function New-Index {

    # creates zipped index of all modules and scripts from PSGallery
    # priority 1: downloadable zipped index file should have size in range of megabytes (1-5MB)
    # running time is not so important, it should be in range of minutes (i.e. 1-15 minutes)
    # on home computer, downloading modules and scripts takes 6 minutes

    [CmdletBinding()]
    param (
        [switch]$LocalOnly,
        [switch]$ReadLocal = $true # for testing, we use this flag
    )
 
    # function begin phase
    $FunctionName = $MyInvocation.MyCommand.Name
    Write-Verbose -Message "$(Get-Date -f G) $FunctionName starting"
    
    
    
    #
    # load data from PowerShell Gallery
    #

    if ($ReadLocal) {
        Write-Verbose -Message "$(Get-Date -f T) Reading data from local copy"
        $DataPath = Join-Path (Join-Path ($env:LOCALAPPDATA) 'PSGalleryIndex') '0'
        $Modules = Get-Content (Join-Path $DataPath 'Modules.json') -Raw | ConvertFrom-Json
        Write-Verbose -Message "$(Get-Date -f T) Found $($Modules.Count) modules"
        $Scripts = Get-Content (Join-Path $DataPath 'Scripts.json') -Raw | ConvertFrom-Json
        Write-Verbose -Message "$(Get-Date -f T) Found $($Scripts.Count) modules"
    } else {
        Write-Verbose -Message "$(Get-Date -f T) Starting to read data from PSGallery"
        $Modules = Find-Module * -Repository PSGallery
        Write-Verbose -Message "$(Get-Date -f T) Found $($Modules.Count) modules"
        $Scripts = Find-Script * -Repository PSGallery
        Write-Verbose -Message "$(Get-Date -f T) Found $($Scripts.Count) modules"
    }



    #
    # create modules index
    #

    $ModulesFile = Join-Path ($env:TEMP) 'Modules.cache'
    $Lines = foreach ($M1 in $Modules) {ConvertTo-Json $M1 -Compress}
    Set-Content -Path $ModulesFile -Value $Lines
    Write-Verbose -Message "$(Get-Date -f T) Modules packed to $([int]((gi $ModulesFile).Length / 1MB))MB large file"



    #
    # create scripts index
    #

    $ScriptsFile = Join-Path ($env:TEMP) 'Scripts.cache'
    $Lines = foreach ($S1 in $Scripts) {ConvertTo-Json $S1 -Compress}
    Set-Content -Path $ScriptsFile -Value $Lines
    Write-Verbose -Message "$(Get-Date -f T) Scripts packed to $([int]((gi $ScriptsFile).Length / 1MB))MB large file"



    #
    # create commands index
    #

    Write-Verbose -Message "$(Get-Date -f T) creating commands index"
    $CommandsFile = Join-Path ($env:TEMP) 'Commands.cache'
    $Lines = foreach ($M1 in $Modules) {($M1.Includes.Command -split ' ') -replace '$'," $($M1.Name) $($M1.Version)"}
    Set-Content -Path $CommandsFile -Value $Lines
    Write-Verbose -Message "$(Get-Date -f T) Commands packed to $([int]((gi $CommandsFile).Length / 1MB))MB large file"
    # TODO: Add module version also


    #
    # pack all files
    #

    $DestinationFile = Join-Path ($env:LOCALAPPDATA) 'PSGalleryIndex.zip'
    # TODO: We can check if there are command line zip available, i.e. gcm *zip*
    Compress-Archive -Path $ModulesFile,$ScriptsFile,$CommandsFile -DestinationPath $DestinationFile -CompressionLevel Optimal -Force
    Write-Verbose -Message "$(Get-Date -f T) Index packed to $([int]((gi $DestinationFile).Length / 1MB))MB large file"

    if (!$LocalOnly) {
        # TODO: Upload zip to storage account
    }

    # TODO: Clean-up temporary files

    Write-Verbose -Message "$(Get-Date -f G) $FunctionName completed"
}