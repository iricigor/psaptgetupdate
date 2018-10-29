#
# Module definitions
#

$Script:Config = New-Object PSObject -Property @{

    # Main Paths
    IndexPath = Join-Path ($env:LOCALAPPDATA) 'PSGalleryIndex'
    TempPath  = Join-Path ($env:TEMP)         'PSGalleryIndex'

    # Index file name
    IndexFile = 'PSGalleryIndex.zip'

    # Config file names
    ModulesCache = 'Modules.Cache'
    ScriptsCache = 'Scripts.Cache'
    CommandsCache = 'Commands.Cache'
}

#
# Calculated paths used across the module
#

# TempPath File Locations, used like $TP.Modules, should be deleted at the end of command run
$Script:TP = New-Object PSObject -Property @{
    Index    = Join-Path $Config.TempPath $Config.IndexFile
    Modules  = Join-Path $Config.TempPath $Config.ModulesCache
    Scripts  = Join-Path $Config.TempPath $Config.ScriptsCache
    Commands = Join-Path $Config.TempPath $Config.CommandsCache
}

# IndexPath File Locations, used like $IP.Modules
$Script:IP = New-Object PSObject -Property @{
    Modules  = Join-Path $Config.IndexPath $Config.ModulesCache
    Scripts  = Join-Path $Config.IndexPath $Config.ScriptsCache
    Commands = Join-Path $Config.IndexPath $Config.CommandsCache
}