function New-PSRepositoryCache {

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
    
    # internal function
    function size ($Path) {[int]( (gi $Path).Length / 1MB)} # size in MB of a given file
    
    
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
    # Prepare cache location
    #
    
    if (!(Test-Path $Config.TempPath)) {
        New-Item $Config.TempPath -ItemType Directory -Force | Out-Null
    }


    #
    # create modules index
    #

    # $ModulesFile = Join-Path ($env:TEMP) 'Modules.cache'
    # $ModulesFile = Join-Path $Config.TempPath $Config.ModulesCache
    Write-Verbose -Message "$(Get-Date -f T) Packing modules to $($TP.Modules)..."
    $Lines = foreach ($M1 in $Modules) {ConvertTo-Json $M1 -Compress}
    Set-Content -Path $TP.Modules -Value $Lines
    Write-Verbose -Message "$(Get-Date -f T) Modules packed to $(size $TP.Modules)MB large file"



    #
    # create scripts index
    #

    Write-Verbose -Message "$(Get-Date -f T) Packing scripts to $($TP.Scripts)..."
    $Lines = foreach ($S1 in $Scripts) {ConvertTo-Json $S1 -Compress}
    Set-Content -Path $TP.Scripts -Value $Lines
    Write-Verbose -Message "$(Get-Date -f T) Scripts packed to $(size $TP.Scripts)MB large file"



    #
    # create commands index
    #

    Write-Verbose -Message "$(Get-Date -f T) Packing commands to $($TP.Commands)..."
    $Lines = foreach ($M1 in $Modules) {($M1.Includes.Command -split ' ') -replace '$'," $($M1.Name) $($M1.Version)"} # line format: Command Module Version
    Set-Content -Path $TP.Commands -Value $Lines
    Write-Verbose -Message "$(Get-Date -f T) Commands packed to $(size $TP.Commands)MB large file"
    

    #
    # pack all files
    #

    # TODO: We can check if there are command line zip available, i.e. gcm *zip*
    Compress-Archive -Path $TP.Modules,$TP.Scripts,$TP.Commands -DestinationPath $TP.Index -CompressionLevel Optimal -Force
    Write-Verbose -Message "$(Get-Date -f T) Index packed to $(size $TP.Index)MB large file"

    if (!$LocalOnly) {
        # TODO: Upload zip to storage account
    }

    # TODO: Clean-up temporary files

    Write-Verbose -Message "$(Get-Date -f G) $FunctionName completed"
}