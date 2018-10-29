[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost','')]
param()

$ModName = 'PSAptGetUpdate'
Get-Module $ModName | Remove-Module -Force

Write-Host "`n`n$ModName module import starting`n" -ForegroundColor Cyan

#
# Module definitions
#

$Script:Config = New-Object PSObject -Property @{
    # Main Paths
    IndexPath = Join-Path ($env:LOCALAPPDATA) 'PSGalleryIndex'
    TempPath  = Join-Path ($env:TEMP)         'PSGalleryIndex'
    # Index file
    IndexFile = 'PSGalleryIndex.zip'
    # Config file names
    ModulesCache = 'Modules.Cache'
    ScriptsCache = 'Scripts.Cache'
    CommandsCache = 'Commands.Cache'
}

#
# Import main functions
#

$Public = @(Get-ChildItem (Join-Path $PSScriptRoot 'Public') -Filter *.ps1)
$Private = @(Get-ChildItem (Join-Path $PSScriptRoot 'Private') -Filter *.ps1 -ErrorAction SilentlyContinue)
$MaxLen = ($Private+$Public).Name | ForEach-Object {$_.Length} | Sort-Object | Select-Object -Last 1

foreach ($F in ($Private+$Public) ) {

    Write-Host ("Importing $($F.Name)... ") -NoNewline
    Write-Host $(' '*($MaxLen - $F.Name.Length)) -NoNewline

    try {
        . ($F.FullName)
        Write-Host '  OK  ' -ForegroundColor Green
    } catch {
        Write-Host 'FAILED' -ForegroundColor Red
    }
}

Export-ModuleMember -Function $Public.BaseName
Write-Host "Exported $($Public.Count) member(s)"
Export-ModuleMember -Alias *


Write-Host "`nModule web site github.com/iricigor/aptgetupdate"
Write-Host "`nType 'Get-Command -Module $ModName' for list of commands, 'Get-Help <CommandName>' for help, or"
Write-Host "'Get-Command -Module $ModName | Get-Help | Select Name, Synopsis' for explanation on all commands`n"

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